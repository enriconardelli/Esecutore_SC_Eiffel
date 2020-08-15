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
					transizioni_eseguibili:= trova_transizioni_eseguibili(eventi_correnti, state_chart.condizioni, state_chart.data_interi)
					across transizioni_eseguibili as te
					loop
						salva_storie(genitore_piu_grande(te.item))
						esegui_azioni (te.item)
						trova_default (te.item.target, prossima_conf_base)
						aggiungi_paralleli (te.item.target, prossima_conf_base)
					end
					aggiungi_stati_attivi(prossima_conf_base)
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

	salva_storie(stato_uscente: STATO)
	-- Arianna & Riccardo 05/07/2020
	-- aggiorna le storie nei discendenti dello 'stato_uscente'
		do
			pulisci_storie(stato_uscente)
			across
				conf_base_corrente as cbc
			loop
				if stato_uscente.antenato_di (cbc.item)	then
					salva_percorso(cbc.item, stato_uscente)
				end
			end
		end

	pulisci_storie(stato_uscita: STATO)
	-- Arianna & Riccardo 26/07/2020
	-- elimina gli stati salvati in tutte le storie che si incontrano nel percorso dai stati della conf_base_corrente allo 'stato_uscita'
		local
			stato_temp: STATO
		do
			across
				conf_base_corrente as cbc
			loop
				if stato_uscita.antenato_di (cbc.item)	then
					from
						stato_temp := cbc.item
					until
						stato_temp = stato_uscita
					loop
						if attached stato_temp.storia as storia then
							storia.svuota_memoria
						end
						if attached stato_temp.genitore as gen then
							stato_temp := gen
						end
					end
				end
			end
		end

	salva_percorso(stato_conf_base, stato_uscente: STATO)
	-- Arianna & Riccardo 05/07/2020
	-- memorizza i percorsi di uscita partendo da 'stato_conf_base' e arrivando fino a 'stato_uscente'
		local
			stato_temp: STATO
			percorso_uscita: LINKED_LIST[STATO]
		do
			if stato_uscente /= stato_conf_base then
				-- se esco da uno stato atomico non ho storia
				create percorso_uscita.make
				from
					stato_temp := stato_conf_base
				until
					stato_temp = stato_uscente
				loop
					percorso_uscita.put_front (stato_temp)
					if attached stato_temp.genitore as gen then
						stato_temp := gen
					end

					if attached{STORIA_DEEP} stato_temp.storia as storia then
						-- se la storia è "deep" salvo tutto l'array del percorso
						storia.aggiungi_stati (percorso_uscita)
					elseif attached{STORIA_SHALLOW} stato_temp.storia as storia then
						-- se la storia è "shallow" salvo solo lo stato uscente allo stesso livello della storia
						storia.memorizza_stato (percorso_uscita.first)
					end
				end
			end
		end

	trova_transizioni_eseguibili(evento: LINKED_SET[STRING]; condizioni: HASH_TABLE [BOOLEAN, STRING]; data: HASH_TABLE [INTEGER, STRING]): ARRAY[TRANSIZIONE]
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
			sorgenti := sorgenti_ordinate(evento, condizioni, data)
			from
				i:=sorgenti.lower
			until
				i=sorgenti.upper+1
			loop
				if i = sorgenti.upper or else not sorgenti[i].antenato_di(sorgenti[i+1]) then
					-- una sorgente che contiene la successiva non deve essere eseguita
					if attached sorgenti[i].transizione_abilitata (evento, condizioni, data) as ta then
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

	aggiungi_stati_attivi(conf_da_modificare: ARRAY[STATO])
	-- Arianna & Riccardo 05/07/2020
	-- aggiunge stati attivi alla configurazione
		do
			across
				conf_base_corrente as cbc
			loop
				if cbc.item.attivo then
					conf_da_modificare.force(cbc.item,conf_da_modificare.count + 1)
				end
			end
		end

	genitore_piu_grande(transizione: TRANSIZIONE): STATO
	-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
	-- restituisce l'antenato più grande dal quale si esce con 'transizione'
		local
			contesto, stato_temp: detachable STATO
		do
			Result := transizione.sorgente
			if transizione.internal then
				if transizione.sorgente.antenato_di (transizione.target) then
					across
						transizione.sorgente.figli as figli
					loop
						if figli.item.attivo then
							Result:=figli.item
						end
					end
				else
					across
						transizione.target.figli as figli
					loop
						if figli.item.attivo then
							Result:=figli.item
						end
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
	-- segue le transizioni di default e aggiunge lo stato atomico alla 'prossima_conf_base'
	-- se è presente una storia (non vuota) allora viene seguita al posto delle transizioni di default
		local
			i: INTEGER
		do
			if attached stato.storia as storia and then not storia.storia_vuota then
				segui_storia(stato, prossima_conf_base)
			else
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
		end

	segui_storia (stato: STATO; prossima_conf_base: ARRAY [STATO])
	-- Arianna & Riccardo 05/07/2020
	-- segue il percorso indicato dalla storia
		do
			stato.set_attivo
			esegui_onentry(stato)
			if attached{STORIA_DEEP} stato.storia as st then
				across
					st.stati_memorizzati as sm
				loop
					sm.item.set_attivo
					esegui_onentry(sm.item)
					if sm.item.stato_atomico then
						prossima_conf_base.force (sm.item, prossima_conf_base.count + 1)
					end
				end
			elseif attached{STORIA_SHALLOW} stato.storia as st and then attached st.stato_memorizzato as sm then
				trova_default (sm, prossima_conf_base)
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

	esegui_azioni (transizione: TRANSIZIONE)
		local
			contesto: detachable STATO
		do
			if transizione.internal then
				if transizione.sorgente.antenato_di (transizione.target) then
					contesto := transizione.sorgente
				else
					contesto := transizione.target
				end
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
					ox.item.esegui (state_chart.condizioni, state_chart.data_interi)
				end
			end
		end

	esegui_onentry (p_stato_corrente: STATO)
		do
			if p_stato_corrente.onentry .count>0 then
				across
					p_stato_corrente.onentry as oe
				loop
					oe.item.esegui (state_chart.condizioni, state_chart.data_interi)
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
				p_azioni [i].esegui (state_chart.condizioni, state_chart.data_interi)
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

	sorgenti_ordinate (evento: LINKED_SET[STRING]; condizioni: HASH_TABLE [BOOLEAN, STRING]; data: HASH_TABLE [INTEGER, STRING] ): ARRAY[STATO]
	-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
	-- Dati eventi e condizioni, restituisce l'array di sorgenti delle transizioni abilitate nella `conf_base_corrente'
	-- ordinate secondo l'ordine del file .xml
		do
			create Result.make_empty
			across
				conf_base_corrente as cbc
			loop
				if attached cbc.item.transizione_abilitata (evento, condizioni, data) as ta then
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
