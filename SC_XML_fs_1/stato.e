note
	description: "Summary description for {STATO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STATO

feature --attributi

	transizioni: ARRAY[TRANSIZIONE]
	--le transizioni che escono dallo stato corrente

	attivo: BOOLEAN
	--indipendentemente se stia stato atomico o meno

	finale: BOOLEAN

	initial: ARRAY[STATO]

	genitore: detachable STATO
	--eventuale genitore dello stato corrente

	figli: ARRAY[STATO]

	id: STRING

	onEntry: ARRAY[AZIONE]
	--azioni eseguite all'ingresso dello stato (reazioni stati entering [ns] di Harell)

	onExit: ARRAY[AZIONE]
	--azioni eseguite all'uscita da uno stato (reazioni stati exiting [nx] di Harell)

	storia: detachable STORIA

feature --creazione

	make_with_id (un_id: STRING)
		require
			non_e_stringa_nulla: not (un_id ~ "")
		do
			id := un_id
			finale := False
			create transizioni.make_empty
			create initial.make_empty
			create figli.make_empty
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

feature --setter

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
		do
			onEntry.force(una_azione, onEntry.count+1)
		ensure
			azione_assegnata: onEntry[onEntry.count] = una_azione
		end

 	set_onExit (una_azione: AZIONE)
		do
			onExit.force (una_azione,onExit.count+1)
		ensure
			azione_assegnata: onExit[onExit.count] = una_azione
		end

 	set_genitore (un_genitore: STATO)
		do
			genitore := un_genitore
		ensure
			genitore_acquisito: genitore = un_genitore
		end

feature --azione

	aggiungi_transizione (una_transizione: TRANSIZIONE)
		do
			transizioni.force (una_transizione, transizioni.count + 1)
		end

	add_storia (una_storia: STORIA)
		do
			storia := una_storia
		end

feature --situazione

	transizione_abilitata (eventi: LINKED_SET [STRING]; variabili: DATAMODEL): detachable TRANSIZIONE
		-- restituisce in base ai valori correnti di `eventi' e `variabili' la prima transizione abilitata in questo stato
		-- sia direttamente nello stato (priorità SCXML dell'ordine di scrittura nel file .xml) o (se non ve ne sono)
		-- mediante ereditarietà da un antenato (priorità strutturale object oriented)
		-- TODO: nel caso di un evento (o più eventi presenti nello stesso istante) in grado di abilitare più transizioni
		-- TODO: se è uno stesso evento si può rilevare durante l'analisi della SC (e poi vanno introdotte e gestite qui le priorità)
		-- TODO: se sono eventi diversi va rilevato dinamicamente in questa feature
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
	-- controlla se il Current è antenato "proprio" di `uno_stato'antenato_di (uno_stato: STATO): BOOLEAN
	-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
	-- controlla se il Current è antenato "proprio" di `uno_stato'

	deferred
	end

	incomparabile_con (uno_stato: STATO): BOOLEAN
	-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
		do
			if Current /= uno_stato and not antenato_di(uno_stato) and not uno_stato.antenato_di(Current) then
				Result := true
			end
		end

	ha_sottostati_attivi:BOOLEAN
	--Filippo & Iezzi 30/09/2020
		deferred
		end

feature --utilità

	stampa
		do
			print("--------------------%N")
			print("stato con id = " + id + "%N")
			if attached genitore as g then print(" genitore: " + g.id + "%N") end
		end
end
