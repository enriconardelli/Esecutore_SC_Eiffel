﻿note
	description: "La classe che rappresenta la statechart"
	author: "EN + studenti corsi PSI"
	date: "Agosto 2020"
	revision: "$Revision$"

class
	CONFIGURAZIONE

create
	make

feature -- attributi

	config_base: ARRAY [STATO]
		-- la configurazione di base della statechart, cioè i soli stati atomici della configurazione

	stati: HASH_TABLE [STATO, STRING]
		-- gli stati della statechart

	variabili: DATAMODEL
		-- le variabili del datamodel associato alla statechart

	creatore_di_assegna: ASSEGNA_CREATORE
		-- creatore parametrico delle istanze di ASSEGNA

	albero: XML_CALLBACKS_NULL_FILTER_DOCUMENT
		-- albero XML con la SC letta dal file

	errore_parsing_file_SC: BOOLEAN

	errore_costruzione_SC: LINKED_LIST [INTEGER]

	operazioni_intere: ARRAY [STRING]

	operazioni_booleane: ARRAY [STRING]

feature -- creazione

	make (nome_SC: STRING)
		local
            temp_boolean: CONDIZIONE_BOOLEANA_BINARIA
            temp_integer: CONDIZIONE_INTERA_BINARIA
        do
			create temp_boolean.make(false, "NULL","!=",false,"NULL")
			operazioni_booleane := temp_boolean.lista_operazioni
			create temp_integer.make("NULL", " ", "NULL")
			operazioni_intere := temp_integer.lista_operazioni
			create errore_costruzione_SC.make
			create config_base.make_empty
			create stati.make (1)
			create variabili.make
			create creatore_di_assegna
			crea_albero (nome_SC)
			if not errore_parsing_file_SC then
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
				errore_parsing_file_SC := True
			else
				print ("Parsing OK. %N")
				errore_parsing_file_SC := False
			end
		end

	crea_stati_e_condizioni
		--	riempie le hashtable degli stati e delle condizioni
		--	inizializza ogni stato con le sue transizioni con eventi ed azioni
		local
			radice: detachable XML_ELEMENT
		do
			radice := trova_radice(albero.document.elements)
			if attached radice as f then
				istanzia_datamodel (f.elements)
				istanzia_final (f.elements)
				across f.elements as fe loop istanzia_stato (fe.item, Void) end
				assegna_initial (f.elements)
				inizializza_config_base_radice (f)
				completa_stati (f.elements)
			end
		end

feature -- inizializzazione SC

	trova_radice(elements: LIST [XML_ELEMENT]): detachable XML_ELEMENT
		do
			across
				elements as e
			loop
				if e.item.name ~ "scxml" then
					if attached {XML_ATTRIBUTE} e.item.attribute_by_name ("xmlns") as xmlns then
						if xmlns.value ~ "http://www.w3.org/2005/07/scxml" then
							if attached {XML_ATTRIBUTE} e.item.attribute_by_name ("version") as version then
								if version.value ~ "1.0" then
										Result := e.item
								else
									print ("ERRORE 1: elemento <scxml> con attributo 'version' non corretto!%N")
									errore_costruzione_SC.extend (1)
								end
							else
								print ("ERRORE 2: elemento <scxml> senza attributo 'version'!%N")
								errore_costruzione_SC.extend (2)
							end
						else
							print ("ERRORE 3: elemento <scxml> con attributo 'xmlns' non corretto!%N")
							errore_costruzione_SC.extend (3)
						end
					else
						print ("ERRORE 4: elemento <scxml> senza attributo 'xmlns'!%N")
						errore_costruzione_SC.extend (4)
					end
				else
					print ("ERRORE 5: nessun elemento <scxml>!%N")
					errore_costruzione_SC.extend (5)
				end
			end


		end

	istanzia_datamodel (elements: LIST [XML_ELEMENT])
		-- istanzia il <datamodel>, che può essere anche suddiviso in più nodi
		do
			across
				elements as e
			loop
				if e.item.name ~ "datamodel" then
					if e.item.elements.is_empty then
						print ("AVVISO: il <datamodel> non contiene elementi <data>!%N")
					else
						istanzia_variabili (e.item.elements)
					end
				end
			end
		end

	istanzia_variabili (data_elements: LIST [XML_ELEMENT])
		-- istanzia nella SC le variabili presenti in <datamodel>
		do
			across
				data_elements as data
			loop
				if data.item.name ~ "data" then
					if attached {XML_ATTRIBUTE} data.item.attribute_by_name ("id") as nome then
						if id_illegittimo (nome.value) then
							print ("ERRORE 29: elemento <data> con 'id' >|" + nome.value + "|< di valore stringa vuota o blank o 'NULL' !%N")
							errore_costruzione_SC.extend (29)
						elseif attached {XML_ATTRIBUTE} data.item.attribute_by_name ("expr") as valore then
							assegna_variabile (pulisci_stringa (nome.value), pulisci_stringa (valore.value))
						else
							print ("ERRORE 6: elemento <data> con id >|" + nome.value + "|< senza attributo 'expr'!%N")
							errore_costruzione_SC.extend (6)
						end
					else
						print ("ERRORE 7: elemento <data> senza attributo 'id'!%N")
						errore_costruzione_SC.extend (7)
					end
				else
					print ("AVVISO: elemento in <datamodel> errato perche` del tipo <"+ data.item.name + "> e non del tipo <data>!%N")
				end
			end
			-- aggiunge variabile booleana per il valore nullo che è sempre True e si usa per le transizioni che non specificano una condizione nel file del modello
			variabili.booleane.extend (True, "NULL")
		end

	assegna_variabile (variabile, espressione: STRING)
		do
		-- assegna il valore alla singola variabile del <datamodel>
			if espressione.is_boolean then
				variabili.booleane.extend (espressione.as_lower ~ "true", variabile)
				debug ("SC_inizializza_variabili") print ("Booleano: " + variabile + " = " + variabili.booleane [variabile].out + "%N") end
			elseif espressione.is_integer then
				variabili.intere.extend (espressione.to_integer, variabile)
				debug ("SC_inizializza_variabili") print ("Intero: " + variabile + " = " + variabili.intere [variabile].out + "%N") end
			else
				print ("ERRORE 8: elemento <data> con id >|" + variabile + "|< assegna a 'expr' il valore >|" + espressione + "|< non booleano e non intero!%N")
				errore_costruzione_SC.extend (8)
			end
		end

	istanzia_final (elements: LIST [XML_ELEMENT])
		-- istanzia nella SC lo stato <final>
		do
			across
				elements as e
			loop
				if e.item.name ~ "final" then
					if attached e.item.attribute_by_name ("id") as id then
						if id_illegittimo (id.value)  then
							print ("ERRORE 9: elemento <final> con 'id' >|" + id.value + "|< di valore stringa vuota o blank o 'NULL' !%N")
							errore_costruzione_SC.extend (9)
						else
							stati.extend (create {STATO_ATOMICO}.make_final_with_id (id.value), id.value)
						end
					else
						print ("ERRORE 10: elemento <final> senza 'id'!%N")
						errore_costruzione_SC.extend (10)
					end
				end
			end
		end

	istanzia_stato (element: XML_ELEMENT; p_genitore: detachable STATO_GERARCHICO)
		-- crea gli stati assegnando loro l'eventuale genitore e gli eventuali figli
		do
			if (element.name ~ "state" or element.name ~ "parallel") then
				if not attached element.attribute_by_name ("id") then
					print ("ERRORE 11: il seguente elemento <state> o <parallel> non ha 'id':%N")
					stampa_elemento (element)
					errore_costruzione_SC.extend (11)
				elseif attached element.attribute_by_name ("id") as id_attr then
					if id_illegittimo (id_attr.value) then
						print ("ERRORE 12: il seguente elemento <state> o <parallel> ha un 'id' di valore stringa vuota o blank!%N")
						stampa_elemento (element)
						errore_costruzione_SC.extend (12)
					elseif stati.has (id_attr.value) then
						print ("ERRORE 13: il seguente elemento <state> o <parallel> ha un 'id' duplicato!%N")
						stampa_elemento (element)
						errore_costruzione_SC.extend (13)
					else
						if element.name ~ "state" then
							istanzia_stato_XOR (element, p_genitore, id_attr.value )
						end

						if element.name ~ "parallel" then
							istanzia_stato_AND (element, p_genitore, id_attr.value )
						end
					end
				end
			end

		end

	istanzia_stato_XOR (e: XML_ELEMENT; p_genitore: detachable STATO_GERARCHICO; id_attr: STRING)
		-- crea uno stati XOR assegnando l'eventuale genitore e gli eventuali figli. id_attr viene considerata del formato corretto (controllo eseguito in istanzia_stato)
		local
			stato_temp: STATO_ATOMICO
			stato_ger_temp: STATO_GERARCHICO
		do
			if e.has_element_by_name ("state") or e.has_element_by_name ("parallel") then
				-- elemento corrente <state> ha figli, quindi è gerarchico
				if attached p_genitore as pg then
					-- istanzio elemento corrente con genitore e glielo assegno come figlio
					stato_ger_temp := create {STATO_XOR}.make_with_id_and_parent (id_attr, pg)
					pg.add_figlio (stato_ger_temp)
				else -- istanzio elemento corrente senza genitore
					stato_ger_temp := create {STATO_XOR}.make_with_id (id_attr)
				end
				stati.extend (stato_ger_temp, id_attr)
				-- ricorsione sui figli con sé stesso come genitore
				across e.elements as element loop istanzia_stato (element.item, stato_ger_temp) end

			else -- elemento corrente <state> non ha figli, quindi è atomico
				if attached p_genitore as pg then
					-- istanzio elemento corrente con genitore e glielo assegno come figlio
					stato_temp := create {STATO_ATOMICO}.make_with_id_and_parent (id_attr, pg)
					pg.add_figlio (stato_temp)
				else -- istanzio elemento corrente senza genitore
					stato_temp := create {STATO_ATOMICO}.make_with_id (id_attr)
				end
				stati.extend (stato_temp, id_attr)
			end

		end

	istanzia_stato_AND (e: XML_ELEMENT; p_genitore: detachable STATO_GERARCHICO; id_attr: STRING)
		-- crea uno stati AND assegnando l'eventuale genitore e i figli. id_attr viene considerata del formato corretto (controllo eseguito in istanzia_stato)
		local
			stato_ger_temp: STATO_GERARCHICO
		do
			if e.has_element_by_name ("state") or e.has_element_by_name ("parallel") then
				-- elemento corrente <parallel> ha figli
				if attached p_genitore as pg then
					-- istanzio elemento corrente con genitore e glielo assegno come figlio
					stato_ger_temp := create {STATO_AND}.make_with_id_and_parent (id_attr, pg)
					pg.add_figlio (stato_ger_temp)
				else -- istanzio elemento corrente senza genitore
					stato_ger_temp := create {STATO_AND}.make_with_id (id_attr)
				end
				stati.extend (stato_ger_temp, id_attr)
					-- ricorsione sui figli con sé stesso come genitore
				across ordina_stati_con_priorita(e.elements) as element loop istanzia_stato (element.item, stato_ger_temp) end
			else -- elemento corrente <parallel> non ha figli
				print ("ERRORE 14: lo stato <parallel> >|" + id_attr + "|< non ha figli !%N")
				errore_costruzione_SC.extend (14)
			end
		end

	ordina_stati_con_priorita(stati_figli:LIST[XML_ELEMENT]) :LIST[XML_ELEMENT]
		local
			stati_con_priorita: ARRAY [detachable XML_ELEMENT]
			stati_senza_priorita: LINKED_LIST[XML_ELEMENT]
		do
			create {LINKED_LIST [XML_ELEMENT]} Result.make
			create stati_con_priorita.make_filled (Void, 1, 4)
			create stati_senza_priorita.make

			across
				stati_figli as s
			loop
				if attached s.item.attribute_by_name ("priority") as p then
					if not p.value.is_integer then
						print("ERRORE 37: l'attributo 'priority' di uno stato figlio di uno stato <parallel> deve avere un valore intero!%N")
						errore_costruzione_SC.extend (39)
					else
						if stati_con_priorita.valid_index(p.value.to_integer)  and then attached stati_con_priorita.at (p.value.to_integer)  then
							print("ERRORE 37: l'attributo 'priority' di uno stato figlio di uno stato <parallel> deve avere un valore intero!%N")
							errore_costruzione_SC.extend (40)
						else
							stati_con_priorita.force (s.item , p.value.to_integer)
						end
					end
				else
					stati_senza_priorita.extend (s.item)
				end
			end

			across stati_con_priorita as s loop if attached s.item as sa then Result.extend(sa)  end end
			across stati_senza_priorita as s loop Result.extend(s.item)  end
	end


	assegna_initial (elements: LIST [XML_ELEMENT])
		-- assegna ricorsivamente agli stati i loro sotto-stati iniziali di default
		-- NB: regolarità di 'id' è stata già controllata in `istanzia_stato'
		do
			across
				elements as e
			loop
				debug ("SC_assegna_initial") if e.item.name ~ "state" or e.item.name ~ "parallel" then stampa_elemento (e.item) end end
				-- NB: gli stati atomici non sono né {STATO_XOR} né {STATO_AND}
				if e.item.name ~ "state" and attached e.item.attribute_by_name ("id") as id_attr then
					if attached {STATO_XOR} stati.item (id_attr.value) as stato then
						-- istanza di stato {STATO_XOR} ha certamente figli
						if attached e.item.attribute_by_name ("initial") as initial_attr then
								-- `e.item' ha attributo 'initial'
							if attached stati.item (initial_attr.value) as initial_state then
								if stato.figli.has (initial_state) then
									stato.set_initial (initial_state)
								else
									print ("ERRORE 15: lo stato >|" + initial_attr.value + "|< indicato come sotto-stato iniziale di default dello stato >|" + stato.id + "|< non e' figlio di questo stato!%N")
									errore_costruzione_SC.extend (15)
								end
							else
								print ("ERRORE 16: lo stato >|" + initial_attr.value + "|< indicato come sotto-stato iniziale di default dello stato >|" + stato.id + "|< non esiste!%N")
								errore_costruzione_SC.extend (16)
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

	inizializza_config_base_radice (radice: XML_ELEMENT)
		-- inizializza la radice di `config_base' in base a stato top iniziale e poi invoca inizializzazione ricorsiva con esso
		-- NB: gli stati "top" della SC non hanno genitore
		local
			iniziale_SC: detachable STATO
		do
			if attached radice.attribute_by_name ("initial") as initial_attr then
				if attached stati.item (initial_attr.value) as r then
					if not attached r.genitore then
						iniziale_SC := r
					else
						print ("ERRORE 17: lo stato >|" + initial_attr.value + "|< indicato come stato iniziale della statechart non è uno degli stati 'top'!%N")
						errore_costruzione_SC.extend (17)
					end
				else -- l'initial della radice non esiste
					print ("ERRORE 18: lo stato >|" + initial_attr.value + "|< indicato come stato iniziale della statechart non esiste!%N")
					errore_costruzione_SC.extend (18)
				end
			else -- la SC non specifica un sotto-stato iniziale di default si sceglie il primo
				print ("AVVISO: la SC non specifica attributo 'initial', si sceglie il primo figlio che sia <state> o <parallel>.%N")
				iniziale_SC := first_sub_state (radice)
			end
			if attached iniziale_SC as isc then
				inizializza_config_base (isc)
			else
				print ("ERRORE 19: la SC non specifica attributo 'initial' ma non ha figli <state> o <parallel>!%N")
				errore_costruzione_SC.extend (19)
			end

		end

	inizializza_config_base (stato: STATO)
		-- assegna ricorsivamente gli stati a `config_base' a partire dallo stato gerarchico iniziale della SC
		-- NB: ogni stato gerarchico della SC ha la feature `initial' non vuota
		do
			stato.set_attivo
			if stato.initial.is_empty then
				-- `stato' è uno stato atomico
				config_base.force (stato, config_base.count + 1)
			else -- `stato' è uno stato gerarchico e si scende in ricorsione
				across
					stato.initial as figli
				loop
					inizializza_config_base (figli.item)
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
					-- assenza di 'id' viene controllata in `istanzia_stato'
					completa_stati (e.item.elements)
					if attached stati.item (id_stato.value) as stato then
						-- lo stato esiste perché viene creato in `stati' da `istanzia_stato'
						assegna_figli (stato, e.item)
					end
				end
			end
		end

	assegna_figli (stato: STATO; element: XML_ELEMENT)
		-- completa lo `stato' con i suoi figli che non sono <state> o <parallel>: transizioni, azioni onentry/onexit, history
		local
			transizioni : LINKED_LIST [XML_ELEMENT]
			history_trovata: BOOLEAN
		do
			history_trovata := False
			create transizioni.make

			across
				element.elements as e
			loop
				if e.item.name ~ "transition" then
					transizioni.extend (e.item)
				elseif e.item.name ~ "onentry" then
					assegna_onentry (e.item.elements, stato)
				elseif e.item.name ~ "onexit" then
					assegna_onexit (e.item.elements, stato)
				elseif e.item.name ~ "history" then
					-- verifica unicità di <history>
					if history_trovata then
						print("AVVISO: ci sono 2 o più elementi <history>. Vengono ignorati quelli successivi al primo!%N")
					else
						assegna_storia (e.item, stato)
						history_trovata:= True
					end
				elseif not (e.item.name ~ "state" or e.item.name ~ "parallel") then
					print ("ERRORE 20: lo stato >|" + stato.id + "|< specifica un figlio non ammissibile!%N")
					stampa_elemento (e.item)
					errore_costruzione_SC.extend (20)
				end
			end
			assegna_transizioni_con_priorita (transizioni,stato)

		end

feature -- inizializzazione storia

	assegna_storia (history_element: XML_ELEMENT; stato: STATO)
		-- assegna a `stato' la storia specificata in `history_element'
		local
			storia_temp: STORIA
		do
			if attached {STATO_XOR} stato as st_xor then
				-- se uno stato composto ha più di una storia viene salvata solo la prima
				if attached history_element.attribute_by_name ("type") as h_tp and then h_tp.value ~ "deep" then
					storia_temp := create {STORIA_DEEP}.make_history
				else
					if not (attached history_element.attribute_by_name ("type") as h_tp and then h_tp.value ~ "shallow") then
						print ("AVVISO: la storia dello stato >|" + stato.id  + "|< viene considerata shallow!%N")
					end
					storia_temp := create {STORIA_SHALLOW}.make_history
				end
				stato.add_storia (storia_temp)
			end
			-- TODO: il test seguente va anticipato in assegna_figli
			if attached {STATO_AND} stato as st_and then
				print ("AVVISO: " + st_and.id + " è uno stato parallelo, pertanto la sua storia non verrà considerata!%N")
			end
		end


feature -- inizializzazione transizioni

	assegna_transizioni_con_priorita (transizioni: LINKED_LIST[XML_ELEMENT]; sorgente: STATO)
		-- Assegna a `sorgente' le transizioni tenendo conto della priorità esplicita impostata dall'utente.
		-- Le transizione senza priorità esplicita vengono considerate avere la priorità più bassa
		local
			transizioni_con_priorita: ARRAY [detachable XML_ELEMENT]
			transizioni_senza_priorita: LINKED_LIST[XML_ELEMENT]

		do
			create transizioni_con_priorita.make_filled (Void, 1, 4)
			create transizioni_senza_priorita.make

			across
				transizioni as t
			loop
				if attached t.item.attribute_by_name ("priority") as p then
					if not p.value.is_integer then
						print("ERRORE 37: l'attributo 'priority' di una transizione dello stato " + sorgente.id +" deve avere un valore intero!%N")
						errore_costruzione_SC.extend (37)
					else
						if transizioni_con_priorita.valid_index(p.value.to_integer)  and then attached transizioni_con_priorita.at (p.value.to_integer)  then
							print("ERRORE 37: l'attributo 'priority' di una transizione dello stato " + sorgente.id +" non può essere un valore duplicato!%N")
							errore_costruzione_SC.extend (38)
						else
							transizioni_con_priorita.force (t.item , p.value.to_integer)
						end
					end
				else
					transizioni_senza_priorita.extend (t.item)
				end
			end

			across transizioni_con_priorita as t loop if attached t.item as ta then assegna_transizione (ta,sorgente)  end end
			across transizioni_senza_priorita as t loop assegna_transizione (t.item,sorgente)  end

		end

	assegna_transizione (transition_element: XML_ELEMENT; sorgente: STATO)
		-- assegna a `sorgente' la transizione specificata in `transition_element' tenendo conto del tipo di transizione
		local
			destinazioni: LINKED_LIST [STATO]
			altre_sorgenti: LINKED_LIST [STATO]
		do
			debug ("SC_assegna_transizioni") stampa_elemento (transition_element) end
			if attached transition_element.attribute_by_name ("target") as t then
				destinazioni := get_stati (get_nomi (t.value))
				inspect destinazioni.count
				when 0 then
					print ("ERRORE 21: lo stato >|" + sorgente.id + "|< ha una transizione con destinazione errata: 'target' non contiene id di stati della SC!%N")
					errore_costruzione_SC.extend (21)
				when 1 then
					if attached transition_element.attribute_by_name ("source") as s then
						altre_sorgenti := get_stati (get_nomi (s.value))
						if altre_sorgenti.count = 0 then
							print ("AVVISO: lo stato >|" + sorgente.id + "|< ha una transizione in cui 'source' non contiene id di stati della SC!%N")
							assegna_transizione_singola(transition_element, destinazioni.first, sorgente)
						else
							assegna_transizione_merge(transition_element, destinazioni.first, sorgente, altre_sorgenti)
						end
					else
						assegna_transizione_singola(transition_element, destinazioni.first, sorgente)
					end
				else
					if attached transition_element.attribute_by_name ("source") as s then
						-- TODO: in realtà è possibile avere transizioni contemporaneamente fork e merge ma al momento non vengono gestite
						print ("ERRORE 22: non posso avere contemporaneamente transizioni fork e merge!%N")
						errore_costruzione_SC.extend (22)
					else
						assegna_transizione_fork(transition_element, destinazioni, sorgente)
					end
				end
			else
				print ("ERRORE 23: lo stato >|" + sorgente.id + "|< ha una transizione con destinazione non specificata (manca il 'target')!%N")
				errore_costruzione_SC.extend (23)
			end
		end

	get_nomi (una_stringa: STRING): LINKED_LIST [STRING]
		-- ritorna i possibili nomi di stato, individuati come stringhe separate da uno o più spazi
		local
			lista: LIST [STRING]
		do
			create Result.make
			lista := una_stringa.split(' ')
			-- NB: per una stringa con un solo spazio .split ritorna una lista con due stringhe vuote ("")
			across lista as l
				loop
					if not l.item.is_equal("") then
						Result.extend(l.item)
					end
				end
		end

	get_stati (lista_id: LINKED_LIST [STRING]): LINKED_LIST [STATO]
		-- ritorna una lista di stati corrispondenti agli identificatori in `lista_id'
		do
			create Result.make
			across lista_id as l
				loop
					if attached stati.item (l.item) as s then
						Result.extend(s)
					else
						print("AVVISO: lo stato >|" + l.item + "|< non appartiene alla SC e viene scartato!%N")
					end
				end
		end

	assegna_transizione_merge(transition_element: XML_ELEMENT; destinazione, sorgente: STATO; altre_sorgenti: LINKED_LIST [STATO])
		local
			transizione: TRANSIZIONE
			tutte_le_sorgenti: LINKED_LIST [STATO]
		do
			create tutte_le_sorgenti.make
			tutte_le_sorgenti.copy (altre_sorgenti)
			tutte_le_sorgenti.extend (sorgente)
			if ancore_multiple_compatibili (tutte_le_sorgenti) then
				create transizione.make_con_destinazione (destinazione, sorgente)
				transizione.set_merge
				transizione.add_sorgenti (altre_sorgenti)
				completa_transizione (transition_element, transizione)
				across tutte_le_sorgenti as s loop s.item.aggiungi_transizione (transizione) end
				debug ("sc_transizioni_legali")
					print (" - Transizione legale da >| ")
					across tutte_le_sorgenti as s loop print(s.item.id + " ") end
					print ( "|< a >|" + destinazione.id + "|< %N")
				end
			else
				print ("ERRORE 24: Le sorgenti multiple indicate per la transizione che parte dallo stato >| " + sorgente.id + " |< non sono tra loro compatibili %N")
				stampa_ancore_multiple (tutte_le_sorgenti)
				errore_costruzione_SC.extend (24)
			end
		end

	assegna_transizione_singola (transition_element: XML_ELEMENT; destinazione, sorgente: STATO)
		-- assegna a `sorgente' la transizione specificata in `transition_element' che porta a `destinazione'
		local
			transizione: TRANSIZIONE
		do
			if transizione_illegale (sorgente, destinazione) then
				print ("ERRORE 25: transizione illegale da >|" + sorgente.id + "|< a >| " + destinazione.id + " |< !%N")
				errore_costruzione_SC.extend (25)
			else
				create transizione.make_con_destinazione (destinazione, sorgente)
				if attached transition_element.attribute_by_name ("type") as type then
					if type.value ~ "internal" and interna_legale (transizione) then
						transizione.set_interna
					end
				end
				completa_transizione (transition_element, transizione)
				sorgente.aggiungi_transizione (transizione)
				debug ("sc_transizioni_legali") print (" - Transizione legale da >| " + sorgente.id + " |< a >| " + destinazione.id + " |< %N") end
			end
		end

	assegna_transizione_fork(transition_element: XML_ELEMENT; destinazioni: LINKED_LIST [STATO]; sorgente: STATO)
		local
			transizione: TRANSIZIONE
		do
			if ancore_multiple_compatibili(destinazioni) then
				create transizione.make_con_destinazione (destinazioni.first, sorgente)
				transizione.set_fork
				transizione.add_destinazioni (destinazioni)
				completa_transizione (transition_element, transizione)
				sorgente.aggiungi_transizione (transizione)
				debug ("sc_transizioni_legali")
					print (" - Transizione legale da >| " + sorgente.id + " |< a >| ")
					across destinazioni as d loop print( d.item.id + " ") end
					print("|< %N")
				end
			else
				print ("ERRORE 26: Le destinazioni multiple indicate per la transizione che parte dallo stato >|" + sorgente.id + "|< non sono tra loro compatibili!%N")
				stampa_ancore_multiple (destinazioni)
				errore_costruzione_SC.extend (26)
			end
		end

	completa_transizione (transition_element: XML_ELEMENT; transizione: TRANSIZIONE)
		--	assegna evento, condizione e azioni alla transizione e la aggiunge a `stato'
	do
		assegna_evento (transition_element, transizione)
		assegna_condizione (transition_element, transizione)
		assegna_azioni (transition_element.elements, transizione)
	end

	ancore_multiple_compatibili(lista_stati: LINKED_LIST [STATO]): BOOLEAN
		-- ritorna True se gli stati in `lista_stati' sono compatibili come
		-- sorgenti multiple di una transizione merge o destinazioni multiple di una transizione fork:
		-- a due a due devono avere un minimo antenato comune di tipo AND
		-- e non devono essere l'uno discendente dell'altro.
	do
		Result := True
		across lista_stati as s1 loop
			across lista_stati as s2 loop
				if not s1.item.id.is_equal (s2.item.id) then
					if transizione_verticale (s1.item, s2.item) or not attached {STATO_AND} minimo_antenato_comune(s1.item, s2.item) then
						Result := False
					end
				end
			end
		end
	end

	configurazione_contiene(stato: READABLE_STRING_32 ):BOOLEAN
	-- Controlla se lo lo `stato' fa parte della configurazione
		local
			corrente: STATO
		do
			across config_base as c
			loop
				if c.item.id.is_equal(stato) then
					Result := True
				else
					from
						corrente := c.item.genitore
					until
						corrente = Void
					loop
						if corrente.id.is_equal(stato) then
							Result := True
						end
						corrente := corrente.genitore
					end
				end
			end
		end

	transizione_illegale (p_sorgente, p_destinazione: STATO): BOOLEAN
			-- transizione è illegale se il minimo antenato comune (MAC) è <parallel> e inoltre:
			--   sorgente e destinazione sono uno antenato dell'altro e sono tutti <parallel> dal più alto al genitore del più basso,
			--   oppure se MAC è diverso da entrambi (attraversamento frontiera)
		local
			stato_mac, altro_stato: STATO
		do
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
						debug ("sc_transizioni_illegali") print ("transizione illegale: transizione con MAC <parallel> in verticale e catena di <parallel> %N") end
					end
				else -- stato_mac è diverso da entrambi
					Result := True
 					debug ("sc_transizioni_illegali") print ("transizione illegale: transizione con MAC <parallel> in orizzontale tra discendenti del MAC (attraversa la frontiera)%N") end
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

	interna_legale (transizione: TRANSIZIONE): BOOLEAN
		do
			if (attached {STATO_XOR} transizione.sorgente.first as ts and then ts.antenato_di (transizione.destinazione.first)) or else (transizione.destinazione.first.antenato_di (transizione.sorgente.first)) or else (transizione.destinazione.first = transizione.sorgente.first) then
--			if (transizione.sorgente.first.antenato_di (transizione.destinazione.first)) or else (transizione.destinazione.first.antenato_di (transizione.sorgente.first)) or else (transizione.destinazione.first = transizione.sorgente) then
				Result := true
			end
		end

	assegna_evento (transition: XML_ELEMENT; transizione: TRANSIZIONE)
		do
			-- TODO: capire se gestire l'assenza dell'evento con evento convenzionale "NULL" come si fa per le condizioni
			if attached transition.attribute_by_name ("event") as event then
				transizione.set_evento (event.value)
			end
		end

	assegna_condizione (transition: XML_ELEMENT; transizione: TRANSIZIONE)
		local
			condizione: CONDIZIONE
			condizione_vuota: CONDIZIONE_VUOTA
		do
			create condizione_vuota.make
			transizione.set_condizione (condizione_vuota)
			if attached transition.attribute_by_name ("cond") as cond then
				condizione := condizione_legittima (cond.value)
				if condizione /= Void then
                	if attached {CONDIZIONE_BOOLEANA_UNARIA} condizione as cbu then
                		transizione.set_condizione(cbu)
                	end
                	if attached {CONDIZIONE_BOOLEANA_BINARIA} condizione as cbb then
                		transizione.set_condizione(cbb)
                	end
                	if attached {CONDIZIONE_INTERA_UNARIA} condizione as ciu then
                		transizione.set_condizione(ciu)
                	end
                	if attached {CONDIZIONE_INTERA_BINARIA} condizione as cib then
                		transizione.set_condizione(cib)
                	end
				else
					print ("ERRORE 27: la transizione da >|" + transizione.sorgente.first.id + "|< a >|" + transizione.destinazione.first.id + "|< specifica una condizione di valore (non pulito) >|" + cond.value + "|< illegittimo !%N")
					errore_costruzione_SC.extend (27)
				end
			end
		end

	condizione_legittima (stringa: STRING): detachable CONDIZIONE
		do
			Result := booleana_legittima (stringa)
			if Result = Void then
				Result := intera_legittima (stringa)
			end
		end

	booleana_legittima (stringa: STRING): detachable CONDIZIONE_BOOLEANA
    	local
            op: STRING
            variabile, variabile2: TUPLE [negata: BOOLEAN; var: STRING; valida: BOOLEAN]
            pos: INTEGER
            has_operator:BOOLEAN
        do
        	-- restituisce VOID o un'istanza di CONDIZIONE_BOOLEANA_BINARIA o di CONDIZIONE_BOOLEANA_UNARIA
        	has_operator := False
        	across operazioni_booleane as op_cursor loop
            op := op_cursor.item
                if stringa.has_substring (op) then
                    has_operator := True
                    pos := stringa.substring_index (op, 1)
                    if pos > 1 and pos + op.count <= stringa.count then
                    	variabile := booleana_variabile_legittima(stringa.substring (1, pos - 1), variabili.booleane)
                    	variabile2 := booleana_variabile_legittima(stringa.substring (pos + op.count, stringa.count), variabili.booleane)
                        if variabile.valida and variabile2.valida then
                        	create {CONDIZIONE_BOOLEANA_BINARIA}Result.make(variabile.negata, pulisci_stringa(variabile.var), op, variabile2.negata, pulisci_stringa(variabile2.var))
                        end
                    end
                end
            end
			variabile:= booleana_variabile_legittima(stringa, variabili.booleane)
            if not has_operator and variabile.valida then
            	create {CONDIZIONE_BOOLEANA_UNARIA}Result.make(variabile.negata, variabile.var)
            end
		end

booleana_variabile_legittima (string: STRING; variabili_booleane: HASH_TABLE [BOOLEAN, STRING]): TUPLE [negata: BOOLEAN; variabile: STRING; valida: BOOLEAN]
    local
        parts: LIST [STRING]
        part1, part2: STRING
    do
    	Result := [False, "NULL", False]
        parts := string.split (' ')
        part1 := parts.first
       -- Caso Variabile
        if parts.count = 1 and then variabili_booleane.has (part1) then
            Result := [False, part1, True]
        -- Caso Not Variabile
        elseif parts.count = 2 then
        	part2 := parts.i_th (2)  -- Seconda parola
           	if part1.is_equal ("not") and then variabili_booleane.has (part2) then
          		Result := [True, part2, True]
            end
        end
    end

	intera_legittima  (stringa: STRING): detachable CONDIZIONE_INTERA
        local
            op, variabile, variabile2: STRING
            pos: INTEGER
        do
        	-- restituisce VOID o un'istanza di CONDIZIONE_INTERA_BINARIA o di CONDIZIONE_INTERA_UNARIA
        	across operazioni_intere as op_cursor loop
            op := op_cursor.item
                if stringa.has_substring (op) then
                    pos := stringa.substring_index (op, 1)
                    if pos > 1 and pos + op.count <= stringa.count then
                        variabile := pulisci_stringa(stringa.substring (1, pos - 1))
                        variabile2 := pulisci_stringa(stringa.substring (pos + op.count, stringa.count))
                        if variabili.intere.has (variabile) then
                      		if variabile2.is_integer then
                            	create {CONDIZIONE_INTERA_UNARIA}Result.make(variabile, op, variabile2.to_integer)
                        	elseif variabili.intere.has (variabile2) then
                        		create {CONDIZIONE_INTERA_BINARIA}Result.make(variabile, op, variabile2)
                        	end
                        end
                    end
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
					-- TODO: stampare tutti gli stati sorgente e destinazione della transizione
					print ("ERRORE 30: la transizione dalla prima sorgente >|" + transizione.sorgente.first.id + "|< alla prima destinazione >|" + transizione.destinazione.first.id + "|< specifica un'azione >|" + al.item.name + "|< sconosciuta!%N")
					errore_costruzione_SC.extend (30)
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
				-- TODO: stampare tutti gli stati sorgente e destinazione della transizione
				testo := "nella transizione con evento >|" + nome_evento(transizione) + "|< dalla prima sorgente >|" + transizione.sorgente.first.id + "|< alla prima destinazione >|" + transizione.destinazione.first.id + "|<"

				if esito ~ "senza_luogo" then
					print ("ERRORE 31: l'azione <assign> " + testo + " non ha attributo 'location'!%N")
					errore_costruzione_SC.extend (31)
				elseif esito ~ "luogo_assente" then
					print ("ERRORE 32: l'azione <assign> " + testo + " specifica la 'location' >|" + variabile + "|< che non esiste nel <datamodel> della SC!%N")
					errore_costruzione_SC.extend (32)
				elseif esito ~ "senza_valore" then
					print ("ERRORE 33: l'azione <assign> " + testo + " non ha attributo 'expr'!%N")
					errore_costruzione_SC.extend (33)
				elseif esito ~ "valore_errato" then
					print ("ERRORE 34: l'azione <assign> " + testo + " assegna alla <location> >|" + variabile + "|< come <expr> il valore >|" + espressione + "|< non ammissibile!%N")
					errore_costruzione_SC.extend (34)
				elseif esito ~ "variabile_intera_con_espressione_booleana" or esito ~ "variabile_booleana_con_espressione_intera" then
					print ("ERRORE 35: l'azione <assign> " + testo + " assegna alla <location> >|" + variabile + "|< come <expr> il valore >|" + espressione + "|< non ammissibile!%N")
					errore_costruzione_SC.extend (35)
				end
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
				-- TODO: stampare tutti gli stati sorgente e destinazione della transizione
				print ("ERRORE 36: l'azione <log> nella transizione con evento >|" + nome_evento(transizione) + "|< dalla prima sorgente >|" + transizione.sorgente.first.id + "|< alla prima destinazione >|" + transizione.destinazione.first.id + "|< non ha attributo 'name'!%N")
				errore_costruzione_SC.extend (36)
			end
		end

feature -- inizializzazione onentry/onexit

	assegna_onentry (action_list: LIST [XML_ELEMENT]; stato: STATO)
			-- assegna a 'stato' come onentry le azioni in `action_list'
		do
			across
				action_list as al
			loop
				if al.item.name ~ "assign" then
					assegna_onentry_assign (al.item, stato)
				elseif al.item.name ~ "log" then
					assegna_onentry_log (al.item, stato)
				else
					print ("ERRORE 30: l'azione >|" + al.item.name + "|< specificata in <onentry> per lo stato >|" + stato.id + "|< non e' ammissibile!%N")
					errore_costruzione_SC.extend (30)
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
					print ("ERRORE 30: l'azione >|" + al.item.name + "|< specificata in <onexit> per lo stato >|" + stato.id + "|< non e' ammissibile!%N")
					errore_costruzione_SC.extend (30)
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

				if esito ~ "senza_luogo" then
					print ("ERRORE 31: l'azione <assign> " + testo + " non ha attributo 'location'!%N")
					errore_costruzione_SC.extend (31)
				elseif esito ~ "luogo_assente" then
					print ("ERRORE 32: l'azione <assign> " + testo + " specifica la 'location' >|" + variabile + "|< che non esiste nel <datamodel> della SC!%N")
					errore_costruzione_SC.extend (32)
				elseif esito ~ "senza_valore" then
					print ("ERRORE 33: l'azione <assign> " + testo + " non ha attributo 'expr'!%N")
					errore_costruzione_SC.extend (33)
				elseif esito ~ "valore_errato" then
					print ("ERRORE 34: l'azione <assign> " + testo + " assegna alla <location> >|" + variabile + "|< come <expr> il valore >|" + espressione + "|< non ammissibile!%N")
					errore_costruzione_SC.extend (34)
				elseif esito ~ "variabile_intera_con_espressione_booleana" or esito ~ "variabile_booleana_con_espressione_intera" then
					print ("ERRORE 35: l'azione <assign> " + testo + " assegna alla <location> >|" + variabile + "|< come <expr> il valore >|" + espressione + "|< non ammissibile!%N")
					errore_costruzione_SC.extend (35)
				end
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

				if esito ~ "senza_luogo" then
					print ("ERRORE 31: l'azione <assign> " + testo + " non ha attributo 'location'!%N")
					errore_costruzione_SC.extend (31)
				elseif esito ~ "luogo_assente" then
					print ("ERRORE 32: l'azione <assign> " + testo + " specifica la 'location' >|" + variabile + "|< che non esiste nel <datamodel> della SC!%N")
					errore_costruzione_SC.extend (32)
				elseif esito ~ "senza_valore" then
					print ("ERRORE 33: l'azione <assign> " + testo + " non ha attributo 'expr'!%N")
					errore_costruzione_SC.extend (33)
				elseif esito ~ "valore_errato" then
					print ("ERRORE 34: l'azione <assign> " + testo + " assegna alla <location> >|" + variabile + "|< come <expr> il valore >|" + espressione + "|< non ammissibile!%N")
					errore_costruzione_SC.extend (34)
				elseif esito ~ "variabile_intera_con_espressione_booleana" or esito ~ "variabile_booleana_con_espressione_intera" then
					print ("ERRORE 35: l'azione <assign> " + testo + " assegna alla <location> >|" + variabile + "|< come <expr> il valore >|" + espressione + "|< non ammissibile!%N")
					errore_costruzione_SC.extend (35)
				end
			end
		end

	assegna_onentry_log (p_azione: XML_ELEMENT; stato: STATO)
		do
			if attached p_azione.attribute_by_name ("name") as name then
				stato.set_onentry (create {STAMPA}.make_with_text (name.value))
			else
				print ("ERRORE 36: l'azione <log> specificata in <onentry> per lo stato >|" + stato.id + "|< non ha attributo 'name'!%N")
				errore_costruzione_SC.extend (36)
			end
		end

	assegna_onexit_log (p_azione: XML_ELEMENT; stato: STATO)
		do
			if attached p_azione.attribute_by_name ("name") as name then
				stato.set_onexit (create {STAMPA}.make_with_text (name.value))
			else
				print ("ERRORE 36: l'azione <log> specificata in <onexit> per lo stato >|" + stato.id + "|< non ha attributo 'name'!%N")
				errore_costruzione_SC.extend (36)
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
			valore_nullo: STRING
		do
			valore_nullo := "NULL"
			if stringa ~ "" or stringa.is_whitespace or stringa.as_lower ~ valore_nullo.as_lower or pulisci_stringa(stringa).has (' ') then
				-- il Valore_Nullo non può essere specificato nel model ma solo assegnato nella costruzione della SC
				Result := True
			else
				Result := False
			end
		end

	first_sub_state (element: XML_ELEMENT): detachable STATO
	-- torna il primo elemento <state> o <parallel> figlio di `element' nella specifica XML letta, se esiste
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
				print ("ERRORE 28: non esistono <state> o <parallel> nel modello!%N")
				errore_costruzione_SC.extend (28)
			else
				debug ("SC_first_sub_state") print ("AVVISO: trovato primo figlio <state> o <parallel>%N"); stampa_elemento (place_holder.item) end
				-- NB: regolarità di 'id' è stata già controllata in `istanzia_stato'
				if attached place_holder.item.attribute_by_name ("id") as id_attr then
					if attached stati.item (id_attr.value) as sub_state then
						Result := sub_state
					end
				end
			end

		end

	stampa_ancore_multiple (ancore: LINKED_LIST[STATO])
		do
			across ancore as a
			loop
				print ("  >|" + a.item.id + "|<  ")
			end
			print ("%N")
		end

	stampa_elemento (element: XML_ELEMENT)
		do
			print ("%NXML_ELEMENT = " + element.name)
			if element.name ~ "transition" then
				print ("%N   con evento " + valore_attributo (element, "event"))
				print ("%N   con condizione " + valore_attributo (element, "cond"))
				-- non va modificato perché stampa tutto il valore dell'attributo "target"
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



		-- Aggiungere 'feature' per tracciare quanto accade scrivendo su file model_out.txt:
		--  l'evoluzione della SC in termini di sequenza di quintuple:
		--  n_passo: configurazione_base, eventi, variabili (nomi e valori iniziali), azioni da eseguire

end
