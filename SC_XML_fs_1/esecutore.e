note
	description: "Classe radice del progetto"
	author: "EN + studenti corsi PSI"
	date: "Agosto 2020"
	revision: "$Revision$"

class
	ESECUTORE

create
	make

feature -- Attributi

	state_chart: CONFIGURAZIONE
			-- rappresenta la SC durante la sua esecuzione

	ambiente_corrente: AMBIENTE
			-- rappresenta l'ambiente in cui la SC si evolve

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
			if not state_chart.ha_problemi_con_il_file_della_sc then
				print ("e la esegue con gli eventi in " + nomi_files [2] + "%N")
				ambiente_corrente.acquisisci_eventi (nomi_files [2])
				print ("acquisiti eventi %N")
				if not ambiente_corrente.verifica_eventi_esterni (state_chart) then
					print ("AVVISO: nel file ci sono eventi che la SC non conosce. Verranno ignorati.%N")
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
			transizioni_eseguibili: ARRAY [TRANSIZIONE]
			transizione_corrente: TRANSIZIONE
		do
			print ("%Nentrato in evolvi_SC:  %N %N")
			from
				istante := 1
			until
				stato_final (state_chart.conf_base) or istante > eventi.count
			loop
				if attached eventi [istante] as eventi_correnti then
					stampa_conf_corrente (istante)
					create prossima_conf_base.make_empty
					transizioni_eseguibili := trova_transizioni_eseguibili (eventi_correnti, state_chart.variabili)

-- PROVA CON iterazione sulle transizioni eseguibili
 					across transizioni_eseguibili as sc_cb
--					across state_chart.conf_base as sc_cb

--						conf_base_corrente as cbc -- l'attributo conf_base_corrente è stato rimpiazzato state_chart.conf_base
					loop

-- PROVA CON iterazione sulle transizioni eseguibili
						transizione_corrente := sc_cb.item
--						transizione_corrente := sc_cb.item.transizione_abilitata (eventi_correnti, state_chart.variabili)

						if attached transizione_corrente as tc and then transizioni_eseguibili.has (tc) then
							salva_storie (antenato_massimo_uscita (tc)) -- dal MASTER
							stampa_storia (antenato_massimo_uscita (tc))
							esegui_azioni (tc) -- , cbc.item)
							trova_default (tc.destinazione.first, prossima_conf_base)
							if tc.fork then
								across tc.destinazione as mt_corrente
								loop
									trova_default (mt_corrente.item, prossima_conf_base)
								end
							end
							aggiungi_paralleli (tc.destinazione.first, prossima_conf_base)
						else

-- PROVA CON iterazione sulle transizioni eseguibili
							prossima_conf_base.force (sc_cb.item.sorgente.first, prossima_conf_base.count + 1)
-- PRIMA DI MERGE			prossima_conf_base.force (sc_cb.item.sorgente, prossima_conf_base.count + 1)

						end
					end
					aggiungi_stati_attivi(prossima_conf_base) -- si mantiene versione MASTER
--					prossima_conf_base := elimina_stati_inattivi (prossima_conf_base)  -- questa era quella di costrutto FORK
					prossima_conf_base := riordina_stati (prossima_conf_base) -- si mantiene versione MASTER
--					prossima_conf_base := riordina_conf_base (prossima_conf_base) -- questa era quella di costrutto FORK
					if not prossima_conf_base.is_empty then
						state_chart.conf_base.copy (prossima_conf_base)
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
				state_chart.conf_base as cbc
			loop
				if stato_uscente.antenato_di (cbc.item)	then
					salva_percorso(cbc.item, stato_uscente)
				end
			end

		end

--	pulisci_storie(stato_uscita: STATO)
--	-- Arianna & Riccardo 26/07/2020
--	-- elimina gli stati salvati in tutte le storie che si incontrano nel percorso dagli stati di state_chart.conf_base allo 'stato_uscita'
--		local
--			stato_temp: STATO
--		do
--			across
--				state_chart.conf_base as cbc
--			loop
--				if stato_uscita.antenato_di (cbc.item)	then
--					from
--						stato_temp := cbc.item
--					until
--						stato_temp = stato_uscita
--					loop
--						if attached stato_temp.storia as storia then
--							storia.svuota_memoria
--						end
--						if attached stato_temp.genitore as gen then
--							stato_temp := gen
--						end
--					end
--				end
--			end
--		end

	pulisci_storie(stato_uscita: STATO)
	-- Copia per trovare errore
	--
	-- elimina gli stati salvati in tutte le storie che si incontrano nel percorso dagli stati di state_chart.conf_base allo 'stato_uscita'
		local
			stato_temp: STATO
		do
			print(" Sono in piulisci_storia %N")
			across
				state_chart.conf_base as cbc
			loop
				print(" Sono nel primo loop %N ")
				if stato_uscita.antenato_di (cbc.item)	then
					from
						stato_temp := cbc.item
					until
						stato_temp = stato_uscita
					loop
						print(" Sono nel secondo loop %N ")
						print(stato_temp.id)
						if attached stato_temp.storia as storia then
							print(" Sto svuotando la storia di: ")
							print(stato_temp.id)
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
				end

					if attached{STORIA_DEEP} stato_temp.storia as storia then
					-- se la storia è "deep" salvo tutto l'array del percorso
						storia.aggiungi_stati (percorso_uscita)
					elseif attached{STORIA_SHALLOW} stato_temp.storia as storia then
						-- se la storia è "shallow" salvo solo lo stato uscente allo stesso livello della storia
						storia.memorizza_stato (percorso_uscita.first)
					end
			end
--			if attached percorso_uscita as pu then
--				across
--					pu as pu1
--				loop
--					print(" Storia: ")
--					print(pu1.item.id)
--				end
--			end

		end
--	salva_percorso(stato_conf_base, stato_uscente: STATO)
--	-- Arianna & Riccardo 05/07/2020
--	-- memorizza i percorsi di uscita partendo da 'stato_conf_base' e arrivando fino a 'stato_uscente'
--		local
--			stato_temp: STATO
--			percorso_uscita: LINKED_LIST[STATO]
--		do
--			if stato_uscente /= stato_conf_base then
--				-- se esco da uno stato atomico non ho storia
--				create percorso_uscita.make
--				from
--					stato_temp := stato_conf_base
--				until
--					stato_temp = stato_uscente
--				loop
--					percorso_uscita.put_front (stato_temp)
--					if attached stato_temp.genitore as gen then
--						stato_temp := gen
--					end

--					if attached{STORIA_DEEP} stato_temp.storia as storia then
--						-- se la storia è "deep" salvo tutto l'array del percorso
--						storia.aggiungi_stati (percorso_uscita)
--					elseif attached{STORIA_SHALLOW} stato_temp.storia as storia then
--						-- se la storia è "shallow" salvo solo lo stato uscente allo stesso livello della storia
--						storia.memorizza_stato (percorso_uscita.first)
--					end
--				end
--			end
--			if attached percorso_uscita as pu then
--				across
--					pu as pu1
--				loop
--					print(" Storia: ")
--					print(pu1.item.id)
--				end
--			end

--		end

	trova_transizioni_eseguibili(eventi: LINKED_SET[STRING]; variabili: DATAMODEL): ARRAY[TRANSIZIONE]
		-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
		-- restituisce l'array di transizioni che possono essere eseguite nello stato attuale del sistema
		-- rispettando le specifiche SCXML dell'ordine degli stati nel file .xml e della gerarchia (priorità strutturale object-oriented)
		local
			transizioni: ARRAY [TRANSIZIONE]
			i: INTEGER
			uscita_precedente: detachable STATO
			sorgenti: ARRAY [STATO]
		do
			create transizioni.make_empty
			sorgenti := stati_eseguibili (eventi, variabili)
			debug ("SC_transizioni_eseguibili")
				print("=============================%N")
				print (" stati sorgenti delle transizioni eseguibili in questo istante%N");
				stampa_stati(sorgenti)
				print("=============================%N")
			end
			from
				i := sorgenti.lower
			until
				i = sorgenti.upper + 1
			loop
				if i = sorgenti.upper or else not sorgenti[i].antenato_di(sorgenti[i+1]) then
					-- gli stati in sorgenti non sono tutti stati atomici, perché sono gli stati da cui fisicamente partono le transizioni eseguibili,
					--		e quindi uno stato in sorgenti che è antenato dello stato immediatamente successivo non deve essere considerato, perché
					--		la priorità strutturale object-oriented dà la priorità al secondo. (vedi t_non_determinismo_1_7_3 e 1_7_4)
					-- se non è antenato di questo secondo non è antenato di alcun altro dopo di esso, dal momento che il non essere
					--		antenato di quello immediatamente successivo implica - a causa del riordinamento degli stati in sorgenti in base
					--		all'ordine di specifica nel file .xml - che nessuno dei suoi discendenti possiede transizioni eseguibili

					if attached sorgenti[i].transizione_abilitata (eventi, variabili) as ta then
						debug ("SC_transizioni_eseguibili") print(" sorgente " + i.out + ": lo stato " + sorgenti[i].id + " con transizione a destinazione stato " + ta.destinazione.first.id + ". antenato_massimo_uscita = " + antenato_massimo_uscita(ta).id) end
						if attached uscita_precedente implies antenato_massimo_uscita(ta).incomparabile_con(uscita_precedente) then
							-- questa transizione mi fa uscire da uno stato incomparabile con quello della precedente transizione
							debug ("SC_transizioni_eseguibili") print(" viene mantenuto per la transizione.%N") end
							transizioni.force (ta, transizioni.count + 1)
							uscita_precedente := antenato_massimo_uscita (ta)
						else
							-- questa transizione esce da uno stato atomico parallelo di quello della precedente transizione scelta e
							-- gli AMU (antenato_massimo_uscita) di questi due stati atomici in parallelo tra loro sono uno antenato dell'altro.
							-- poiché le transizioni sono sempre associate agli stati atomici questa transizione mi farebbe uscire da
							-- da un antenato parallelo comune a entrambi gli stati atomici.
							-- la precedente transizione mi può aver già fatto uscire da tale comune antenato (vedi test t_non_determinismo_2_8_1)
							-- e quindi questa transizione o è superflua o incompatibile (e la precedente ha la priorità)
							-- oppure no (t_non_determinismo_2_8_2) e allora questa transizione è incompatibile (e la precedente ha la priorità)
							debug ("SC_transizioni_eseguibili") print(" viene scartato perche' AMU e' antenato o discendente di precedente AMU o coincide.'.%N") end
						end
					end
				else
					debug ("SC_transizioni_eseguibili")
						if attached sorgenti[i].transizione_abilitata (eventi, variabili) as ta then
							print(" sorgente " + i.out + ": lo stato " + sorgenti[i].id + " con transizione a destinazione stato " + ta.destinazione.first.id + ". antenato_massimo_uscita = " + antenato_massimo_uscita(ta).id)
							print(" e' antenato di sorgente successiva " + (i+1).out + ": " + sorgenti[i+1].id + " e viene scartato.%N")
						end
					end
				end
				i:=i+1
			end
			Result:=transizioni
		end

	aggiungi_stati_attivi (conf_da_modificare: ARRAY[STATO])
	-- Arianna & Riccardo 05/07/2020
	-- aggiunge stati attivi alla configurazione
		do
			across
				state_chart.conf_base as sc_cb
			loop
				if sc_cb.item.attivo then
					conf_da_modificare.force (sc_cb.item, conf_da_modificare.count + 1)
				end
			end
		end

	antenato_massimo_uscita (transizione: TRANSIZIONE): STATO
	-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
	-- restituisce l'antenato più grande dal quale si esce con 'transizione'
	-- TODO: controllare perché qui e in `esegui_azioni' si chiede di fare gli stessi controlli
	-- TODO: su transizioni internal che non siano multisorgente e che le sorgenti multiple siano compatibili
		local
			contesto, stato_temp: detachable STATO
		do
			Result := transizione.sorgente.first
-- PRIMA DI MERGE Result := transizione.sorgente
			if transizione.internal then
-- TODO: controllare quando si leggono le transizioni marcate "internal" che non siano multisorgente
				if transizione.sorgente.first.antenato_di (transizione.destinazione.first) then
-- PRIMA DI MERGE if transizione.sorgente.antenato_di (transizione.destinazione.first) then
					across
						transizione.sorgente.first.figli as figli
-- PRIMA DI MERGE 		transizione.sorgente.figli as figli
					loop
						if figli.item.attivo then
							Result := figli.item
						end
					end
				else
					across
						transizione.destinazione.first.figli as figli
					loop
						if figli.item.attivo then
							Result := figli.item
						end
					end
				end
			else
-- TODO: controllare quando si leggono le transizioni multi-sorgente che tutte le sorgenti siano tra loro compatibili
-- TODO: come accade per le transizioni multi-destinazione in cui si controlla che tutte le destinazioni siano tra loro compatibili
				contesto := trova_contesto (transizione.sorgente.first, transizione.destinazione.first)
-- PRIMA DI MERGE contesto := trova_contesto (transizione.sorgente, transizione.destinazione.first)
				from
					stato_temp := transizione.sorgente.first
-- PRIMA DI MERGE	stato_temp := transizione.sorgente
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

	aggiungi_paralleli (p_destinazione: STATO; prossima_conf_base: ARRAY [STATO])
	-- inserisce in `prossima_conf_base' i default degli stati in parallelo rispetto al target
	-- qualora vi siano stati già attivi non dà luogo a configurazioni non corrette
	-- TODO: la riga precedente non capisco bene che vuol dire, esprimere meglio
		do
			p_destinazione.set_attivo
			if attached {STATO_AND} p_destinazione.genitore as dg and then not dg.attivo then
				-- se lo stato genitore è un AND scorro i suoi figli
				across dg.initial as dgi
				loop
					if not dgi.item.is_equal(p_destinazione) then
						-- se dgi.item è la destinazione non devo aggiungerla perché l'ho già fatto
-- VERSIONE DEL MASTER
--						trova_default (dgi.item, prossima_conf_base)
							--AGGIUNTE FORK
						aggiungi_sottostati (dgi.item, prossima_conf_base)
							--FINE AGGIUNTE
					end
				end
			end
			if attached p_destinazione.genitore as dg then
				--se ha un genitore ripeto aggiungi paralleli su di lui
				aggiungi_paralleli (dg, prossima_conf_base)
			end
		end

	--AGGIUNTE FORK

	aggiungi_sottostati (stato: STATO; prossima_conf_base: ARRAY [STATO])
			-- se il target NON contiene un sottostato attivo si comporta come trova_default
			-- altrimenti entra nello stato target e entra ricorsivamente nei suoi sottostati
			-- che contengono un sottostato attivo
			-- se incontra uno stato AND con un figlio attivo allora mette attivi tutti i suoi figli
		do
			if stato.ha_sottostati_attivi then
				stato.set_attivo
				esegui_onentry (stato)
				if attached {STATO_AND} stato as s_and then
					-- ripeto su tutti i figli dello stato AND
					across
						s_and.figli as fsa
					loop
						aggiungi_sottostati (fsa.item,prossima_conf_base)
					end
				else -- ripeto solo sui figli dello stato XOR che hanno un sottostato attivo
					across
						stato.figli as fs
					loop
						if fs.item.ha_sottostati_attivi then
							aggiungi_sottostati (fs.item,prossima_conf_base)
						end
					end
				end
			else
				trova_default(stato,prossima_conf_base)
			end
		end

	--FINE AGGIUNTE

	trova_default (stato: STATO; prossima_conf_base: ARRAY [STATO])
	-- segue le transizioni di default e aggiunge lo stato atomico a `prossima_conf_base'
	-- se è presente una storia (non vuota) allora viene seguita al posto delle transizioni di default
		do
			if attached stato.storia as storia and then not storia.storia_vuota then
				segui_storia(stato, prossima_conf_base)
			else
				stato.set_attivo
				esegui_onentry(stato)
				if not stato.initial.is_empty then
					across stato.initial as  si
					loop
						trova_default (si.item, prossima_conf_base)
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
				-- trova il piu' basso antenato di p_destinazione in "antenati"
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
	-- TODO: controllare perché qui e in `antenato_massimo_uscita' si chiede di fare gli stessi controlli
	-- TODO: su transizioni internal che non siano multisorgente e che le sorgenti multiple siano compatibili
		local
			contesto: detachable STATO
		do
			if transizione.internal then
-- TODO: controllare quando si leggono le transizioni marcate "internal" che non siano multisorgente
				if transizione.sorgente.first.antenato_di (transizione.destinazione.first) then
-- PRIMA DI MERGE if transizione.sorgente.antenato_di (transizione.destinazione.first) then
--OLD				if transizione.sorgente.antenato_di (transizione.destinazione) then
					contesto := transizione.sorgente.first
-- PRIMA DI MERGE	contesto := transizione.sorgente
				else
					contesto := transizione.destinazione.first
				end
			else
-- TODO: controllare quando si leggono le transizioni multi-sorgente che tutte le sorgenti siano tra loro compatibili
-- TODO: come accade per le transizioni multi-destinazione in cui si controlla che tutte le destinazioni siano tra loro compatibili
				contesto := trova_contesto (transizione.sorgente.first, transizione.destinazione.first)
-- PRIMA DI MERGE contesto := trova_contesto (transizione.sorgente, transizione.destinazione.first)
			end
			esegui_azioni_onexit (antenato_massimo_uscita (transizione))
			esegui_azioni_transizione (transizione.azioni)
			esegui_azioni_onentry (contesto, transizione.destinazione.first)
		end

	esegui_onexit (p_stato_corrente: STATO)
		do
			if p_stato_corrente.onexit.count>0 then
				across
					p_stato_corrente.onexit as ox
				loop
					ox.item.esegui (state_chart.variabili)
				end
			end
		end

	esegui_onentry (p_stato_corrente: STATO)
		do
			if p_stato_corrente.onentry .count>0 then
				across
					p_stato_corrente.onentry as oe
				loop
					oe.item.esegui (state_chart.variabili)
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
		do
			across p_azioni as  pa
			loop
				pa.item.esegui (state_chart.variabili)
			end
		end

	esegui_azioni_onentry (p_contesto: detachable STATO; p_destinazione: STATO)
		do
			if attached p_destinazione.genitore as dg and then dg /= p_contesto then
				esegui_azioni_onentry (p_contesto, dg)
				esegui_onentry (dg)
			end
		end

feature -- controllo

	stato_final (stato: ARRAY [STATO]): BOOLEAN
		require
			contesto: state_chart.conf_base /= Void
		do
			across state_chart.conf_base as cbc
			loop
				if cbc.item.finale then
					result := True
				end
			end
		end

feature -- utilita

	riordina_stati (p_stati: ARRAY[STATO]): ARRAY[STATO]
	-- Agulini Claudia & Fiorini Federico 11/05/2020
	-- Riordina `p_stati' in base all'ordine del file .xml, che è quello con cui sono stati creati gli stati
	local
		stati_ordinati: ARRAY[STATO]
	do
		create stati_ordinati.make_empty
		across
			state_chart.stati as stati
		loop
			if p_stati.has (stati.item) then
				stati_ordinati.force (stati.item, stati_ordinati.count + 1)
			end
		end
		Result := stati_ordinati
	end

	stati_eseguibili (eventi: LINKED_SET[STRING]; variabili: DATAMODEL): ARRAY[STATO]
--	Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
--  A partire dalla configurazione di base ritorna gli stati che hanno transizioni abilitate in base a `eventi' e `variabili'
--	N.B. gli stati tornati possono non essere stati atomici, ma stati gerarchici le cui transizioni sono eseguibili dagli stati atomici
--		loro discendenti, che sono rilevate da `transizione_abilitata' in assenza di transizioni direttamente abilitate nello stato atomico
		do
			create Result.make_empty
			across
				state_chart.conf_base as sc_cb
			loop
				debug ("SC_transizioni_eseguibili") print ("  stato corrente di conf_base: " + sc_cb.item.id + "%N") end
				if attached sc_cb.item.transizione_abilitata (eventi, variabili) as ta then
-- PRIMA DI MERGE	debug ("SC_transizioni_eseguibili") print ("    con transizione abilitata da " + ta.sorgente.id + " a " + ta.destinazione.first.id + "%N") end
					debug ("SC_transizioni_eseguibili") print ("    con transizione abilitata da ") end
					across ta.sorgente as tas
--					from
-- 						i:=ta.sorgente.lower
--					until
--						i = ta.sorgente.count + 1
					loop
--						debug("SC_transizioni_eseguibili") print(ta.sorgente[i].id) end
						debug("SC_transizioni_eseguibili") print(tas.item.id) end
--						Result.force (ta.sorgente[i], Result.count + 1)
						Result.force (tas.item, Result.count + 1)
--						i := i+1
					end
					debug("SC_transizioni_eseguibili") print(" a " + ta.destinazione.first.id + "%N") end
-- PRIMA DI MERGE	Result.force (ta.sorgente, Result.count + 1)
				end
			end
			Result := riordina_stati (Result)
		end

	stampa_conf_corrente (indice: INTEGER)
		do
			print ("%NIstante corrente = ")
			print (indice)
			print ("%N")
			print ("  configurazione BASE corrente: ")
			across
				state_chart.conf_base as sc_cb
			loop
				print (sc_cb.item.id + " ")
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

	stampa_stati (stati: ARRAY[STATO])
		do
			across stati as s
			loop
				s.item.stampa
			end
		end

	stampa_storia (stato_storia: STATO)
		do
			if attached{STORIA_DEEP} stato_storia.storia as ss then
				across
					ss.stati_memorizzati as sm
				loop
					print(" Storia: ")
					print(sm.item.id)
				end
			elseif attached{STORIA_SHALLOW} stato_storia.storia as ss and then attached ss.stato_memorizzato as ssm then
				print(" Storia: ")
				print(ssm.id)
			end
		end
end
