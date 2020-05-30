note
	description: "Classe radice del progetto"
	author: "EN + studenti corsi PSI"
	date: "$Date$"
	revision: "  "

class
	ESECUTORE

create
	make, start

feature -- Attributi

	state_chart: CONFIGURAZIONE
			-- rappresenta la SC durante la sua esecuzione

	ambiente_corrente: AMBIENTE
			-- rappresenta l'ambiente in cui la SC si evolve

	conf_base_corrente: ARRAY [STATO]
			-- insieme degli stati base nella configurazione corrente della SC e non di tutti gli stati attivi

feature {NONE} -- Creazione e avvio interattivo

	start (nomi_files: ARRAY [STRING])
			-- prepara la SC e avvia la sua esecuzione
		do
			make (nomi_files)
			print ("%N=========%N EVOLUZIONE INIZIO%N")
			evolvi_SC (ambiente_corrente.eventi_esterni)
			print ("%N EVOLUZIONE FINE!%N=========%N")
		end

feature -- Creazione per i test

	make (nomi_files: ARRAY [STRING])
			-- prepara ed esegue la SC con i parametri passati come argomento
			-- per esecuzione interattiva gli argomenti vanno scritti in Eiffel Studio
			-- nel menu "Execution" -> "Execution Parameters" -> "Add"
			-- doppio click su spazio bianco accanto a "Arguments"
			-- scrivere i parametri ognuno tra doppi apici
		do
			print ("%N=========%N CREAZIONE INIZIO%N")
			print ("crea la SC in " + nomi_files [1] + "%N")
			create state_chart.make (nomi_files [1])
			create ambiente_corrente.make_empty
			create conf_base_corrente.make_empty
			conf_base_corrente.copy (state_chart.stato_iniziale)
			if not state_chart.ha_problemi_con_il_file_della_sc then
				print ("e la esegue con gli eventi in " + nomi_files [2] + "%N")
				ambiente_corrente.acquisisci_eventi (nomi_files [2])
				print ("acquisiti eventi %N")
				if not ambiente_corrente.verifica_eventi_esterni (state_chart) then
					print ("WARNING nel file ci sono eventi che la SC non conosce %N")
				end
				print ("eventi verificati, si esegue la SC %N")
				evolvi_SC (ambiente_corrente.eventi_esterni)
			else
				print ("Ci sono problemi con il file xml.%N")
				print ("Programma terminato.%N")
			end
			print ("%N CREAZIONE FINE%N=========%N")
		end

feature -- evoluzione della statechart

	evolvi_SC (istanti: ARRAY [LINKED_SET [STRING]])
		local
			count_istante_corrente: INTEGER
			i: INTEGER
			prossima_conf_base: ARRAY [STATO]
			condizioni_correnti: HASH_TABLE [BOOLEAN, STRING]
			transizioni_eseguibili: ARRAY[TRANSIZIONE]
			transizione_corrente: TRANSIZIONE
		do
			print ("%Nentrato in evolvi_SC:  %N %N")
			print ("stato iniziale:  ")
			stampa_conf_corrente
			create condizioni_correnti.make (1)
			from
				count_istante_corrente := 1
			until
				stato_final (conf_base_corrente) or count_istante_corrente > istanti.count
			loop
				if attached istanti [count_istante_corrente] as istante_corrente then
					print ("Indice istante corrente = ")
					print (count_istante_corrente)
					print ("%N")
					condizioni_correnti.copy (state_chart.condizioni)
					create prossima_conf_base.make_empty
					transizioni_eseguibili:=trova_transizioni_eseguibili(istante_corrente, condizioni_correnti)
					from
						i := conf_base_corrente.lower
					until
						i = conf_base_corrente.upper + 1
					loop
						transizione_corrente := conf_base_corrente [i].transizione_abilitata (istante_corrente, condizioni_correnti)
						if attached transizione_corrente as tc and then transizioni_eseguibili.has(tc) then
							esegui_azioni (tc, conf_base_corrente [i])
							trova_default (tc.target, prossima_conf_base)
							aggiungi_paralleli (tc.target, prossima_conf_base)
						else
							prossima_conf_base.force (conf_base_corrente [i], prossima_conf_base.count + 1)
						end
						i := i + 1
					end
					prossima_conf_base := stati_attivi_conf(prossima_conf_base)
					prossima_conf_base := riordina_conf_base(prossima_conf_base)
					if not prossima_conf_base.is_empty then
						conf_base_corrente.copy (prossima_conf_base)
					end
				end
				count_istante_corrente := count_istante_corrente + 1
				stampa_conf_corrente
			end
			print ("%NHo terminato l'elaborazione degli eventi nella seguente configurazione base%N")
			stampa_conf_corrente
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
				if i = sorgenti.upper or else not sorgenti[i].contiene_stato(sorgenti[i+1]) then
					-- una sorgente che contiene la successiva non deve essere eseguita
					if attached sorgenti[i].transizione_abilitata (evento, condizioni) as ta then
						if attached uscita_precedente implies genitore_piu_grande(ta).intersezione_vuota(uscita_precedente) then
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

	stati_attivi_conf(conf_da_modificare: ARRAY[STATO]): ARRAY[STATO]
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
					transizione.sorgente.stati_figli as figli
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
						stato_temp := stato_temp.stato_genitore
					end
				end
			end

		end

	aggiungi_paralleli (target: STATO; prossima_conf_base: ARRAY [STATO])
		local
			i: INTEGER
		do
			target.set_attivo
			if attached {STATO_AND} target.stato_genitore  as sgt and then not sgt.attivo then
				from
					i := sgt.stato_default.lower
				until
					i = sgt.stato_default.upper + 1
				loop
					if not sgt.stato_default [i].is_equal(target) then
						trova_default (sgt.stato_default [i], prossima_conf_base)
					end
					i := i + 1
				end
			end
			if attached target.stato_genitore as sgt then
				aggiungi_paralleli (sgt, prossima_conf_base)
			end
		end

	trova_default (stato: STATO; prossima_conf_base: ARRAY [STATO])
		local
			i: INTEGER
		do
			stato.set_attivo
			esegui_onentry(stato)
			if not stato.stato_default.is_empty then
				from
					i := stato.stato_default.lower
				until
					i = stato.stato_default.upper + 1
				loop
					trova_default (stato.stato_default [i], prossima_conf_base)
					i := i + 1
				end
			else
				-- `stato' è uno stato atomico
				prossima_conf_base.force (stato, prossima_conf_base.count + 1)
			end
		end

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
				corrente := p_sorgente.stato_genitore
			until
				corrente = Void
			loop
				antenati.put (corrente.id, corrente.id)
				corrente := corrente.stato_genitore
			end
				-- trova il piï¿½ basso antenato di p_destinazione in "antenati"
			from
				corrente := p_destinazione.stato_genitore
			until
				corrente = Void or else antenati.has (corrente.id)
			loop
				corrente := corrente.stato_genitore
			end
			Result := corrente
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
					stato_uscita.stati_figli as sf
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
			if attached p_target.stato_genitore as sg and then sg /= p_contesto then
				esegui_azioni_onentry (p_contesto, sg)
				esegui_onentry(sg)
			end
		end

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

	riordina_conf_base(conf_base:ARRAY[STATO]): ARRAY[STATO]
	--Agulini Claudia & Fiorini Federico 11/05/2020
	--Viene usata per riordinare la configurazione rispettando l' ordine del file xml
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
		result := conf_ordinata
	end

	sorgenti_ordinate(evento: LINKED_SET[STRING]; condizioni: HASH_TABLE [BOOLEAN, STRING]): ARRAY[STATO]
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

	stampa_conf_corrente
		do
			print ("configurazione corrente: ")
			across conf_base_corrente as cc
			loop
				print (cc.item.id + " ")
			end
			print (" %N")
		end
end
