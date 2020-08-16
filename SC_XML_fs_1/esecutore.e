note
	description: "Classe radice del progetto"
	author: "EN + studenti corsi PSI"
	date: "$Date$"
	revision: "  "

class
	ESECUTORE

create
	make

feature -- Attributi

	state_chart: CONFIGURAZIONE
			-- rappresenta la SC durante la sua esecuzione

	ambiente_corrente: AMBIENTE
			-- rappresenta l'ambiente in cui la SC si evolve

	conf_base_corrente: ARRAY [STATO]
			-- insieme degli stati base nella configurazione corrente della SC e non di tutti gli stati attivi

feature -- Creazione sia per i test che per esecuzione interattiva

	make (nomi_files: ARRAY [STRING])
			-- prepara ed esegue la SC con i parametri passati come argomento
			-- per esecuzione interattiva gli argomenti vanno scritti in Eiffel Studio
			-- nel menu "Execution" -> "Execution Parameters" -> "Add"
			-- doppio click su spazio bianco accanto a "Arguments"
			-- scrivere i parametri ognuno tra doppi apici includendo l'estensione
			-- .xml per il file della SC e .txt per il file degli eventi
		do
			print ("%N=========%N CREAZIONE INIZIO%N")
			print ("crea la SC in " + nomi_files [1] + "%N")
			create state_chart.make (nomi_files [1])
			create ambiente_corrente.make_empty
			create conf_base_corrente.make_empty
			conf_base_corrente.copy (state_chart.conf_base_iniziale)
			if not state_chart.ha_problemi_con_il_file_della_sc then
				print ("e la esegue con gli eventi in " + nomi_files [2] + "%N")
				ambiente_corrente.acquisisci_eventi (nomi_files [2])
				print ("acquisiti eventi %N")
				if not ambiente_corrente.verifica_eventi_esterni (state_chart) then
					print ("AVVISO: nel file ci sono eventi che la SC non conosce %N")
				end
				print ("eventi verificati, si esegue la SC %N")
				evolvi_SC (ambiente_corrente.eventi_esterni)
			else
				print ("Ci sono problemi con il file xml.%N")
				print ("Non si esegue la SC.%N")
			end
			print ("%N CREAZIONE FINE%N=========%N")
		end

feature -- evoluzione della statechart

	evolvi_SC (eventi: ARRAY [LINKED_SET [STRING]])
		local
			istante: INTEGER
			prossima_conf_base: ARRAY [STATO]
			transizioni_eseguibili: ARRAY[TRANSIZIONE]
			transizione_corrente: TRANSIZIONE
		do
			print ("%Nentrato in evolvi_SC:  %N %N")
			from
				istante := 1
			until
				stato_final (conf_base_corrente) or istante > eventi.count
			loop
				if attached eventi [istante] as eventi_correnti then
					stampa_conf_corrente (istante)
					create prossima_conf_base.make_empty
					transizioni_eseguibili:=trova_transizioni_eseguibili(eventi_correnti, state_chart.condizioni)
					across conf_base_corrente as cbc
					loop
						transizione_corrente := cbc.item.transizione_abilitata (eventi_correnti, state_chart.condizioni)
						if attached transizione_corrente as tc and then transizioni_eseguibili.has(tc) then
							esegui_azioni (tc, cbc.item)
							trova_default (tc.target, prossima_conf_base)
						-- MODIFICA PER CONSIDERARE I FORK
						 if tc.fork and attached tc.multi_target as tcmt then
						 	across tcmt as x loop
						 		prossima_conf_base.force (x.item , prossima_conf_base.count + 1)
						 		x.item.set_attivo
						 	end
						else aggiungi_paralleli (tc.target, prossima_conf_base)
						end
						-- FINE MODIFICA	
						else
							prossima_conf_base.force (cbc.item, prossima_conf_base.count + 1)
						end
					end
					prossima_conf_base := elimina_stati_inattivi(prossima_conf_base)
					prossima_conf_base := riordina_conf_base(prossima_conf_base)
					if not prossima_conf_base.is_empty then
						conf_base_corrente.copy (prossima_conf_base)
					end
				end
				istante := istante + 1
			end
			print ("%NHo terminato l'elaborazione degli eventi%N")
			stampa_conf_corrente (istante)
		end

	trova_transizioni_eseguibili(evento: LINKED_SET[STRING]; condizioni: HASH_TABLE [BOOLEAN, STRING]): ARRAY[TRANSIZIONE]
		-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
		-- restituisce l'array di transizioni che possono essere eseguite nello stato attuale del sistema
		-- rispettando le specifiche SCXML dell'ordine degli stati nel file .xml e della gerarchia (modello object-oriented)
		local
			transizioni: ARRAY[TRANSIZIONE]
			i: INTEGER
			uscita_precedente: detachable STATO
			sorgenti: ARRAY[STATO]
		do
			create transizioni.make_empty
			sorgenti := sorgenti_ordinate(evento, condizioni)
			from
				i:=sorgenti.lower
			until
				i=sorgenti.upper+1
			loop
				if i = sorgenti.upper or else not sorgenti[i].antenato_di(sorgenti[i+1]) then
					-- una sorgente che contiene la successiva non deve essere eseguita
					if attached sorgenti[i].transizione_abilitata (evento, condizioni) as ta then
						if attached uscita_precedente implies genitore_piu_grande(ta).incomparabile_con(uscita_precedente) then
							-- impedendo di uscire dal parallelo se con lo stesso evento non sono precedentemente uscito
							transizioni.force (ta,transizioni.count+1)
							uscita_precedente:=genitore_piu_grande(ta)
						end
					end
				end
				i:=i+1
			end

			Result:=transizioni
		end

	elimina_stati_inattivi(conf_da_modificare: ARRAY[STATO]): ARRAY[STATO]
	-- Arianna & Riccardo 26/04/2020
	-- elimina stati inattivi dalla configurazione
		local
			i: INTEGER
		do
			create Result.make_empty
			from
				i:=conf_da_modificare.lower
			until
				i=conf_da_modificare.upper+1
			loop
				if conf_da_modificare[i].attivo then
					Result.force(conf_da_modificare[i],Result.count+1)
				end
				i:=i+1
			end
		end

	genitore_piu_grande(transizione: TRANSIZIONE): STATO
	-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
	-- restituisce l'antenato più grande che contiene stato_corrente ed è contenuto nel contesto
		local
			contesto, stato_temp: detachable STATO
		do
			Result := transizione.sorgente

			if transizione.internal then
				contesto := transizione.sorgente
				across
					transizione.sorgente.figli as figli
				loop
					if figli.item.attivo then
						Result:=figli.item
					end
				end
			else
				contesto := trova_contesto (transizione.sorgente, transizione.target)
				from
					stato_temp := transizione.sorgente
				until
				 	stato_temp = contesto
				loop
					if attached stato_temp then
						Result := stato_temp
						stato_temp := stato_temp.genitore
					end
				end
			end

		end

	aggiungi_paralleli (target: STATO; prossima_conf_base: ARRAY [STATO])
		local
			i: INTEGER
		do
			target.set_attivo
			if attached {STATO_AND} target.genitore  as sgt and then not sgt.attivo then
				from
					i := sgt.initial.lower
				until
					i = sgt.initial.upper + 1
				loop
					if not sgt.initial [i].is_equal(target) then
						trova_default (sgt.initial [i], prossima_conf_base)
					end
					i := i + 1
				end
			end
			if attached target.genitore as sgt then
				aggiungi_paralleli (sgt, prossima_conf_base)
			end
		end

	trova_default (stato: STATO; prossima_conf_base: ARRAY [STATO])
		local
			i: INTEGER
		do
			stato.set_attivo
			esegui_onentry(stato)
			if not stato.initial.is_empty then
				from
					i := stato.initial.lower
				until
					i = stato.initial.upper + 1
				loop
					trova_default (stato.initial [i], prossima_conf_base)
					i := i + 1
				end
			else
				-- `stato' è uno stato atomico
				prossima_conf_base.force (stato, prossima_conf_base.count + 1)
			end
		end

	trova_contesto (p_sorgente, p_destinazione: STATO): detachable STATO
			-- trova il contesto in base alla specifica SCXML secondo cui il contesto
			-- è il minimo antenato comune PROPRIO a p_sorgente e p_destinazione
		local
			antenati: HASH_TABLE [STRING, STRING]
			corrente: STATO
		do
			create antenati.make (0)
				-- "marca" tutti gli antenati di p_sorgente incluso
			from
				corrente := p_sorgente.genitore
			until
				corrente = Void
			loop
				antenati.put (corrente.id, corrente.id)
				corrente := corrente.genitore
			end
				-- trova il piï¿½ basso antenato di p_destinazione in "antenati"
			from
				corrente := p_destinazione.genitore
			until
				corrente = Void or else antenati.has (corrente.id)
			loop
				corrente := corrente.genitore
			end
			Result := corrente
		end

feature -- esecuzione azioni

	esegui_azioni (transizione: TRANSIZIONE; stato: STATO)
		local
			contesto: detachable STATO
		do
			if transizione.internal then
				contesto := transizione.sorgente
			else
				contesto := trova_contesto (transizione.sorgente, transizione.target)
			end
			esegui_azioni_onexit (genitore_piu_grande(transizione))
			esegui_azioni_transizione (transizione.azioni)
			esegui_azioni_onentry (contesto, transizione.target)
		end

	esegui_onexit (p_stato_corrente: STATO)
		do
			if p_stato_corrente.onexit.count>0 then
				across
					p_stato_corrente.onexit as ox
				loop
					ox.item.action (state_chart.condizioni)
				end
			end
		end

	esegui_onentry (p_stato_corrente: STATO)
		do
			if p_stato_corrente.onentry .count>0 then
				across
					p_stato_corrente.onentry as oe
				loop
					oe.item.action (state_chart.condizioni)
				end
			end
		end

	esegui_azioni_onexit (stato_uscita: STATO)
	-- Arianna & Riccardo 13/05/2020
		do
			if not stato_uscita.stato_atomico then
				across
					stato_uscita.figli as sf
				loop
					if sf.item.attivo then
						esegui_azioni_onexit (sf.item)
					end
				end
			end
			esegui_onexit(stato_uscita)
			stato_uscita.set_inattivo
		end

	esegui_azioni_transizione (p_azioni: ARRAY [AZIONE])
		local
			i: INTEGER
		do
			from
				i := p_azioni.lower
			until
				i = p_azioni.upper + 1
			loop
				p_azioni [i].action (state_chart.condizioni)
				i := i + 1
			end
		end

	esegui_azioni_onentry (p_contesto: detachable STATO; p_target: STATO)
		do
			if attached p_target.genitore as sg and then sg /= p_contesto then
				esegui_azioni_onentry (p_contesto, sg)
				esegui_onentry(sg)
			end
		end

feature -- controllo

	stato_final (stato: ARRAY [STATO]): BOOLEAN
		require
			contesto: conf_base_corrente /= VOID
		local
			i: INTEGER
		do
			from
				i := conf_base_corrente.lower
			until
				i = conf_base_corrente.upper + 1
			loop
				if conf_base_corrente [i].finale then
					result := TRUE
				end
				i := i + 1
			end
		end

feature -- utilita

	riordina_conf_base (conf_base: ARRAY[STATO]): ARRAY[STATO]
	-- Agulini Claudia & Fiorini Federico 11/05/2020
	-- Viene usata per riordinare la configurazione rispettando l' ordine del file xml
	local
		j: INTEGER
		conf_ordinata: ARRAY[STATO]
	do
		create conf_ordinata.make_empty
		j := conf_ordinata.lower
		across
			state_chart.stati as stati
		loop
			if conf_base.has (stati.item) then
				conf_ordinata.force(stati.item, j)
				j := j + 1
			end
		end
		Result := conf_ordinata
	end

	sorgenti_ordinate (evento: LINKED_SET[STRING]; condizioni: HASH_TABLE [BOOLEAN, STRING]): ARRAY[STATO]
	-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
	-- Dati eventi e condizioni, restituisce l'array di sorgenti delle transizioni abilitate nella `conf_base_corrente'
	-- ordinate secondo l'ordine del file .xml
		do
			create Result.make_empty
			across
				conf_base_corrente as cbc
			loop
				if attached cbc.item.transizione_abilitata (evento, condizioni) as ta then
					Result.force (ta.sorgente, Result.count + 1)
				end
			end
			Result := riordina_conf_base(Result)
		end

	stampa_conf_corrente (indice: INTEGER)
		do
			print ("Istante corrente = ")
			print (indice)
			print ("%N")
			print ("  configurazione BASE corrente: ")
			across conf_base_corrente as cbc
			loop
				print (cbc.item.id + " ")
			end
			print (" %N")
			if indice <= ambiente_corrente.eventi_esterni.count then
				print ("  eventi correnti : ")
				across ambiente_corrente.eventi_esterni[indice] as eventi_correnti
				loop
					print (eventi_correnti.item + " ")
				end
				print (" %N")
			end
		end
end
