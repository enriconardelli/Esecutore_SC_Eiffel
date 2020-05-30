note
	description: "Clase che rappresenta lo stato della state chart"
	author: "Gabriele Cacchioni & Davide Canalis "
	date: "9-04-2015"
	revision: "0.1"

class
	STATO

create
	make_with_id, make_final_with_id, make_with_id_and_parent

feature -- attributi

	transizioni: ARRAY [TRANSIZIONE]

	finale: BOOLEAN

	attivo: BOOLEAN
		-- indipendentemente se sia uno stato atomico o meno

	stato_default: ARRAY[STATO]

	genitore: detachable STATO

	stati_figli: ARRAY [STATO]

	id: STRING

	onEntry: ARRAY[AZIONE]

	onExit: ARRAY[AZIONE]

feature --creazione

	make_with_id (un_id: STRING)
		require
			non_e_una_stringa_vuota: un_id /= Void
		do
			id := un_id
			finale := False
			create stato_default.make_empty
			create stati_figli.make_empty
			create transizioni.make_empty
			create onEntry.make_empty
			create onExit.make_empty
		ensure
			attributo_assegnato: id = un_id
		end

	make_final_with_id (un_id: STRING)
		require
			non_e_una_stringa_vuota: un_id /= Void
		do
			make_with_id (un_id)
			set_final
		ensure
			attributo_assegnato: id = un_id
		end

	make_with_id_and_parent (un_id: STRING; p_genitore: STATO)
		require
			non_e_una_stringa_vuota: un_id /= Void
			genitore_esistente: p_genitore /= Void
		do
			make_with_id (un_id)
			set_genitore(p_genitore)
		ensure
			attributo_assegnato: id = un_id
		end

feature -- setter

	set_attivo
		do
			attivo := True
		end

	set_inattivo
		do
			attivo := False
		end

	set_final
		do
			finale := TRUE
		ensure
			ora_e_finale: finale
		end

	set_onEntry (una_azione: AZIONE)
		require
			e_una_azione: una_azione /= VOID
		do
			onEntry.force(una_azione, onEntry.count+1)
		ensure
			azione_assegnata: onEntry[onEntry.count] = una_azione
		end

	set_onExit (una_azione: AZIONE)
		require
			e_una_azione: una_azione /= VOID
		do
			onExit.force (una_azione,onExit.count+1)
		ensure
			azione_assegnata: onExit[onExit.count] = una_azione
		end

	set_genitore (p_genitore: STATO)
		require
			genitore_esistente: p_genitore /= Void
		do
			genitore := p_genitore
		ensure
			genitore_acquisito: genitore = p_genitore
		end

feature -- stato
	stato_atomico: BOOLEAN
		-- ritorna vero se lo stato è uno stato atomico
		do
			Result := stati_figli.is_empty
		end

feature -- modifica

	aggiungi_transizione (tr: TRANSIZIONE)
		do
			transizioni.force (tr, transizioni.count + 1)
		end

feature -- situazione

	transizione_abilitata (eventi_correnti: LINKED_SET [STRING]; condizioni: HASH_TABLE [BOOLEAN, STRING]): detachable TRANSIZIONE
		local
			index_count: INTEGER
			transizione_corrente: detachable TRANSIZIONE
			evento_abilitato: BOOLEAN
			condizione_abilitata: BOOLEAN
		do
			from
				index_count := transizioni.lower
			invariant
				index_count >= 1
				index_count <= transizioni.count + 1
			until
				index_count = transizioni.upper + 1 or Result /= Void
			loop
				transizione_corrente := transizioni [index_count]
				evento_abilitato := transizione_corrente.check_evento (eventi_correnti)
				condizione_abilitata := transizione_corrente.check_condizione (condizioni)
				if evento_abilitato and condizione_abilitata then
					Result := transizioni [index_count]
				end
				index_count := index_count + 1
			end
			if Result = Void then
				if attached genitore as sg then
					Result := sg.transizione_abilitata (eventi_correnti, condizioni)
				end
			end
		end

	antenato_di (uno_stato: STATO): BOOLEAN
		-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
		-- controlla se il Current è antenato "proprio" di `uno_stato'
		do
			if attached uno_stato.genitore as sg then
				if sg = Current then
					Result := true
				else
					Result := antenato_di (sg)
				end
			else -- `uno_stato' non ha antenati
				Result := false
			end
		end

	incomparabile_con(uno_stato: STATO): BOOLEAN
	-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
		do
			if Current /= uno_stato and not antenato_di(uno_stato) and not uno_stato.antenato_di(Current) then
				Result := true
			end
		end

feature -- routines forse inutili

	numero_transizioni_abilitate (evento_corrente: STRING; hash_delle_condizioni: HASH_TABLE [BOOLEAN, STRING]): INTEGER
			-- ritorna il numero di transizioni attivabili con evento_corrente nella configurazione corrente
			-- usata solo nei test
		do
			across transizioni as t
			loop
				if attivabile (t.item, evento_corrente, hash_delle_condizioni) then
					Result := Result + 1
				end
			end
		end

	attivabile (una_transizione: TRANSIZIONE; evento_corrente: STRING; hash_delle_condizioni: HASH_TABLE [BOOLEAN, STRING]): BOOLEAN
		-- verifica, in caso `una_transizione' che ha un evento se è uguale a `evento_corrente' e se la condizione e' vera
		-- verifica, in caso `una_transizione' senza evento se la condizione e' vera
		-- Giulia Iezzi, Alessando Filippo 12/apr/2020; EN 21/apr/2020
		-- TODO completare test per questa feature
		-- usata solo nei test
		do
			if attached una_transizione.evento as e then
				if e.is_equal (evento_corrente) then
					if attached una_transizione.condizione as c then
						if hash_delle_condizioni.item (c) = True then
							Result := True
						end
					else
						Result := True
					end
				end
			else
				if attached una_transizione.condizione as cond then
						if hash_delle_condizioni.item (cond) = True then
							Result := True
						end
				end
			end
		end

	target (evento_corrente: STRING; hash_delle_condizioni: HASH_TABLE [BOOLEAN, STRING]): detachable STATO
		-- ritorna Current se con `evento_corrente' nella configurazione corrente non è attivabile alcuna transizione
		-- ritorna lo stato a cui porta la transizione di indice minimo attivabile nella configurazione corrente con `evento_corrente'
		-- Giulia Iezzi, Alessando Filippo 12/apr/2020; EN 21/apr/2020
		-- non viene mai chiamata
		do
			across transizioni as t
			loop
	        	if attivabile(t.item, evento_corrente, hash_delle_condizioni) then
		        	Result := t.item.target
		        end
			end
			if Result = Void then
				Result := Current
			end
		end

	get_transition (evento_corrente: STRING): TRANSIZIONE
		-- ritorna la transizione abilitata con `evento_corrente'
		-- non viene mai invocata
		local
			index_count: INTEGER
			index: INTEGER
		do
			from
				index_count := transizioni.lower
			until
				index_count = transizioni.upper + 1
			loop
				if attached transizioni [index_count].evento as te then
					if te.is_equal (evento_corrente) then
						index := index_count
					end
				end
				index_count := index_count + 1
			end
			Result := transizioni [index]
		end

end
