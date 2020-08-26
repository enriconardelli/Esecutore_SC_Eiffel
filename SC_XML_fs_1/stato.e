note
	description: "Classe che rappresenta lo stato della state chart"
	author: "EN + studenti corsi PSI"
	date: ""
	revision: ""

-- TODO: classe da ristrutturare trasformandola in deferred con due sotto-classi per stati atomici e gerarchici,
-- STATO_ATOMICO è effective, mentre STATO_GERARCHICO è anch'essa deferred
-- ed ha come sotto-classi effective STATO_XOR e STATO_AND
-- spostare feature figli, add_Figlio, make_with_parent in STATO_GERARCHICO

class
	STATO

create
	make_with_id, make_final_with_id, make_with_id_and_parent

feature -- attributi

	transizioni: ARRAY [TRANSIZIONE]
		-- le transizioni che escono dallo stato corrente

	finale: BOOLEAN

	attivo: BOOLEAN
		-- indipendentemente se sia uno stato atomico o meno

	initial: ARRAY [STATO]
		-- il figlio iniziale di default (tutti i figli nel caso di STATO_AND)

	genitore: detachable STATO
		-- l'eventuale genitore dello stato corrente

	figli: ARRAY [STATO]
		-- gli stati figli dello stato corrente

	id: STRING

	onEntry: ARRAY [AZIONE]
		-- le azioni eseguite all'ingresso nello stato (reazioni statiche entering [ns] di Harel)

	onExit: ARRAY [AZIONE]
		-- le azioni eseguite all'uscita dallo stato (reazioni statiche exiting [xs] di Harel)

	storia: detachable STORIA

feature --creazione

	make_with_id (un_id: STRING)
		require
			non_e_stringa_nulla: not (un_id ~ "")
		do
			id := un_id
			finale := False
			create initial.make_empty
			create figli.make_empty
			create transizioni.make_empty
			create onEntry.make_empty
			create onExit.make_empty
		ensure
			attributo_assegnato: id = un_id
		end

	make_final_with_id (un_id: STRING)
		require
			non_e_stringa_nulla: not (un_id ~ "")
		do
			make_with_id (un_id)
			set_final
		ensure
			attributo_assegnato: id = un_id
			final_assegnato: finale = True
		end

	make_with_id_and_parent (un_id: STRING; un_genitore: STATO)
		require
			non_e_stringa_nulla: not (un_id ~ "")
		do
			make_with_id (un_id)
			set_genitore(un_genitore)
		ensure
			attributo_assegnato: id = un_id
			genitore_assegnato: genitore = un_genitore
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
			finale := True
		ensure
			ora_e_finale: finale
		end

	set_onEntry (una_azione: AZIONE)
		require
			e_una_azione: una_azione /= Void
		do
			onEntry.force(una_azione, onEntry.count+1)
		ensure
			azione_assegnata: onEntry[onEntry.count] = una_azione
		end

	set_onExit (una_azione: AZIONE)
		require
			e_una_azione: una_azione /= Void
		do
			onExit.force (una_azione,onExit.count+1)
		ensure
			azione_assegnata: onExit[onExit.count] = una_azione
		end

	set_genitore (un_genitore: STATO)
		require
			genitore_esistente: un_genitore /= Void
		do
			genitore := un_genitore
		ensure
			genitore_acquisito: genitore = un_genitore
		end

feature -- stato
	stato_atomico: BOOLEAN
		-- ritorna vero se lo stato è uno stato atomico
		do
			Result := figli.is_empty
		end

feature -- modifica

	aggiungi_transizione (una_transizione: TRANSIZIONE)
		do
			transizioni.force (una_transizione, transizioni.count + 1)
		end

	add_figlio (uno_stato: STATO)
		require
			uno_stato_esistente: uno_stato /= Void
		do
			figli.force (uno_stato, figli.count + 1)
		end

	add_storia (una_storia: STORIA)
		require
			una_storia_esistente: una_storia /= Void
		do
			storia := una_storia
		end

feature -- situazione

	transizione_abilitata (eventi: LINKED_SET [STRING]; variabili: DATAMODEL): detachable TRANSIZIONE
	-- restituisce in base ai valori correnti di `eventi' e `variabili' la prima transizione abilitata in questo stato
	-- sia direttamente nello stato (priorità SCXML dell'ordine di scrittura nel file .xml) o (se non ve ne sono)
	-- mediante ereditarietà da un antenato (priorità strutturale object oriented)
	-- TODO: nel caso di un evento (o più eventi presenti nello stesso istante) in grado di abilitare più transizioni
	-- TODO: 	se è uno stesso evento si può rilevare durante l'analisi della SC (e poi vanno introdotte e gestite qui le priorità)
	-- TODO: 	se sono eventi diversi va rilevato dinamicamente in questa feature
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
				evento_abilitato := transizione_corrente.check_evento (eventi)
				condizione_abilitata := transizione_corrente.check_condizione (variabili)
				if evento_abilitato and condizione_abilitata then
					Result := transizioni [index_count]
				end
				index_count := index_count + 1
			end
			if Result = Void then
				if attached genitore as sg then
					Result := sg.transizione_abilitata (eventi, variabili)
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

	incomparabile_con (uno_stato: STATO): BOOLEAN
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
		-- TODO: da rimuovere quando si ristruttura la classe
		do
			across transizioni as t
			loop
	        	if attivabile(t.item, evento_corrente, hash_delle_condizioni) then
		        	Result := t.item.destinazione
		        end
			end
			if Result = Void then
				Result := Current
			end
		end

	get_transition (evento_corrente: STRING): TRANSIZIONE
		-- ritorna la transizione abilitata con `evento_corrente'
		-- non viene mai invocata
		-- TODO: da rimuovere quando si ristruttura la classe
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

feature -- utilita

	stampa
	do
		print("--------------------%N")
		print("stato con id = " + id + "%N")
		if attached genitore as g then print("  genitore: " + g.id + "%N") end
		if not initial.is_empty then
			print("  initial: ")
			across initial as i
			loop print(i.item.id + ", ")
			end
			print("%N")
		end
		if not figli.is_empty then
			print("  figli: ")
			across figli as f
			loop print (f.item.id + ", ")
			end
			print("%N")
		end
	end

end
