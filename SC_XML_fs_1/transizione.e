note
	description: "La classe che rappresenta le transizioni"
	author: "EN + studenti corsi PSI"
	date: "Agosto 2021"
	revision: "$Revision$"

class
	TRANSIZIONE

create
	make_with_target

feature -- costante

	Valore_Nullo : STRING = "NULL"

feature -- creazione

	make_with_target(stato_destinazione, stato_sorgente: STATO)
		--	in caso di destinazioni multiple viene invocata con la prima e le altre si aggiungono dopo
		do
			create sorgente.make
			create destinazione.make
			set_sorgente(stato_sorgente)
			set_target(stato_destinazione)
            create azioni.make_empty
			evento := Void
			internal := False
			condizione := Valore_Nullo
			fork := False
			merge := False
		end

feature -- attributi

	evento: detachable STRING

	condizione: STRING

    azioni: ARRAY [AZIONE]

    sorgente: LINKED_LIST [STATO]

	destinazione: LINKED_LIST [STATO]

	internal: BOOLEAN

	fork: BOOLEAN

	merge: BOOLEAN

feature -- setter

	set_evento (a_string: STRING)
		do
			evento := a_string
		end

	set_condizione (a_string: STRING)
		do
			condizione := a_string
		end

	set_target (uno_stato: STATO)
		do
			destinazione.force(uno_stato)
		end

	set_sorgente (uno_stato: STATO)
		do
			sorgente.force(uno_stato)
		end

	set_internal
		do
			internal := True
		end

	set_fork
		do
			fork := True
		end

	set_merge
		do
			merge := True
		end

	add_target(uno_stato: STATO)
		do
			if not destinazione.has(uno_stato) then
				destinazione.force(uno_stato)
			end
		end

	add_source(uno_stato: STATO)
		do
			if not sorgente.has(uno_stato) then
				sorgente.force(uno_stato)
			end
		end

feature -- check

	check_evento (istante: LINKED_SET [STRING] ): BOOLEAN
		do
			if attached evento as e then
				if istante.has (e) then
					Result:= True
				end
			else
				Result:= True
			end
		end

	check_condizione (variabili: DATAMODEL): BOOLEAN
	do
		Result := check_condizione_booleana (variabili.booleane) or check_condizione_intera (variabili.intere)
	end

	check_condizione_booleana (variabili_booleane: HASH_TABLE [BOOLEAN, STRING]): BOOLEAN
	-- Controlla se la condizione sulle variabili booleane è verificata.
	do
		if condizione ~ valore_nullo then
			Result:= True
		else
			if variabili_booleane.has (condizione) then
				Result:= variabili_booleane.item (condizione)
			else
				Result:= False
			end
		end
	end

	check_condizione_intera (variabili_intere: HASH_TABLE [INTEGER, STRING]): BOOLEAN
	-- Controlla se la condizione sulle variabili intere è verificata.
	-- assunzioni che NON vengono controllate:
	--		ciò che c'è prima di '<' o '>' o '=' o '/=' è il nome della variabile
	--		se c'è '=' dopo '<' o '>' allora li segue immediatamente
	--		se c'é '/' allora '=' lo segue immediatamente
	--		tutto ciò che c'è dopo espressione di confronto è trasformabile in numero
	local
		var: STRING
		valore: INTEGER
	do
		if condizione.has ('<') then
			var := condizione.substring (1,   condizione.index_of ('<', 1) - 1)
			if condizione.has_substring ("<=") then
				valore := condizione.substring (condizione.index_of ('<', 1) + 2, condizione.count).to_integer
				Result := variabili_intere.item (var) <= valore
			else
				valore := condizione.substring ( condizione.index_of ('<', 1) + 1, condizione.count).to_integer
				Result := variabili_intere.item (var) < valore
			end
		elseif condizione.has ('>') then
			var := condizione.substring (1,  condizione.index_of ('>', 1) - 1)
			if condizione.has_substring (">=") then
				valore := condizione.substring (condizione.index_of ('>', 1) + 2, condizione.count).to_integer
				Result := variabili_intere.item (var) >= valore
			else
				valore := condizione.substring ( condizione.index_of ('>', 1) + 1, condizione.count).to_integer
				Result := variabili_intere.item (var) > valore
			end
		elseif condizione.has ('=') then
			if condizione.has_substring ("/=") then
				var := condizione.substring (1,   condizione.index_of ('/', 1) - 1)
				valore := condizione.substring (condizione.index_of ('/', 1) + 2, condizione.count).to_integer
				Result := variabili_intere.item (var) /= valore
			else
				var := condizione.substring (1,  condizione.index_of ('=', 1) - 1)
				valore := condizione.substring ( condizione.index_of ('=', 1) + 1, condizione.count).to_integer
				Result := variabili_intere.item (var) = valore
			end
		else
			Result := False
		end
	end
end
