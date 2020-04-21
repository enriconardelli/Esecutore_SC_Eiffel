note
	description: "Classe radice del progetto"
	author: " Daniele Fakhoury & Eloisa Scarsella "
	date: "$Date$"
	revision: "  "

class
	ESECUTORE

create
	make, start

feature -- Attributi

	state_chart: CONFIGURAZIONE
			-- rappresenta la SC durante la sua esecuzione

	eventi: AMBIENTE

	conf_corrente: ARRAY [STATO]
			-- insieme degli stati nella configurazione corrente della SC

	eventi_esterni: ARRAY [STRING]
			-- memorizza gli eventi letti dal file

feature {NONE} -- Creazione e avvio interattivo

	start (nomi_files: ARRAY [STRING])
			-- prepara la SC e avvia la sua esecuzione
		do
			make (nomi_files)
			print ("%N=========%N EVOLUZIONE INIZIO%N")
			evolvi_SC (eventi.eventi_esterni)
			print ("%N EVOLUZIONE FINE!%N=========%N")
		end

feature -- Creazione per i test

	make (nomi_files: ARRAY [STRING])
			-- prepara la SC con i parametri passati come argomento
			-- in Eiffel Studio vanno invece scritti mediante il
			-- menu "Execution" -> "Execution Parameters" -> "Add"
			-- doppio click su spazio bianco accanto a "Arguments"
			-- scrivere i parametri ognuno tra doppi apici
		do
			print ("%N=========%N CREAZIONE INIZIO%N")
			create eventi_esterni.make_empty
			print ("crea la SC in " + nomi_files [1] + "%N")
			create state_chart.make (nomi_files [1])
			create conf_corrente.make_empty
			conf_corrente.copy (state_chart.stato_iniziale)
			create eventi.make_empty
			if not state_chart.ha_problemi_con_il_file_della_sc then
				print ("e la esegue con gli eventi in " + nomi_files [2] + "%N")
				eventi.acquisisci_eventi (nomi_files [2])
				print ("acquisiti eventi %N")
				if not eventi.verifica_eventi_esterni (state_chart) then
					print ("WARNING nel file ci sono eventi che la SC non conosce %N")
				end
				print ("eventi verificati, si esegue la SC %N")
				evolvi_SC (eventi.eventi_esterni)
			else
				print ("Ci sono problemi con il file xml.%N")
				print ("Programma terminato.%N")
			end
			print ("%N CREAZIONE FINE%N=========%N")
		end


--feature -- file eventi

--	acquisisci_eventi (nome_file_eventi: STRING)
--			-- Legge gli eventi dal file passato come secondo argomento e li inserisce in `eventi_esterni'
--			-- TODO non gestisce il caso in cui su una riga del file degli eventi ci sia più di un evento
--		local
--			file: PLAIN_TEXT_FILE
--			i: INTEGER
--		do
--			create file.make_open_read (nome_file_eventi)
--			from
--				i := 1
--			until
--				file.off
--			loop
--				file.read_line
--				eventi_esterni.force (file.last_string.twin, i)
--				i := i + 1
--			end
--			file.close
--		end

feature --evoluzione SC

	evolvi_SC (istanti: ARRAY [LINKED_SET [STRING]])
		local
			count_istante_corrente: INTEGER
			i: INTEGER
			prossima_conf_corrente: ARRAY [STATO]
			condizioni_correnti: HASH_TABLE [BOOLEAN, STRING]
			transizione_corrente: TRANSIZIONE
		do
			print ("%Nentrato in evolvi_SC:  %N %N")
			print ("stato iniziale:  ")
			stampa_stati (conf_corrente)
			create condizioni_correnti.make (1)
			from
				count_istante_corrente := 1
			until
				stato_final (conf_corrente) or count_istante_corrente > istanti.count
			loop
				if attached istanti [count_istante_corrente] as istante_corrente then
					print ("Stampa indice istante corrente = ")
					print (count_istante_corrente)
					print ("   %N")
					condizioni_correnti.copy (state_chart.condizioni)
					create prossima_conf_corrente.make_empty
					from
						i := conf_corrente.lower
					until
						i = conf_corrente.upper + 1
					loop
						transizione_corrente := conf_corrente [i].transizione_abilitata (istante_corrente, condizioni_correnti)
						if attached transizione_corrente as tc then
							esegui_azioni (tc, conf_corrente [i])
							aggiungi_paralleli (tc.target, prossima_conf_corrente)
							trova_default (tc.target, prossima_conf_corrente)
						else
							prossima_conf_corrente.force (conf_corrente [i], prossima_conf_corrente.count + 1)
						end
						i := i + 1
					end
					if not prossima_conf_corrente.is_empty then
						conf_corrente.copy (prossima_conf_corrente)
					end
				end
				count_istante_corrente := count_istante_corrente + 1
				stampa_stati (conf_corrente)
			end
			print ("%N%NHo terminato l'elaborazione degli eventi nello stato = ")
			stampa_stati (conf_corrente)
		end

	aggiungi_paralleli (stato: STATO; prossima_conf_corrente: ARRAY [STATO])
		local
			i: INTEGER
		do
			if attached {STATO_AND} stato.stato_genitore as sg then
				from
					i := sg.stato_default.lower
				until
					i = sg.stato_default.upper + 1
				loop
					if not sg.stato_default [i].is_equal(stato) then
						trova_default (sg.stato_default [i], prossima_conf_corrente)
					end
					i := i + 1
				end
			end
			if attached stato.stato_genitore as sg then
				aggiungi_paralleli (sg, prossima_conf_corrente)
			end
		end

	trova_default (stato: STATO; prossima_conf_corrente: ARRAY [STATO])
		local
			i: INTEGER
		do
			if not stato.stato_default.is_empty then
				from
					i := stato.stato_default.lower
				until
					i = stato.stato_default.upper + 1
				loop
					if attached stato.stato_default [i].onentry as oe then
						oe.action (state_chart.condizioni)
					end
					trova_default (stato.stato_default [i], prossima_conf_corrente)
					i := i + 1
				end
			elseif not prossima_conf_corrente.has (stato) then
				prossima_conf_corrente.force (stato, prossima_conf_corrente.count + 1)
			end
		end

--	trova_stato_corrente (target: STATO)
--	local
--		nuovo_stato: ARRAY[STATO]
--		stati_figli_temp: ARRAY[STATO]
--	do
--		create nuovo_stato.make_empty
--		create stati_figli_temp.make_empty
--		if attached target.stato_genitore as sg then
--			if attached {STATO_XOR} sg.stato_genitore as sgg then
--				nuovo_stato.force (target, nuovo_stato.count + 1)
--				stato_corrente.copy (nuovo_stato)
--			elseif attached {STATO_AND} sg.stato_genitore as sgg then
--				stati_figli_temp.copy (sgg.stati_figli)
--				nuovo_stato.force (stati_figli_temp.item (0).stato_default, nuovo_stato.count + 1)
--				nuovo_stato.force (stati_figli_temp.item (1).stato_default, nuovo_stato.count + 1)
--				stato_corrente.copy (nuovo_stato)
--			else
--				nuovo_stato.force (target, nuovo_stato.count + 1)
--				stato_corrente.copy (nuovo_stato)
--			end
--		else
--			nuovo_stato.force (target, nuovo_stato.count + 1)
--			stato_corrente.copy (nuovo_stato)
--		end
--	end

	esegui_azioni (transizione: TRANSIZIONE; stato: STATO)
		local
			contesto: detachable STATO
		do
			if transizione.internal then
				contesto := transizione.sorgente
			else
				contesto := trova_contesto (transizione.sorgente, transizione.target)
			end
			esegui_azioni_onexit (stato, contesto)
			esegui_azioni_transizione (transizione.azioni)
			esegui_azioni_onentry (contesto, transizione.target)
		end

	trova_contesto (p_sorgente, p_destinazione: STATO): detachable STATO
			-- trova il contesto in base alla specifica SCXML secondo cui il contesto
			-- ï¿½ il minimo antenato comune PROPRIO a p_sorgente e p_destinazione
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
				corrente := p_destinazione
			until
				corrente = Void or else antenati.has (corrente.id)
			loop
				corrente := corrente.stato_genitore
			end
			Result := corrente
		end

	esegui_azioni_onexit (p_stato_corrente: STATO; p_contesto: detachable STATO)
		do
			if p_stato_corrente /= p_contesto then
				if attached p_stato_corrente.onexit as ox then
					ox.action (state_chart.condizioni)
				end
				if attached p_stato_corrente.stato_genitore as sg then
					esegui_azioni_onexit (sg, p_contesto)
				end
			end
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

	verifica_eventi_esterni: BOOLEAN
			-- Verifica che tutti gli eventi nel file compaiano effettivamente tra gli eventi di qualche transizione
			-- Segnala l'eventuale presenza di eventi incompatibili
			-- Agulini Claudia, Fiorini Federico - 2020/04/11
		local
			eventi_nella_SC: HASH_TABLE [BOOLEAN, STRING]
			j: INTEGER
		do
			create eventi_nella_SC.make (0)
			-- inserisce tutti gli eventi definiti nella SC in eventi_nella_SC
			across
				state_chart.stati as st
			loop
				if attached st.item.transizioni as tr then
					from
						j := 1
					until
						j = tr.count + 1
					loop
						if attached tr [j].evento as e then
							eventi_nella_SC.put (True, e)
						end
						j := j + 1
					end
				end
			end
			-- verifica che ogni evento esterno sia presente nella SC
			Result := True
			across
				eventi_esterni as ee
			loop
				if not eventi_nella_SC.has (ee.item) then
					print ("%N ATTENZIONE!! L'evento " + ee.item + " non viene utilizzato!")
					Result := False
				end
			end
		end

	esegui_azioni_onentry (p_contesto: detachable STATO; p_target: STATO)
		do
			if p_target /= p_contesto and then attached p_target.stato_genitore as sg then
				esegui_azioni_onentry (p_contesto, sg)
			end
			if p_target /= p_contesto and then attached p_target.onentry as oe then
				oe.action (state_chart.condizioni)
			end
		end

	stato_final (stato: ARRAY [STATO]): BOOLEAN
		require
			contesto: conf_corrente /= VOID
		local
			i: INTEGER
		do
			from
				i := conf_corrente.lower
			until
				i = conf_corrente.upper + 1
			loop
				if conf_corrente [i].finale then
					result := TRUE
				end
				i := i + 1
			end
		end

	stampa_stati (stati: ARRAY [STATO])
		local
			i: INTEGER
		do
			from
				i := stati.lower
			until
				i = stati.upper + 1
			loop
				print (stati [i].id + " ")
				i := i + 1
			end
			print (" %N")
		end

end
