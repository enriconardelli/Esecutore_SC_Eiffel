note
	description: "La classe che rappresenta la statechart"
	author: "Daniele Fakhoury & Eloisa Scarsella & Luca Biondo & Simone Longhi"
	date: "20 aprile 2018"
	revision: "2"

class
	CONFIGURAZIONE

create
	make

feature --attributi

	conf_base_iniziale: ARRAY[STATO]
		-- l'insieme degli stati base da cui parte la statechart

	stati: HASH_TABLE [STATO, STRING]
		-- rappresenta gli stati della statechart

	condizioni: HASH_TABLE [BOOLEAN, STRING]
		-- rappresenta le condizioni della statechart

	albero: XML_CALLBACKS_NULL_FILTER_DOCUMENT
		-- rappresenta sotto forma di un albero XML la SC letta dal file

	ha_problemi_con_il_file_della_sc: BOOLEAN

feature -- creazione

	make (nome_SC: STRING)
		do
--			create stato_iniziale.make_with_id (create {STRING}.make_empty)
--			stato_iniziale.set_final
			create conf_base_iniziale.make_empty
			crea_albero (nome_SC)
			create stati.make (1)
			create condizioni.make (1)
			crea_stati_e_condizioni
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
				print (parser.last_error) print (" - ")
				print (parser.last_error_description) print ("%N ")
				ha_problemi_con_il_file_della_sc := TRUE
			else
				print ("Parsing OK. %N")
				ha_problemi_con_il_file_della_sc := FALSE
			end
		end

	crea_stati_e_condizioni
			--	riempie le hashtable degli stati e delle condizioni
			--	inizializza ogni stato con le sue transizioni con eventi ed azioni
		do
			if attached {XML_ELEMENT} albero.document.first as f then
				istanzia_condizioni (f.elements)
				istanzia_final (f.elements)
				istanzia_stati (f.elements, Void)
				assegna_initial (f.elements)
				assegna_conf_base_iniziale_radice (f)
				completa_stati (f.elements)
			end
		end

feature -- inizializzazione SC

	istanzia_condizioni (elements: LIST [XML_ELEMENT])
			-- istanzia nella SC le condizioni presenti in <datamodel>
		do
			across elements as e
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
										print ("ERRORE: elemento <data> con id >|" + nome.value + "<| assegna a 'expr' il valore >|" + valore.value + "<| non booleano!%N")
									end
								else
									print ("ERRORE: elemento <data> con id >|" + nome.value + "<| senza attributo 'expr'!%N")
								end
							else
								print ("ERRORE: elemento <data> senza attributo 'id'!%N")
							end
						end
					end
				end
			end
			-- aggiunge condizione_vuota che è sempre true e si applica alle transizioni che hanno condizione void (cfr `completa_stati')
			condizioni.extend (True, "condizione_vuota")
		end

	istanzia_final (elements: LIST [XML_ELEMENT])
			-- istanzia nella SC lo stato <final>
		do
			across elements as e
			loop
				if e.item.name ~ "final" and attached e.item.attribute_by_name ("id") as id then
					-- TODO: avvisare se "id" è assente
					stati.extend (create {STATO}.make_final_with_id (id.value), id.value)
				end
			end
		end

	istanzia_stati (elements: LIST [XML_ELEMENT]; p_genitore: detachable STATO)
		-- crea gli stati assegnando loro l'eventuale genitore e gli eventuali figli
		local
			stato_temp: STATO
			storia_temp: STORIA
		do
			across elements as e
			loop
				if (e.item.name ~ "state" or e.item.name ~ "parallel") then
					if not attached e.item.attribute_by_name ("id") then
						print ("ERRORE: il seguente elemento non ha 'id':%N")
						stampa_elemento (e.item)
					elseif attached e.item.attribute_by_name ("id") as id_attr then
						if id_attr.value ~ "" then
							print ("ERRORE: il seguente elemento ha un 'id' di valore stringa vuota!%N")
							stampa_elemento (e.item)
						elseif stati.has(id_attr.value) then
							print ("ERRORE: il seguente elemento ha un 'id' duplicato!%N")
							stampa_elemento (e.item)
						else
							if e.item.name ~ "state" then
								if e.item.has_element_by_name ("state") or e.item.has_element_by_name ("parallel") then
									-- elemento corrente <state> ha figli
									if attached p_genitore as pg then
										-- istanzio elemento corrente con genitore e glielo assegno come figlio
										stato_temp := create {STATO_XOR}.make_with_id_and_parent (id_attr.value, pg)
										pg.add_figlio (stato_temp)
									else -- istanzio elemento corrente senza genitore
										stato_temp := create {STATO_XOR}.make_with_id (id_attr.value)
									end
									stati.extend (stato_temp, id_attr.value)
									-- ricorsione sui figli con sé stesso come genitore
									istanzia_stati (e.item.elements, stati.item (id_attr.value))
									if attached{STATO_XOR} stato_temp as st_xor and then e.item.has_element_by_name ("history") and then attached e.item.element_by_name ("history") as his then
										if attached his.attribute_by_name ("id") as his_id then
											if attached his.attribute_by_name ("type") as tp and then tp.value ~ "deep" then
												storia_temp := create {STORIA_DEEP}.make_history_with_id (his_id.value, st_xor)
											else
												storia_temp := create {STORIA_SHALLOW}.make_history_with_id (his_id.value, st_xor)
											end
										else
											if attached his.attribute_by_name ("type") as tp and then tp.value ~ "deep" then
												storia_temp := create {STORIA_DEEP}.make_history (st_xor)
											else
												storia_temp := create {STORIA_SHALLOW}.make_history (st_xor)
											end
										end
										stato_temp.add_storia (storia_temp)
									end
								else -- elemento corrente <state> non ha figli
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
									-- ricorsione sui figli con sé stesso come genitore
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
			-- NB: regolarità di 'id' viene controllata in `istanzia_stati'
		do
			across elements as e
			loop
				debug ("SC_assegna_initial") if e.item.name ~ "state" or e.item.name ~ "parallel" then stampa_elemento(e.item) end end
				-- NB: gli stati atomici non sono né {STATO_XOR} né {STATO_AND}
				if e.item.name ~ "state" and attached e.item.attribute_by_name ("id") as id_attr then
					if attached {STATO_XOR} stati.item (id_attr.value) as stato then
						-- istanza di stato {STATO_XOR} ha certamente figli
						if attached e.item.attribute_by_name ("initial") as initial_attr then
							-- `e.item' ha attributo 'initial'
							if attached stati.item (initial_attr.value) as initial_state then
								if stato.figli.has(initial_state) then
									stato.set_initial (initial_state)
								else
									print ("ERRORE: lo stato >|" + initial_attr.value + "|< indicato come sotto-stato iniziale di default dello stato >|" + stato.id + "|< non e' figlio di questo stato!%N")
								end
							else
								print ("ERRORE: lo stato >|" + initial_attr.value + "|< indicato come sotto-stato iniziale di default dello stato >|" + stato.id + "|< non esiste!%N")
							end
						else -- `e.item' non ha attributo 'initial'
							print ("AVVISO: lo <state> >|" + stato.id + "|< non specifica attributo 'initial', si sceglie il primo figlio che sia <state> o <parallel>.%N")
							stato.set_initial (first_sub_state(e.item))
						end
						-- ricorsione sui figli
						assegna_initial (e.item.elements)
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

	assegna_conf_base_iniziale_radice (radice: XML_ELEMENT)
		-- inizializza `conf_base_iniziale' in base a stato top iniziale e poi invoca inizializzazione ricorsiva con esso
		-- NB: gli stati "top" della SC non hanno genitore
		local
			iniziale_SC: STATO
		do
			if attached radice.attribute_by_name ("initial") as initial_attr then
				if attached stati.item (initial_attr.value) as r then
					if not attached r.genitore then
						iniziale_SC := r
					else
						print ("ERRORE: lo stato >|" + initial_attr.value + "|< indicato come stato iniziale della statechart non è uno degli stati 'top'!%N")
					end
				else -- l'initial della radice non esiste
					print ("ERRORE: lo stato >|" + initial_attr.value + "|< indicato come stato iniziale della statechart non esiste!%N")
				end
			else -- la SC non specifica un sotto-stato iniziale di default si sceglie il primo
				print ("AVVISO: la SC non specifica attributo 'initial', si sceglie il primo figlio che sia <state> o <parallel>.%N")
				iniziale_SC := first_sub_state (radice)
			end
			if attached iniziale_SC as isc then
				assegna_conf_base_iniziale(isc)
			else
				print ("------- stato iniziale della SC erroneamente specificato%N")
			end
		end

	assegna_conf_base_iniziale (stato: STATO)
		-- assegna ricorsivamente gli stati a `conf_base_iniziale' a partire dallo stato gerarchico iniziale della SC
		-- NB: ogni stato gerarchico della SC ha il campo `initial' non vuoto
		do
			stato.set_attivo
			if stato.initial.is_empty then
				-- `stato' è uno stato atomico
				conf_base_iniziale.force (stato, conf_base_iniziale.count + 1)
			else -- `stato' è uno stato gerarchico e si scende in ricorsione
				across stato.initial as figli
				loop
					assegna_conf_base_iniziale (figli.item)
				end
			end
		end

	completa_stati (elements: LIST [XML_ELEMENT])
			-- assegna ricorsivamente agli stati le transizioni con eventi e azioni
		do
			across elements as e
			loop
				if (e.item.name ~ "state" or e.item.name ~ "parallel") and attached e.item.attribute_by_name ("id") as id_stato then
					-- assenza di 'id' viene controllata in `istanzia_stati'
					completa_stati (e.item.elements)
					if attached stati.item (id_stato.value) as stato then
						-- lo stato esiste perché viene creato in `stati' da `istanzia_stati'
						assegna_transizioni (stato, e.item)
					end
				end
			end
		end

feature -- supporto inizializzazione

	assegna_transizioni (stato: STATO; element: XML_ELEMENT)
		-- completa lo `stato' assegnandogli
		-- le transizioni con relativi eventi ed azioni
		-- gli altri discendenti come onentry e onexit
		local
			transizione: TRANSIZIONE
		do
			across element.elements as e
			loop
				if e.item.name ~ "transition" then
					debug ("SC_assegna_transizioni") stampa_elemento (e.item) end
					if attached e.item.attribute_by_name ("target") as t then
						if attached stati.item (t.value) as destinazione then
							if not transizione_illegale (stato, destinazione) then
								create transizione.make_with_target (destinazione, stato)
								if attached e.item.attribute_by_name ("type") as type then
									if type.value ~ "internal" and verifica_internal (transizione.sorgente, transizione.target) then
										transizione.set_internal
									end
								end
								assegna_evento (e.item, transizione)
								assegna_condizione (e.item, transizione)
								assegna_azioni (e.item.elements, transizione)
								stato.aggiungi_transizione (transizione)
							else
								print ("ERRORE: transizione non legale! ")
								print ("da >|" + stato.id + "|< a >|" + destinazione.id + "|< %N")
							end
						else
							print ("ERRORE: lo stato >|" + stato.id + "|< ha una transizione con destinazione >|" + t.value + "|< che non appartiene alla SC!%N")
						end
					else
						print ("ERRORE: lo stato >|" + stato.id + "|< ha una transizione con destinazione non specificata (manca il 'target')!%N")
					end
				end
				if e.item.name ~ "onentry" then
					istanzia_onentry (stato, e.item.elements)
				end
				if e.item.name ~ "onexit" then
					istanzia_onexit (stato, e.item.elements)
				end
			end
		end

	assegna_azioni (action_list: LIST [XML_ELEMENT]; transizione: TRANSIZIONE)
		-- assegna le azioni in `action_list' alla `transizione'
		do
			across action_list as al
			loop
				if al.item.name ~ "assign" then
					assegna_azione_assign (al.item, transizione)
				elseif al.item.name ~ "log" then
					assegna_azione_log (al.item, transizione)
				else
					print ("AVVISO: la transizione da >|" + transizione.sorgente.id + "|< a >|" + transizione.target.id + "|< specifica un'azione >|" + al.item.name + "|< sconosciuta!%N")
				end
			end
		end

	assegna_azione_assign (p_azione: XML_ELEMENT; transizione: TRANSIZIONE)
		local
			evento: STRING
		do
			if attached transizione.evento as te then
				evento := te
			else
				evento := "NULL"
			end
			if not attached p_azione.attribute_by_name ("location") as luogo then
				print ("ERRORE: l'azione <assign> nella transizione con evento >|" + evento + "|> da >|" + transizione.sorgente.id + "|< a >|" + transizione.target.id + "|< non ha attributo 'location'!%N")
			elseif not condizioni.has (luogo.value) then
				print ("ERRORE: l'azione <assign> nella transizione con evento >|" + evento + "|> da >|" + transizione.sorgente.id + "|< a >|" + transizione.target.id + "|< indica una 'location' di valore >|" + luogo.value + "|< che non esiste nelle condizioni della SC!%N")
			elseif not attached p_azione.attribute_by_name ("expr") as valore then
				print ("ERRORE: l'azione <assign> nella transizione con evento >|" + evento + "|> da >|" + transizione.sorgente.id + "|< a >|" + transizione.target.id + "|< non ha attributo 'expr'!%N")
			elseif not (valore.value ~ "false" or valore.value ~ "true") then
				print ("ERRORE: l'azione <assign> nella transizione con evento >|" + evento + "|> da >|" + transizione.sorgente.id + "|< a >|" + transizione.target.id + "|< assegna alla <location> di nome >|" + luogo.value + "|< come <expr> il valore >|" + valore.value + "|< diverso sia da 'true' che da 'false'!%N")
			else
				if valore.value ~ "false" then
					transizione.azioni.force (create {ASSEGNAZIONE}.make_with_cond_and_value (luogo.value, False), transizione.azioni.count+1)
				else
					transizione.azioni.force (create {ASSEGNAZIONE}.make_with_cond_and_value (luogo.value, True), transizione.azioni.count+1)
				end
			end
		end

	assegna_azione_log (p_azione: XML_ELEMENT; transizione: TRANSIZIONE)
		local
			evento: STRING
		do
			if attached transizione.evento as te then
				evento := te
			else
				evento := "NULL"
			end
			if attached p_azione.attribute_by_name ("name") as name then
				transizione.azioni.force (create {STAMPA}.make_with_text (name.value), transizione.azioni.count+1)
			else
				print("ERRORE: l'azione <log> nella transizione con evento >|" + evento + "|> da >|" + transizione.sorgente.id + "|< a >|" + transizione.target.id + "|< non ha attributo 'name'!%N")
			end
		end

	assegna_evento (transition: XML_ELEMENT; transizione: TRANSIZIONE)
		do
			-- TODO: capire se gestire l'assenza dell'evento con evento convenzionale "NULL" come si fa per condizione_vuota
			if attached transition.attribute_by_name ("event") as event then
				transizione.set_evento (event.value)
			end
		end

	assegna_condizione (transition: XML_ELEMENT; transizione: TRANSIZIONE)
		do
			if attached transition.attribute_by_name ("cond") as cond then
				transizione.set_condizione (cond.value)
			else
				transizione.set_condizione ("condizione_vuota")
			end
		end

	verifica_internal (sorgente, target: STATO): BOOLEAN
		do
			if attached{STATO_XOR} sorgente then
				-- secondo la specifica XML `internal' può essere eseguita solo con sorgente XOR
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
			across elements as e
			loop
				if e.item.name ~ "assign" then
					if attached e.item.attribute_by_name ("location") as luogo and attached e.item.attribute_by_name ("expr") as expr then
						if expr.value ~ "false" then
							stato.set_onentry (create {ASSEGNAZIONE}.make_with_cond_and_value (luogo.value, False))
						elseif expr.value ~ "true" then
							stato.set_onentry (create {ASSEGNAZIONE}.make_with_cond_and_value (luogo.value, True))
						end
					end
				end
				if e.item.name ~ "log" and attached e.item.attribute_by_name ("name") as name then
					if attached name.value then
						stato.set_onentry (create {STAMPA}.make_with_text (name.value))
					end
				end
			end
		end

	istanzia_onexit (stato: STATO; elements: LIST [XML_ELEMENT])
		do
			across elements as e
			loop
				if e.item.name ~ "assign" then
					if attached e.item.attribute_by_name ("location") as luogo and attached e.item.attribute_by_name ("expr") as expr then
						if expr.value ~ "false" then
							stato.set_onexit (create {ASSEGNAZIONE}.make_with_cond_and_value (luogo.value, False))
						elseif expr.value ~ "true" then
							stato.set_onexit (create {ASSEGNAZIONE}.make_with_cond_and_value (luogo.value, True))
						end
					end
				end
				if e.item.name ~ "log" and attached e.item.attribute_by_name ("name") as name then
					if attached name.value then
						stato.set_onexit (create {STAMPA}.make_with_text (name.value))
					end
				end
			end
		end

feature -- supporto generale

	first_sub_state (element: XML_ELEMENT): STATO
		local
			place_holder: INDEXABLE_ITERATION_CURSOR[XML_ELEMENT]
		do
			create Result.make_with_id ("null_state")
			across element.elements as e
			from place_holder := e.new_cursor
			until e.item.name ~ "state" or e.item.name ~ "parallel"
			loop
				place_holder := e
			end
			debug ("SC_first_sub_state")
				print("AVVISO: trovato primo figlio <state> o <parallel>%N")
				stampa_elemento (place_holder.item)
			end
			if attached place_holder.item.attribute_by_name ("id") as id_attr then
				if attached stati.item (id_attr.value) as sub_state then
					Result := sub_state
				end
			end
		end

	transizione_verticale (p_sorgente, p_destinazione: STATO): BOOLEAN
			-- ritorna vero se `p_sorgente' e `p_destinazione' sono uno antenato dell'altro
		do
			Result := p_sorgente.antenato_di (p_destinazione) or p_destinazione.antenato_di (p_sorgente)
		end

	catena_di_paralleli (basso, alto: STATO): BOOLEAN
			-- ritorna vero se dal genitore di `basso' c'è una catena continua di <parallel> fino ad `alto' che è il "mac"
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
				-- trova il più basso antenato di p_destinazione in "antenati" a partire da lui stesso
			from
				corrente := p_destinazione
			until
				corrente = Void or else antenati.has (corrente.id)
			loop
				corrente := corrente.genitore
			end
			Result := corrente
		end

	transizione_illegale (p_sorgente, p_destinazione: STATO): BOOLEAN
			-- transizione è illegale se il minimo antenato comune (mac) è <parallel> e:
			-- sorgente e destinazione sono uno antenato dell'altro e sono tutti <parallel> dal più alto al genitore del più basso
			-- mac è diverso da entrambi (attraversamento frontiera)
		local
			stato_mac, altro_stato: STATO
		do
			debug ("sc_transizione_illegale") print ("transizione da >|" + p_sorgente.id + "|< a >|" + p_destinazione.id + "|< ") end
			stato_mac := minimo_antenato_comune(p_sorgente, p_destinazione)
			if attached {STATO_AND} stato_mac then
				if transizione_verticale (p_sorgente, p_destinazione) then
					if stato_mac = p_sorgente then
						altro_stato := p_destinazione
					else
						altro_stato := p_sorgente
					end
					if catena_di_paralleli (altro_stato, stato_mac) then
						Result := True
						debug ("sc_transizione_illegale") print(" illegale: transizione con MAC <parallel> in verticale e catena di <parallel> %N") end
					end
				else -- stato_mac è diverso da entrambi
						Result := True
						debug ("sc_transizione_illegale") print(" illegale: transizione con MAC <parallel> in orizzontale tra discendenti del MAC(attraversa la frontiera)%N") end
				end
			end
		end

	stampa_elemento (element: XML_ELEMENT)
		do

			print ("%NXML_ELEMENT = " + element.name)
			if element.name ~ "transition" then
				print ("%N   con evento " +  valore_attributo(element, "event"))
				print ("%N   con condizione " +  valore_attributo(element, "cond"))
				print ("%N   con destinazione " +  valore_attributo(element, "target"))
				print ("%N")
			elseif element.has_attribute_by_name ("id") then
				print (" e id = " + valore_attributo(element, "id"))
			end
			print (" che ha come elementi figli:%N")
			across element.elements as e
			loop
				print ("  nome: " + e.item.name)
				if e.item.has_attribute_by_name ("id") then
					print (" e id = " + valore_attributo(e.item, "id"))
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
		do
			Result := valore.as_lower ~ "true" or valore.as_lower ~ "false"
		end

		-- Aggiungere 'feature' per tracciare quanto accade scrivendo su file model_out.txt:
		--la SC costruita dal programma (cioè il file model.xml letto)
		--la configurazione iniziale in termini di stato e nomi-valori delle condizioni
		--l'evoluzione della SC in termini di sequenza di quintuple:
		--stato, evento, condizione, azione, target

end
