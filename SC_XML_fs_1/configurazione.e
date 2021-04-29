note
	description: "La classe che rappresenta la statechart"
	author: "EN + studenti corsi PSI"
	date: "Agosto 2020"
	revision: "$Revision$"

class
	CONFIGURAZIONE

create
	make

feature -- attributi

	conf_base: ARRAY [STATO]
		-- gli stati atomici nella configurazione di base della statechart

	stati: HASH_TABLE [STATO, STRING]
		-- gli stati della statechart

	variabili: DATAMODEL
		-- le variabili del datamodel associato alla statechart

	creatore_di_assegna: ASSEGNA_CREATORE
		-- creatore parametrico delle istanze di ASSEGNA

	albero: XML_CALLBACKS_NULL_FILTER_DOCUMENT
		-- albero XML con la SC letta dal file

	ha_problemi_con_il_file_della_sc: BOOLEAN

feature -- creazione

	make (nome_SC: STRING)
		do
			create conf_base.make_empty
			create stati.make (1)
			create variabili.make
			create creatore_di_assegna
			crea_albero (nome_SC)
			if not ha_problemi_con_il_file_della_sc then
				crea_stati_e_condizioni
			end
		end

feature -- supporto alla creazione

	crea_albero (nome_file_SC: STRING)
		-- crea e inizializza `albero' XML che rappresenta la SC
		local
			parser: XML_PARSER
			path_file_SC: PATH
		do
				--| Instantiate parser
			create {XML_STANDARD_PARSER} parser.make
				--| Build tree callbacks
			create albero.make_null
			create path_file_SC.make_from_string (nome_file_SC)
			parser.set_callbacks (albero)
				--| Parse the `file_name' content
			parser.parse_from_path (path_file_SC)
			if parser.error_occurred then
				print ("Parsing error!!! %N ID: ")
				print (parser.last_error)
				print (" - ")
				print (parser.last_error_description)
				print ("%N ")
				ha_problemi_con_il_file_della_sc := True
			else
				print ("Parsing OK. %N")
				ha_problemi_con_il_file_della_sc := False
			end
		end

	crea_stati_e_condizioni
		--	riempie le hashtable degli stati e delle condizioni
		--	inizializza ogni stato con le sue transizioni con eventi ed azioni
		do
			if attached {XML_ELEMENT} albero.document.first as f then
				istanzia_datamodel (f.elements)
				istanzia_final (f.elements)
				istanzia_stati (f.elements, Void)
				assegna_initial (f.elements)
				inizializza_conf_base_radice (f)
				completa_stati (f.elements)
			end
		end

feature -- inizializzazione SC

	istanzia_datamodel (elements: LIST [XML_ELEMENT])
		-- istanzia il <datamodel>, che pu� essere anche suddiviso in pi� nodi
		do
			across
				elements as e
			loop
				if e.item.name ~ "datamodel" then
					if e.item.elements.is_empty then
						print ("AVVISO: il <datamodel> non contiene elementi <data>!%N")
					else
						across e.item.elements as data
						loop
							if attached {XML_ATTRIBUTE} data.item.attribute_by_name ("id") as nome then
								if nome.value ~ "" then
									print ("ERRORE: elemento <data> con 'id' di valore stringa vuota!%N")
								elseif attached {XML_ATTRIBUTE} data.item.attribute_by_name ("expr") as valore then
									if valore_booleano(valore.value) then
										condizioni.extend (valore.value.as_lower ~ "true", nome.value)
									else
										print ("ERRORE: elemento <data> con id >|" + nome.value + "|< assegna a 'expr' il valore >|" + valore.value + "|< non booleano!%N")
									end
								else
									print ("ERRORE: elemento <data> con id >|" + nome.value + "<| senza attributo 'expr'!%N")
								end
							else
								print ("ERRORE: elemento <data> senza attributo 'id'!%N")
							end
						end
					end
				else
					print ("ERRORE: elemento <data> senza attributo 'id'!%N")
				end
			end
			-- aggiunge variabile booleana '{TRANSIZIONE}.Valore_Nullo' che � sempre True e si usa per le transizioni che non specificano una condizione nel file del modello
			variabili.booleane.extend (True, {TRANSIZIONE}.Valore_Nullo)
		end

	assegna_variabile (variabile, espressione: STRING)
		do
		-- assegna il valore alla singola variabile del <datamodel>
			if valore_booleano (espressione) then
				variabili.booleane.extend (espressione.as_lower ~ "true", variabile)
				debug ("SC_inizializza_variabili") print ("Booleano: " + variabile + " = " + variabili.booleane [variabile].out + "%N") end
			elseif valore_intero (espressione) then
				variabili.intere.extend (espressione.to_integer, variabile)
				debug ("SC_inizializza_variabili") print ("Intero: " + variabile + " = " + variabili.intere [variabile].out + "%N") end
			else
				print ("ERRORE: elemento <data> con id >|" + variabile + "|< assegna a 'expr' il valore >|" + espressione + "|< non booleano e non intero!%N")
			end
		end

	istanzia_final (elements: LIST [XML_ELEMENT])
		-- istanzia nella SC lo stato <final>
		do
			across
				elements as e
			loop
				if e.item.name ~ "final" and attached e.item.attribute_by_name ("id") as id then
				-- TODO: avvisare se "id" � assente
					stati.extend (create {STATO}.make_final_with_id (id.value), id.value)
				end
			end
		end

	istanzia_stati (elements: LIST [XML_ELEMENT]; p_genitore: detachable STATO)
		-- crea gli stati assegnando loro l'eventuale genitore e gli eventuali figli
		-- TODO: feature complessa, � possibile semplificarla?
		local
			stato_temp: STATO
		do
			across
				elements as e
			loop
				if (e.item.name ~ "state" or e.item.name ~ "parallel") then
					if not attached e.item.attribute_by_name ("id") then
						print ("ERRORE: il seguente elemento <state> o <parallel> non ha 'id':%N")
						stampa_elemento (e.item)
					elseif attached e.item.attribute_by_name ("id") as id_attr then
						if id_attr.value ~ "" or id_attr.value.is_whitespace then
							print ("ERRORE: il seguente elemento <state> o <parallel> ha un 'id' di valore stringa vuota o blank!%N")
							stampa_elemento (e.item)
						elseif stati.has (id_attr.value) then
							print ("ERRORE: il seguente elemento <state> o <parallel> ha un 'id' duplicato!%N")
							stampa_elemento (e.item)
						else
							if e.item.name ~ "state" then
								if e.item.has_element_by_name ("state") or e.item.has_element_by_name ("parallel") then
									-- elemento corrente <state> ha figli, quindi � gerarchico
									if attached p_genitore as pg then
										-- istanzio elemento corrente con genitore e glielo assegno come figlio
										stato_temp := create {STATO_XOR}.make_with_id_and_parent (id_attr.value, pg)
										pg.add_figlio (stato_temp)
									else -- istanzio elemento corrente senza genitore
										stato_temp := create {STATO_XOR}.make_with_id (id_attr.value)
									end
									stati.extend (stato_temp, id_attr.value)
									-- ricorsione sui figli con s� stesso come genitore
									istanzia_stati (e.item.elements, stati.item (id_attr.value))
								else -- elemento corrente <state> non ha figli, quindi � atomico
									if attached p_genitore as pg then
										-- istanzio elemento corrente con genitore e glielo assegno come figlio
										stato_temp := create {STATO}.make_with_id_and_parent (id_attr.value, pg)
										pg.add_figlio (stato_temp)
									else -- istanzio elemento corrente senza genitore
										stato_temp := create {STATO}.make_with_id (id_attr.value)
									end
									stati.extend (stato_temp, id_attr.value)
								end
							end
							if e.item.name ~ "parallel" then
								if e.item.has_element_by_name ("state") or e.item.has_element_by_name ("parallel") then
									-- elemento corrente <parallel> ha figli
									if attached p_genitore as pg then
										-- istanzio elemento corrente con genitore e glielo assegno come figlio
										stato_temp := create {STATO_AND}.make_with_id_and_parent (id_attr.value, pg)
										pg.add_figlio (stato_temp)
									else -- istanzio elemento corrente senza genitore
										stato_temp := create {STATO_AND}.make_with_id (id_attr.value)
									end
									stati.extend (stato_temp, id_attr.value)
										-- ricorsione sui figli con s� stesso come genitore
									istanzia_stati (e.item.elements, stati.item (id_attr.value))
								else -- elemento corrente <parallel> non ha figli
									print ("ERRORE: lo stato <parallel> >|" + id_attr.value + "|< non ha figli !%N")
								end
							end
						end
					end
				end
			end
		end

	assegna_initial (elements: LIST [XML_ELEMENT])
		-- assegna ricorsivamente agli stati i loro sotto-stati iniziali di default
		-- NB: regolarit� di 'id' � stata gi� controllata in `istanzia_stati'
		do
			across
				elements as e
			loop
				debug ("SC_assegna_initial") if e.item.name ~ "state" or e.item.name ~ "parallel" then stampa_elemento (e.item) end end
				-- NB: gli stati atomici non sono n� {STATO_XOR} n� {STATO_AND}
				if e.item.name ~ "state" and attached e.item.attribute_by_name ("id") as id_attr then
					if attached {STATO_XOR} stati.item (id_attr.value) as stato then
						-- istanza di stato {STATO_XOR} ha certamente figli
						if attached e.item.attribute_by_name ("initial") as initial_attr then
								-- `e.item' ha attributo 'initial'
							if attached stati.item (initial_attr.value) as initial_state then
								if stato.figli.has (initial_state) then
									stato.set_initial (initial_state)
								else
									print ("ERRORE: lo stato >|" + initial_attr.value + "|< indicato come sotto-stato iniziale di default dello stato >|" + stato.id + "|< non e' figlio di questo stato!%N")
								end
							else
								print ("ERRORE: lo stato >|" + initial_attr.value + "|< indicato come sotto-stato iniziale di default dello stato >|" + stato.id + "|< non esiste!%N")
							end
						else -- `e.item' non ha attributo 'initial' ma certamente first_sub_state ritorna figlio <state> o <parallel>
							print ("AVVISO: lo <state> >|" + stato.id + "|< non specifica attributo 'initial', si sceglie il primo figlio che sia <state> o <parallel>.%N")
							if attached first_sub_state (e.item) as fss then
								stato.set_initial (fss)
							end
						end
						-- ricorsione sui figli
						assegna_initial (e.item.elements)
					else -- si tratta di uno stato atomico, non deve avere attributo initial
						if attached e.item.attribute_by_name ("initial") and attached stati.item (id_attr.value) as stato then
							print ("AVVISO: lo <state> >|" + stato.id + "|< specifica attributo 'initial' senza avere figli.%N")
						end
					end
				end
				if e.item.name ~ "parallel" and attached e.item.attribute_by_name ("id") as id_attr then
					if attached {STATO_AND} stati.item (id_attr.value) as stato then
						stato.set_initial
					end
					-- ricorsione sui figli
					assegna_initial (e.item.elements)
				end
			end
		end

	inizializza_conf_base_radice (radice: XML_ELEMENT)
		-- inizializza la radice di `conf_base' in base a stato top iniziale e poi invoca inizializzazione ricorsiva con esso
		-- NB: gli stati "top" della SC non hanno genitore
		local
			iniziale_SC: detachable STATO
		do
			if attached radice.attribute_by_name ("initial") as initial_attr then
				if attached stati.item (initial_attr.value) as r then
					if not attached r.genitore then
						iniziale_SC := r
					else
						print ("ERRORE: lo stato >|" + initial_attr.value + "|< indicato come stato iniziale della statechart non � uno degli stati 'top'!%N")
					end
				else -- l'initial della radice non esiste
					print ("ERRORE: lo stato >|" + initial_attr.value + "|< indicato come stato iniziale della statechart non esiste!%N")
				end
			else -- la SC non specifica un sotto-stato iniziale di default si sceglie il primo
				print ("AVVISO: la SC non specifica attributo 'initial', si sceglie il primo figlio che sia <state> o <parallel>.%N")
				iniziale_SC := first_sub_state (radice)
			end
			if attached iniziale_SC as isc then
				inizializza_conf_base (isc)
			else
				print ("ERRORE: la SC non specifica attributo 'initial' ma non ha figli <state> o <parallel>!%N")
			end

		end

	inizializza_conf_base (stato: STATO)
		-- assegna ricorsivamente gli stati a `conf_base' a partire dallo stato gerarchico iniziale della SC
		-- NB: ogni stato gerarchico della SC ha la feature `initial' non vuota
		do
			stato.set_attivo
			if stato.initial.is_empty then
				-- `stato' � uno stato atomico
				conf_base.force (stato, conf_base.count + 1)
			else -- `stato' � uno stato gerarchico e si scende in ricorsione
				across
					stato.initial as figli
				loop
					inizializza_conf_base (figli.item)
				end
			end
		end

	completa_stati (elements: LIST [XML_ELEMENT])
		-- assegna ricorsivamente agli stati le transizioni (con eventi e azioni), le onentry/onexit, le history
		do
			across
				elements as e
			loop
				if (e.item.name ~ "state" or e.item.name ~ "parallel") and attached e.item.attribute_by_name ("id") as id_stato then
					-- assenza di 'id' viene controllata in `istanzia_stati'
					completa_stati (e.item.elements)
					if attached stati.item (id_stato.value) as stato then
						-- lo stato esiste perch� viene creato in `stati' da `istanzia_stati'
						assegna_discendenti (stato, e.item)
					end
				end
				stato.add_storia (storia_temp)
			end
			if attached {STATO_AND} stato as st_and then
			-- and then e.item.has_element_by_name ("history") then
				print ("AVVISO: " + st_and.id + " � uno stato parallelo, pertanto la sua storia non verr� considerata!%N")
			end
		end


	assegna_discendenti (stato: STATO; element: XML_ELEMENT)
		-- completa lo `stato' assegnandogli i vari discendenti (transizioni, onentry, onexit)
		do
			across element.elements as e
			loop
				if e.item.name ~ "transition" then
					assegna_transizioni(stato, e.item)
				end
			else
				print ("ERRORE: lo stato >|" + stato.id + "|< ha una transizione con destinazione non specificata (manca il 'target')!%N")
			end
		end

	transizione_illegale (p_sorgente, p_destinazione: STATO): BOOLEAN
			-- transizione � illegale se il minimo antenato comune (mac) � <parallel> e:
			-- sorgente e destinazione sono uno antenato dell'altro e sono tutti <parallel> dal pi� alto al genitore del pi� basso
			-- mac � diverso da entrambi (attraversamento frontiera)
		local
			stato_mac, altro_stato: STATO
		do
			debug ("sc_transizione_illegale") print ("transizione da >|" + p_sorgente.id + "|< a >|" + p_destinazione.id + "|< ") end
			stato_mac := minimo_antenato_comune (p_sorgente, p_destinazione)
			if attached {STATO_AND} stato_mac then
				if transizione_verticale (p_sorgente, p_destinazione) then
					if stato_mac = p_sorgente then
						altro_stato := p_destinazione
					else
						altro_stato := p_sorgente
					end
					if catena_di_paralleli (altro_stato, stato_mac) then
						Result := True
						debug ("sc_transizione_illegale") print (" illegale: transizione con MAC <parallel> in verticale e catena di <parallel> %N") end
					end
				else -- stato_mac � diverso da entrambi
					Result := True
					debug ("sc_transizione_illegale") print (" illegale: transizione con MAC <parallel> in orizzontale tra discendenti del MAC (attraversa la frontiera)%N") end
				end
			end
		end

	transizione_verticale (p_sorgente, p_destinazione: STATO): BOOLEAN
			-- ritorna vero se `p_sorgente' e `p_destinazione' sono uno antenato dell'altro
		do
			Result := p_sorgente.antenato_di (p_destinazione) or p_destinazione.antenato_di (p_sorgente)
		end

	minimo_antenato_comune (p_sorgente, p_destinazione: STATO): detachable STATO
			-- torna il minimo antenato comune eventualmente coincidente con uno dei due
		local
			antenati: HASH_TABLE [STRING, STRING]
			corrente: STATO
		do
			create antenati.make (0)
				-- "marca" tutti gli antenati di p_sorgente lui compreso
			from
				corrente := p_sorgente
			until
				corrente = Void
			loop
				antenati.put (corrente.id, corrente.id)
				corrente := corrente.genitore
			end
				-- trova il pi� basso antenato di p_destinazione in "antenati" a partire da lui stesso
			from
				corrente := p_destinazione
			until
				corrente = Void or else antenati.has (corrente.id)
			loop
				corrente := corrente.genitore
			end
			Result := corrente
		end

	catena_di_paralleli (basso, alto: STATO): BOOLEAN
			-- ritorna vero se dal genitore di `basso' c'� una catena continua di <parallel> fino ad `alto' che � il "mac"
		local
			corrente: STATO
		do
			corrente := basso.genitore
			if corrente = alto then
				Result := True
			elseif attached {STATO_XOR} corrente then
				Result := False
			else
				if attached corrente as c then
					Result := catena_di_paralleli (c, alto)
				end
			end
		end

	assegna_transizioni (stato: STATO; element: XML_ELEMENT)
		-- completa lo `stato' assegnandogli le transizioni con relativi eventi ed azioni
		local
			transizione: TRANSIZIONE
		do
			debug ("SC_assegna_transizioni") stampa_elemento (element) end
			if attached element.attribute_by_name ("target") as t then
				-- AGGIUNTE PER COSTRUTTO FORK
				if attached stati.item (t.value.split(' ').first) as destinazione then -- uso come primo target il primo che compare
					if not transizione_illegale (stato, destinazione) and transizione_multitarget_ammissibile(t.value.split(' ')) then --INSERIRE QUI MODIFICHE--
						create transizione.make_with_target (destinazione, stato)
						if attached element.attribute_by_name ("type") as type then
							if type.value ~ "internal" and verifica_internal (transizione.sorgente, transizione.target) then
								transizione.set_internal
							end
						end
						if  t.value.split(' ').count>1  --se c'� un multitarget la indico come transizione fork
						then
							transizione.set_fork
							across t.value.split(' ') as it  --scorro tutti i multitarget splittati e aggiungo i target						
							loop
							if attached stati.item(it.item) as s then transizione.add_target (s) end
							end
						end
				--FINE AGGIUNTE		
						assegna_evento (element, transizione)
						assegna_condizione (element, transizione)
						assegna_azioni (element.elements, transizione)
						stato.aggiungi_transizione (transizione)
					else
						print ("ERRORE: transizione non legale! ")
						if not transizione_multitarget_ammissibile(t.value.split(' ')) then
							print ("(multitarget non ammissibile) %N")
						else
							print ("da >|" + stato.id + "|< a >|" + destinazione.id + "|< %N")
						end

					end
				else
					print ("ERRORE: lo stato >|" + stato.id + "|< ha una transizione con destinazione >|" + t.value.split(' ').first + "|< che non appartiene alla SC!%N")
				end
			else
				print ("ERRORE: lo stato >|" + stato.id + "|< ha una transizione con destinazione non specificata (manca il 'target')!%N")
			end
		end

	assegna_condizione (transition: XML_ELEMENT; transizione: TRANSIZIONE)
	-- TODO: migliorare il controllo della correttezza sintattica delle condizione per interi
		do
			if attached transition.attribute_by_name ("cond") as cond then
				if id_illegittimo (cond.value) then
					print ("ERRORE: la transizione da >|" + transizione.sorgente.id + "|< a >|" + transizione.destinazione.id + "|< specifica una condizione di valore >|" + cond.value + "|< stringa vuota o blank o Valore_Nullo !%N")
				else
					if booleana_legittima (cond.value) or intera_legittima (cond.value) then
						transizione.set_condizione (pulisci_stringa (cond.value))
					else
						print ("ERRORE: la transizione da >|" + transizione.sorgente.id + "|< a >|" + transizione.destinazione.id + "|< specifica una condizione di valore (non pulito) >|" + cond.value + "|< illegittimo !%N")
					end
				end
			else
				transizione.set_condizione ({TRANSIZIONE}.Valore_Nullo)
			end
		end

	booleana_legittima (stringa: STRING): BOOLEAN
	-- verifica che `stringa' sia una condizione booleana legittima
		do
			if variabili.booleane.has (pulisci_stringa (stringa)) then
				Result := True
			else
				Result := False
			end
		end

	intera_legittima (stringa: STRING): BOOLEAN
	-- verifica che `stringa' sia una condizione intera legittima
	-- TODO: si ripetono alcuni controlli fatti in TRANSIZIONI.check_condizione_intera per la verifica della condizione
	-- TODO: verificare/definire quale deve essere la forma sintatticamente corretta delle condizioni (qualcosa � in TRANSIZIONI)
	-- TODO: usare libreria di Eiffel 'parse' per analisi di correttezza della stringa delle condizioni (va aggiunta al progetto)
		local
			var: STRING
		do
			if stringa.has ('<') then
				var := stringa.substring (1, stringa.index_of ('<', 1) - 1)
			elseif stringa.has ('>') then
				var := stringa.substring (1, stringa.index_of ('>', 1) - 1)
			elseif stringa.has ('/') then
				var := stringa.substring (1, stringa.index_of ('/', 1) - 1)
			elseif stringa.has ('=') then
				var := stringa.substring (1, stringa.index_of ('=', 1) - 1)
			else
				Result := False
			end
			if attached var as v then
				if variabili.intere.has (pulisci_stringa (v)) then
					Result := True
				else
					Result := False
				end
			end
		end

feature -- inizializzazione azioni

	assegna_azioni (action_list: LIST [XML_ELEMENT]; transizione: TRANSIZIONE)
		-- assegna le azioni in `action_list' alla `transizione'
		do
			across
				action_list as al
			loop
				if al.item.name ~ "assign" then
					assegna_azione_assign (al.item, transizione)
				elseif al.item.name ~ "log" then
					assegna_azione_log (al.item, transizione)
				else
					print ("AVVISO: la transizione da >|" + transizione.sorgente.id + "|< a >|" + transizione.destinazione.id + "|< specifica un'azione >|" + al.item.name + "|< sconosciuta!%N")
				end
			end
		end

	assegna_azione_assign (p_azione: XML_ELEMENT; transizione: TRANSIZIONE)
		local
			testo, esito, variabile, espressione: STRING
		do
			esito := creatore_di_assegna.ammissibile (p_azione, variabili).esito
			variabile := creatore_di_assegna.ammissibile (p_azione, variabili).variabile
			espressione := creatore_di_assegna.ammissibile (p_azione, variabili).espressione
			if esito ~ "OK" then
				transizione.azioni.force (creatore_di_assegna.crea_istanza (variabile, espressione), transizione.azioni.count + 1)
			else
				testo := "nella transizione con evento >|" + nome_evento(transizione) + "|< da >|" + transizione.sorgente.id + "|< a >|" + transizione.destinazione.id + "|<"
				creatore_di_assegna.stampa_errata (testo, esito, variabile, espressione)
			end
		end

	nome_evento (transizione: TRANSIZIONE): STRING
		do
			if attached transizione.evento as te then
				Result := te
			else
				Result := "NULL"
			end
		end

	assegna_azione_log (p_azione: XML_ELEMENT; transizione: TRANSIZIONE)
		do
			if attached p_azione.attribute_by_name ("name") as name then
				transizione.azioni.force (create {STAMPA}.make_with_text (name.value), transizione.azioni.count + 1)
			else
				print ("ERRORE: l'azione <log> nella transizione con evento >|" + nome_evento(transizione) + "|< da >|" + transizione.sorgente.id + "|< a >|" + transizione.destinazione.id + "|< non ha attributo 'name'!%N")
			end
		end

	verifica_internal (sorgente, target: STATO): BOOLEAN
		do
			if attached{STATO_XOR} sorgente then
				-- secondo la specifica XML `internal' pu� essere eseguita solo con sorgente XOR
				if attached target.genitore as tr_gn then
					if tr_gn = sorgente then
						Result := TRUE
					else
						Result := verifica_internal (sorgente, tr_gn)
					end
				end
			end
		end

	istanzia_onentry (stato: STATO; elements: LIST [XML_ELEMENT])
		do
			across
				action_list as al
			loop
				if al.item.name ~ "assign" then
					assegna_onentry_assign (al.item, stato)
				elseif al.item.name ~ "log" then
					assegna_onentry_log (al.item, stato)
				else
					print ("ERRORE: l'azione >|" + al.item.name + "|< specificata in <onentry> per lo stato >|" + stato.id + "|< non e' ammissibile!%N")
				end
			end
		end

	assegna_onexit (action_list: LIST [XML_ELEMENT]; stato: STATO)
			-- assegna a 'stato' come onexit le azioni in `action_list'
		do
			across
				action_list as al
			loop
				if al.item.name ~ "assign" then
					assegna_onexit_assign (al.item, stato)
				elseif al.item.name ~ "log" then
					assegna_onexit_log (al.item, stato)
				else
					print ("ERRORE: l'azione >|" + al.item.name + "|< specificata in <onexit> per lo stato >|" + stato.id + "|< non e' ammissibile!%N")
				end
			end
		end

	assegna_onentry_assign (p_azione: XML_ELEMENT; stato: STATO)
		local
			testo, esito, variabile, espressione: STRING
		do
			esito := creatore_di_assegna.ammissibile (p_azione, variabili).esito
			variabile := creatore_di_assegna.ammissibile (p_azione, variabili).variabile
			espressione := creatore_di_assegna.ammissibile (p_azione, variabili).espressione
			if esito ~ "OK" then
				stato.set_onentry (creatore_di_assegna.crea_istanza (variabile, espressione))
			else
				testo := "specificata in <onentry> per lo stato >|" + stato.id + "|<"
				creatore_di_assegna.stampa_errata (testo, esito, variabile, espressione)
			end
		end

	assegna_onexit_assign (p_azione: XML_ELEMENT; stato: STATO)
		local
			testo, esito, variabile, espressione: STRING
		do
			esito := creatore_di_assegna.ammissibile (p_azione, variabili).esito
			variabile := creatore_di_assegna.ammissibile (p_azione, variabili).variabile
			espressione := creatore_di_assegna.ammissibile (p_azione, variabili).espressione
			if esito ~ "OK" then
				stato.set_onexit (creatore_di_assegna.crea_istanza (variabile, espressione))
			else
				testo := "specificata in <onexit> per lo stato >|" + stato.id + "|<"
				creatore_di_assegna.stampa_errata (testo, esito, variabile, espressione)
			end
		end

	assegna_onentry_log (p_azione: XML_ELEMENT; stato: STATO)
		do
			if attached p_azione.attribute_by_name ("name") as name then
				stato.set_onentry (create {STAMPA}.make_with_text (name.value))
			else
				print ("ERRORE: l'azione <log> specificata in <onentry> per lo stato >|" + stato.id + "|< non ha attributo 'name'!%N")
			end
		end

	assegna_onexit_log (p_azione: XML_ELEMENT; stato: STATO)
		do
			if attached p_azione.attribute_by_name ("name") as name then
				stato.set_onexit (create {STAMPA}.make_with_text (name.value))
			else
				print ("ERRORE: l'azione <log> specificata in <onexit> per lo stato >|" + stato.id + "|< non ha attributo 'name'!%N")
			end
		end

feature -- supporto generale

	pulisci_stringa (stringa: STRING): STRING
	-- elimina eventuali blank iniziali o finali
		do
			stringa.prune_all_leading (' ')
			stringa.prune_all_trailing (' ')
			Result := stringa
		end

	id_illegittimo (stringa: STRING): BOOLEAN
		local
			-- {TRANSIZIONE}.Valore_Nullo � una costante e non posso convertirla 'as_lower'
			valore_nullo: STRING
		do
			valore_nullo := {TRANSIZIONE}.Valore_Nullo
			if stringa ~ "" or stringa.is_whitespace or stringa.as_lower ~ valore_nullo.as_lower  then
				-- il Valore_Nullo non pu� essere specificato nel model ma solo assegnato nella costruzione della SC
				Result := True
			else
				Result := False
			end
		end

	first_sub_state (element: XML_ELEMENT): detachable STATO
	-- torna il primo elemento <state> o <parallel> figlio di `element', se esiste
		local
			place_holder: INDEXABLE_ITERATION_CURSOR [XML_ELEMENT]
		do
			debug ("SC_first_sub_state") print ("elemento passato: %N"); stampa_elemento (element) end
--			create Result.make_with_id ({TRANSIZIONE}.Valore_Nullo)
			across
				element.elements as e
			from
				place_holder := e.new_cursor
			until
				e.item.name ~ "state" or e.item.name ~ "parallel"
			loop
				place_holder := e
			end
			if place_holder.after then
				print ("ERRORE: non esistono <state> o <parallel> nel modello!%N")
			else
				debug ("SC_first_sub_state") print ("AVVISO: trovato primo figlio <state> o <parallel>%N"); stampa_elemento (place_holder.item) end
				-- NB: regolarit� di 'id' � stata gi� controllata in `istanzia_stati'
				if attached place_holder.item.attribute_by_name ("id") as id_attr then
					if attached stati.item (id_attr.value) as sub_state then
						Result := sub_state
					end
				end
			end

		end

	--MODIFICHE FORK

	transizione_multitarget_ammissibile(lista_stati: LIST[READABLE_STRING_32]):BOOLEAN
		--prende in imput una  lista di stati e ritorna True se sono ammissibili come multitarget
		--di una transizione fork: a due a due devono avere un antenato di tipo AND in comune
		--e non devono essere l'uno discendente dell'altro.
	do
		Result:=True
		across lista_stati as stato loop
			across lista_stati as altro_stato loop
				if attached stati.item(stato.item) as sc then
					if attached stati.item(altro_stato.item) as asc then
						if not sc.is_equal (asc) then
							if transizione_verticale(sc,asc) or not attached {STATO_AND} minimo_antenato_comune(sc,asc) then
								Result:=False
							end
						end
					end
				end
			end
		end
	end

	--FINE MODIFICHE FORK


	stampa_elemento (element: XML_ELEMENT)
		do
			print ("%NXML_ELEMENT = " + element.name)
			if element.name ~ "transition" then
				print ("%N   con evento " + valore_attributo (element, "event"))
				print ("%N   con condizione " + valore_attributo (element, "cond"))
				print ("%N   con destinazione " + valore_attributo (element, "target"))
				print ("%N")
			elseif element.has_attribute_by_name ("id") then
				print (" e id = " + valore_attributo (element, "id"))
			end
			print (" che ha come elementi figli:%N")
			across
				element.elements as e
			loop
				print ("  nome: " + e.item.name)
				if e.item.has_attribute_by_name ("id") then
					print (" e id = " + valore_attributo (e.item, "id"))
				end
				print ("%N")
			end
			print ("%N")
		end

	valore_attributo (element: XML_ELEMENT; attribute_name: STRING): STRING
		do
			create Result.make_empty
			if attached element.attribute_by_name (attribute_name) as attr then
				Result := attr.value
			end
		end

	valore_booleano (valore: READABLE_STRING_32): BOOLEAN
		-- TODO: feature duplicata in ASSEGNA, da risolvere
		do
			Result := valore.as_lower ~ "true" or valore.as_lower ~ "false"
		end

	valore_intero (valore: READABLE_STRING_32): BOOLEAN
		-- TODO: feature duplicata in ASSEGNA, da risolvere
		do
			Result := valore.is_integer
		end

		-- Aggiungere 'feature' per tracciare quanto accade scrivendo su file model_out.txt:
		--  l'evoluzione della SC in termini di sequenza di quintuple:
		--  n_passo: configurazione_base, eventi, variabili (nomi e valori iniziali), azioni da eseguire

end
