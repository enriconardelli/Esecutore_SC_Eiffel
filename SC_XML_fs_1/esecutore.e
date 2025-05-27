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

	istante_massimo: INTEGER
			-- variabile che indica il numero massimo di istanti di evoluzione della SC

	istante_massimo_default: INTEGER = 100
			-- valore di default per il numero massimo di istanti di evoluzione della SC

feature -- Creazione sia per i test che per esecuzione interattiva

	make (argomenti: ARRAY [STRING])
			-- prepara ed esegue la SC con i parametri passati come argomento
			-- per esecuzione interattiva gli argomenti vanno scritti in Eiffel Studio
			-- nel menu "Execution" -> "Execution Parameters" -> "Add"
			-- doppio click su spazio bianco accanto a "Arguments"
			-- scrivere i parametri ognuno tra doppi apici separati da uno spazio includendo l'estensione
			-- .xml per il file della SC e .txt per il file degli eventi ed eventualmente un terzo parametro
			-- per scegliere il numero massimo di istanti di evoluzione della SC
		local
			eventi_acquisiti: BOOLEAN
		do
			if argomenti.valid_index (3) then
				if argomenti [3].is_integer then
					istante_massimo := argomenti [3].to_integer
				else
					istante_massimo := istante_massimo_default
				end
			else
				istante_massimo := istante_massimo_default
			end
			print ("%N=========%N CREAZIONE INIZIO%N")
			print ("crea la SC in " + argomenti [1] + "%N")
			create state_chart.make (argomenti [1])
			create ambiente_corrente.make_empty
			if not state_chart.errore_parsing_file_SC and state_chart.errore_costruzione_SC.is_empty then
				print ("e la esegue con gli eventi in " + argomenti [2] + "%N")
				eventi_acquisiti := ambiente_corrente.acquisisci_eventi (argomenti [2])
				if eventi_acquisiti then
					print ("acquisiti eventi %N")
					if not ambiente_corrente.verifica_eventi_esterni (state_chart) then
						print ("AVVISO: nel file ci sono eventi che la SC non conosce. Verranno ignorati.%N")
					end
					print ("eventi verificati, si esegue la SC %N")
					print ("%N CREAZIONE FINE%N=========%N")
					evolvi_SC (ambiente_corrente.eventi_esterni)
				else
					print ("%N ERRORE: il file " + argomenti [2] + " non esiste! %N")
					print ("%N CREAZIONE FINE%N=========%N")
				end
			else
				print ("Non si esegue la SC perche' ")
				if state_chart.errore_costruzione_SC.is_empty then
					print ("ci sono problemi nella costruzione della SC.%N")
				else
					print ("Ci sono problemi con il file xml.%N")
				end
				print ("%N CREAZIONE FINE%N=========%N")
			end
		end

feature -- evoluzione della statechart

	evolvi_SC (eventi: ARRAY [LINKED_SET [STRING]])
		local
			istante: INTEGER
			prossima_config_base: ARRAY [STATO]
			transizioni_eseguibili: ARRAY [TRANSIZIONE]
			transizioni_finite: BOOLEAN
		do
			print ("%Nentrato in evolvi_SC:  %N %N")
			from
				istante := 1
			until
				stato_final (state_chart.config_base) or istante > istante_massimo or transizioni_finite
			loop
				stampa_conf_corrente (istante)
				create prossima_config_base.make_empty
				if istante <= eventi.count then
					transizioni_eseguibili := trova_transizioni_eseguibili (eventi [istante], state_chart.variabili)
				else
					transizioni_eseguibili := trova_transizioni_eseguibili (create {LINKED_SET [STRING]}.make, state_chart.variabili)
					if transizioni_eseguibili.is_empty then
						transizioni_finite := True
					end
				end
				across
					transizioni_eseguibili as te
				loop
					salva_storie (antenato_massimo_uscita (te.item))
					debug ("SC_storia")
						stampa_storia (antenato_massimo_uscita (te.item))
					end
					esegui_azioni (te.item)
					if te.item.fork then
						across
							te.item.destinazione as destinazione_corrente
						loop
							trova_default (destinazione_corrente.item, prossima_config_base)
						end
					else
						trova_default (te.item.destinazione.first, prossima_config_base)
					end
					aggiungi_paralleli (te.item.destinazione.first, prossima_config_base)
				end
				aggiungi_stati_attivi (prossima_config_base)
				prossima_config_base := riordina_stati (prossima_config_base)
				if not prossima_config_base.is_empty then
					state_chart.config_base.copy (prossima_config_base)
				end
				istante := istante + 1
			end
			print ("%NHo terminato l'elaborazione degli eventi%N")
			stampa_conf_corrente (istante)
		end

	salva_storie (stato_uscente: STATO)
			-- Arianna & Riccardo 05/07/2020
			-- aggiorna le storie nei discendenti dello 'stato_uscente'
		do
			pulisci_storie (stato_uscente)
			across
				state_chart.config_base as cbc
			loop
				if stato_uscente.antenato_di (cbc.item) then
					salva_storia (cbc.item, stato_uscente)
				end
			end
		end

	pulisci_storie (stato_uscita: STATO)
			-- Arianna & Riccardo 26/07/2020
			-- elimina gli stati salvati in tutte le storie che si incontrano nel percorso dagli stati di state_chart.config_base allo 'stato_uscita'
			-- Edit Forte, Sarandrea 28/06/2021
			-- correzione errore
		local
			stato_temp: STATO
		do
			across
				state_chart.config_base as cbc
			loop
				if stato_uscita.antenato_di (cbc.item) then
					from
						stato_temp := cbc.item
					until
						stato_temp = stato_uscita
					loop
						if attached stato_temp.genitore as gen then
							if attached gen.storia as storia then
								storia.svuota_memoria
							end
							stato_temp := gen
						end
					end
				end
			end
		end

	salva_storia (stato_config_base, stato_uscente: STATO)
			-- Arianna & Riccardo 05/07/2020
			-- memorizza i percorsi di uscita partendo da 'stato_config_base' e arrivando fino a 'stato_uscente'
		local
			stato_temp: STATO
			percorso_uscita: LINKED_LIST [STATO]
		do
			if stato_uscente /= stato_config_base then
					-- se esco da uno stato atomico non ho storia
				create percorso_uscita.make
				from
					stato_temp := stato_config_base
				until
					stato_temp = stato_uscente
				loop
					percorso_uscita.put_front (stato_temp)
					if attached stato_temp.genitore as gen then
						stato_temp := gen
					end
					if attached {STORIA_DEEP} stato_temp.storia as storia then
							-- se la storia è "deep" salvo tutto l'array del percorso
						storia.aggiungi_stati (percorso_uscita)
					elseif attached {STORIA_SHALLOW} stato_temp.storia as storia then
							-- se la storia è "shallow" salvo solo lo stato uscente allo stesso livello della storia
						storia.memorizza_stato (percorso_uscita.first)
					end
				end
			end
		end

	trova_transizioni_eseguibili (eventi: LINKED_SET [STRING]; variabili: DATAMODEL): ARRAY [TRANSIZIONE]
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
				print ("=============================%N")
				print (" stati sorgenti delle transizioni eseguibili in questo istante%N");
				stampa_stati (sorgenti)
				print ("=============================%N")
			end
			from
				i := sorgenti.lower
			until
				i = sorgenti.upper + 1
			loop
				if i = sorgenti.upper or else not sorgenti [i].antenato_di (sorgenti [i + 1]) then
						-- gli stati in sorgenti non sono tutti stati atomici, perché sono gli stati da cui fisicamente partono le transizioni eseguibili,
						--		e quindi uno stato in sorgenti che è antenato dello stato immediatamente successivo non deve essere considerato, perché
						--		la priorità strutturale object-oriented dà la priorità al secondo. (vedi t_non_determinismo_1_7_3 e 1_7_4)
						-- se non è antenato di questo secondo non è antenato di alcun altro dopo di esso, dal momento che il non essere
						--		antenato di quello immediatamente successivo implica - a causa del riordinamento degli stati in sorgenti in base
						--		all'ordine di specifica nel file .xml - che nessuno dei suoi discendenti possiede transizioni eseguibili

					if attached sorgenti [i].transizione_abilitata (eventi, variabili) as ta then
						debug ("SC_transizioni_eseguibili")
							print (" sorgente " + i.out + ": lo stato " + sorgenti [i].id + " con transizione a destinazione stato " + ta.destinazione.first.id + ". antenato_massimo_uscita = " + antenato_massimo_uscita (ta).id)
						end
						if attached uscita_precedente implies antenato_massimo_uscita (ta).incomparabile_con (uscita_precedente) then
								-- questa transizione mi fa uscire da uno stato incomparabile con quello della precedente transizione
							debug ("SC_transizioni_eseguibili")
								print (" viene mantenuto per la transizione.%N")
							end
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
							debug ("SC_transizioni_eseguibili")
								print (" viene scartato perche' AMU e' antenato o discendente di precedente AMU o coincide.'.%N")
							end
						end
					end
				else
					debug ("SC_transizioni_eseguibili")
						if attached sorgenti [i].transizione_abilitata (eventi, variabili) as ta then
							print (" sorgente " + i.out + ": lo stato " + sorgenti [i].id + " con transizione a destinazione stato " + ta.destinazione.first.id + ". antenato_massimo_uscita = " + antenato_massimo_uscita (ta).id)
							print (" e' antenato di sorgente successiva " + (i + 1).out + ": " + sorgenti [i + 1].id + " e viene scartato.%N")
						end
					end
				end
				i := i + 1
			end
			Result := transizioni
		end

	stati_eseguibili (eventi: LINKED_SET [STRING]; variabili: DATAMODEL): ARRAY [STATO]
			-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
			-- A partire dalla configurazione di base ritorna gli stati che hanno transizioni abilitate in base a `eventi' e `variabili'
			-- N.B. gli stati tornati possono non essere stati atomici, ma stati gerarchici le cui transizioni sono eseguibili dagli stati atomici
			-- loro discendenti, che sono rilevate da `transizione_abilitata' in assenza di transizioni direttamente abilitate nello stato atomico
			-- EN 19/09/2021 per gestione transizioni merge
		do
			create Result.make_empty
			across
				state_chart.config_base as sc_cb
			loop
				debug ("SC_transizioni_eseguibili")
					print ("  stato corrente di config_base: " + sc_cb.item.id + "%N")
				end
				if attached sc_cb.item.transizione_abilitata (eventi, variabili) as ta then
					if ta.merge then
						if sorgenti_multiple_attive (ta) then
							debug ("SC_transizioni_eseguibili")
								print ("    transizione MERGE abilitata%N")
							end
							across
								ta.sorgente as tas
							loop
								Result.force (tas.item, Result.count + 1)
							end
						end
					else
						debug ("SC_transizioni_eseguibili")
							print ("    con transizione abilitata da " + ta.sorgente.first.id + " a " + ta.destinazione.first.id + "%N")
						end
						Result.force (ta.sorgente.first, Result.count + 1)
					end
				end
			end
			Result := riordina_stati (Result)
		end

	sorgenti_multiple_attive (transizione_corrente: TRANSIZIONE): BOOLEAN
			-- ritorna true solo se tutte le sorgenti di una transizione MERGE sono presenti nella configurazione attiva
		do
			Result := true
			debug ("SC_transizioni_eseguibili")
				stampa_sorgenti_multiple (transizione_corrente)
			end
			across
				transizione_corrente.sorgente as s
			loop
				if not state_chart.configurazione_contiene (s.item.id) then
					debug ("SC_transizioni_eseguibili")
						print ("    NON attivabile: lo stato " + s.item.id + " non e' nella configurazione di base. %N")
					end
					Result := False
				end
			end
		end

	aggiungi_stati_attivi (conf_da_modificare: ARRAY [STATO])
			-- Arianna & Riccardo 05/07/2020
			-- aggiunge stati attivi alla configurazione
		do
			across
				state_chart.config_base as sc_cb
			loop
				if sc_cb.item.attivo then
					conf_da_modificare.force (sc_cb.item, conf_da_modificare.count + 1)
				end
			end
		end

	antenato_massimo_uscita (transizione: TRANSIZIONE): STATO
			-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
			-- restituisce l'antenato più grande dal quale si esce con 'transizione'	
			-- si trova il contesto usando solo il primo di sorgente e destinazione perche se
			-- c'è un eventuale transizione fork o merge, se è legale, basta iniziare da uno
			-- qualunque degli stati sorgente o destinazione
		local
		   	 stato_temp, contesto: detachable STATO
		do
			Result := transizione.sorgente.first
			-- TODO: annotato qua per non dimenticarlo; se una transizione va da uno stato in sé stesso NON può essere interna
			-- TODO: se questo non viene controllato durante la lettura della SC allora il test sotto non funziona
			-- TODO: nel caso di una transizione interna di stato atomico su sé stesso perché questo non ha figli
			-- TODO: Analogamente una transizione interna può essere solo discendente (vedere note_diario_corso_24-25)
			if transizione.interna then
				if transizione.sorgente.first.antenato_di (transizione.destinazione.first) then
					stato_temp := transizione.sorgente.first
				else
					stato_temp := transizione.destinazione.first
				end
				across
					stato_temp.figli as figli
				loop
					if figli.item.attivo then
						Result := figli.item
					end
				end
			else
				from
					stato_temp := transizione.sorgente.first
					contesto := trova_contesto (transizione)
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

	aggiungi_paralleli (p_destinazione: STATO; prossima_config_base: ARRAY [STATO])
			-- inserisce in `prossima_config_base' i default degli stati in parallelo rispetto alla destinazione
			-- qualora vi siano stati già attivi non dà luogo a configurazioni non corrette
			-- TODO: la riga precedente non capisco bene che vuol dire, esprimere meglio
		do
			p_destinazione.set_attivo
			if attached {STATO_AND} p_destinazione.genitore as dg and then not dg.attivo then
					-- se lo stato genitore è un AND scorro i suoi figli
				across
					dg.initial as dgi
				loop
					if not dgi.item.is_equal (p_destinazione) then
						aggiungi_sottostati (dgi.item, prossima_config_base)
					end
				end
			end
			if attached p_destinazione.genitore as dg then
					--se ha un genitore ripeto aggiungi paralleli su di lui
				aggiungi_paralleli (dg, prossima_config_base)
			end
		end

	aggiungi_sottostati (stato: STATO; prossima_config_base: ARRAY [STATO])
			-- se la destinazione NON contiene un sottostato attivo si comporta come trova_default
			-- altrimenti entra nello stato destinazione e entra ricorsivamente nei suoi sottostati
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
						aggiungi_sottostati (fsa.item, prossima_config_base)
					end
				else -- ripeto solo sui figli dello stato XOR che hanno un sottostato attivo
					across
						stato.figli as fs
					loop
						if fs.item.ha_sottostati_attivi then
							aggiungi_sottostati (fs.item, prossima_config_base)
						end
					end
				end
			else
				trova_default (stato, prossima_config_base)
			end
		end

	trova_default (stato: STATO; prossima_config_base: ARRAY [STATO])
			-- segue le transizioni di default e aggiunge lo stato atomico a `prossima_config_base'
			-- se è presente una storia (non vuota) allora viene seguita al posto delle transizioni di default
		do
			if attached stato.storia as storia and then not storia.storia_vuota then
				segui_storia (stato, prossima_config_base)
			else
				stato.set_attivo
				esegui_onentry (stato)
				if not stato.initial.is_empty then
					across
						stato.initial as si
					loop
						trova_default (si.item, prossima_config_base)
					end
				else
						-- `stato' è uno stato atomico
					prossima_config_base.force (stato, prossima_config_base.count + 1)
				end
			end
		end

	segui_storia (stato: STATO; prossima_config_base: ARRAY [STATO])
			-- Arianna & Riccardo 05/07/2020
			-- segue il percorso indicato dalla storia
		do
			stato.set_attivo
			esegui_onentry (stato)
			if attached {STORIA_DEEP} stato.storia as st and then attached st.stati_memorizzati as stati then
				across
					stati as sm
				loop
					sm.item.set_attivo
					esegui_onentry (sm.item)
					if attached {STATO_ATOMICO} sm.item then
						prossima_config_base.force (sm.item, prossima_config_base.count + 1)
					end
				end
			elseif attached {STORIA_SHALLOW} stato.storia as st and then attached st.stato_memorizzato as sm then
				trova_default (sm, prossima_config_base)
			end
		end

	trova_contesto (p_transizione: TRANSIZIONE): detachable STATO
			-- trova il contesto in base alla specifica SCXML secondo cui il contesto
			-- è il minimo antenato comune PROPRIO a p_sorgente e p_destinazione che sia STATO_XOR
			-- a meno che la transizione sia interna, nel qual caso è il minimo antenato
			-- comune, che quindi coincide con uno dei due, perché la transizione interna
			-- coinvolge sempre due stati uno antenato dell'altro
			-- TODO: Attenzione agli appunti scritti in note_diario_corso_24-25
		local
			antenati: HASH_TABLE [STRING, STRING]
			corrente: STATO
			p_sorgente, p_destinazione: STATO
		do
			p_sorgente := p_transizione.sorgente.first
			p_destinazione := p_transizione.destinazione.first
			if p_transizione.interna then
				if p_sorgente.antenato_di(p_destinazione) then
					Result := p_sorgente
				else
					Result := p_destinazione
				end
			else
				create antenati.make (0)
					-- "marca" tutti gli antenati di p_sorgente incluso p_destinazione
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
            from
            until
            	Result = Void or else attached {STATO_XOR} Result
            loop
            	Result := Result.genitore
            end
		end

feature -- esecuzione azioni

	esegui_azioni (transizione: TRANSIZIONE)
		local
			contesto: detachable STATO
		do
			-- si trova il contesto usando solo il primo di sorgente e destinazione perche se
			-- c'è un eventuale transizione fork o merge, se è legale, basta iniziare da uno
			-- qualunque degli stati sorgente o destinazione

			contesto := trova_contesto (transizione)
			esegui_azioni_onexit (antenato_massimo_uscita (transizione))
			esegui_azioni_transizione (transizione.azioni)
			esegui_azioni_onentry (contesto, transizione.destinazione.first)
		end

	esegui_onexit (p_stato_corrente: STATO)
		do
			if p_stato_corrente.onexit.count > 0 then
				across
					p_stato_corrente.onexit as ox
				loop
					ox.item.esegui (state_chart.variabili)
				end
			end
		end

	esegui_onentry (p_stato_corrente: STATO)
		do
			if p_stato_corrente.onentry.count > 0 then
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
			if attached {STATO_GERARCHICO} stato_uscita then
				across
					stato_uscita.figli as sf
				loop
					if sf.item.attivo then
						esegui_azioni_onexit (sf.item)
					end
				end
			end
			esegui_onexit (stato_uscita)
			stato_uscita.set_inattivo
		end

	esegui_azioni_transizione (p_azioni: ARRAY [AZIONE])
		do
			across
				p_azioni as pa
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
			contesto: state_chart.config_base /= Void
		do
			across
				state_chart.config_base as cbc
			loop
				if cbc.item.finale then
					result := True
				end
			end
		end

feature -- utilita

	trova_stati_figli_attivi (stato: STATO): LINKED_LIST [STATO]
			-- funzione che restituisce i figli attivi di uno stato in modo ricorsivo
		local
			figli_attivi: LINKED_LIST [STATO]
		do
			create figli_attivi.make
			across
				stato.figli as figlio
			loop
				if figlio.item.attivo then
					figli_attivi.extend (figlio.item)
					figli_attivi.append (trova_stati_figli_attivi (figlio.item))
				end
			end
			Result := figli_attivi
		end

	riordina_stati (p_stati: ARRAY [STATO]): ARRAY [STATO]
			-- Agulini Claudia & Fiorini Federico 11/05/2020
			-- Riordina `p_stati' in base all'ordine del file .xml, che è quello con cui sono stati creati gli stati
		local
			stati_ordinati: ARRAY [STATO]
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

	stampa_conf_corrente (indice: INTEGER)
		do
			print ("%NIstante corrente = ")
			print (indice)
			print ("%N")
			print ("  configurazione BASE corrente: ")
			across
				state_chart.config_base as sc_cb
			loop
				print (sc_cb.item.id + " ")
			end
			print (" %N")
			if indice <= ambiente_corrente.eventi_esterni.count then
				print ("  eventi correnti : ")
				across
					ambiente_corrente.eventi_esterni [indice] as eventi_correnti
				loop
					print (eventi_correnti.item + " ")
				end
				print (" %N")
			end
		end

	stampa_sorgenti_multiple (transizione_corrente: TRANSIZIONE)
		do
			print ("  transizione con sorgenti multiple da: ")
			across
				transizione_corrente.sorgente as s
			loop
				print (s.item.id + " ")
			end
			print (" a: " + transizione_corrente.destinazione.first.id + "%N")
		end

	stampa_stati (stati: ARRAY [STATO])
		do
			across
				stati as s
			loop
				s.item.stampa
			end
		end

	stampa_storia (stato_storia: STATO)
		do
			if attached {STORIA_DEEP} stato_storia.storia as ss then
				if attached ss.stati_memorizzati as ssm then
					print (" Storia di ")
					print (stato_storia.id)
					print (" : ")
					across
						ssm as sm
					loop
						print (sm.item.id + " ")
					end
					print ("%N")
				end
			elseif attached {STORIA_SHALLOW} stato_storia.storia as ss then
				if attached ss.stato_memorizzato as ssm then
					print (" Storia di ")
					print (stato_storia.id)
					print (" : ")
					print (ssm.id)
					print ("%N")
				end
			end
			across
				stato_storia.figli as figlio
			loop
				stampa_storia (figlio.item)
			end
		end

end
