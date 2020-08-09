note
	description: "La classe che rappresenta le transizioni"
	author: "Gabriele Cacchioni & Davide Canalis"
	date: "14-04-2015"
	revision: "0.2"

class
	TRANSIZIONE

create
	make_with_target

feature -- creazione

	make_with_target(stato_destinazione, stato_sorgente: STATO)
		do
			set_sorgente(stato_sorgente)
			set_target(stato_destinazione)
            create azioni.make_empty
			evento := Void
			internal := False
			condizione := "condizione_vuota"
		end

feature -- attributi

	evento: detachable STRING

	condizione: STRING

    azioni: ARRAY [AZIONE]

    sorgente: STATO

	target: STATO

	internal: BOOLEAN

feature -- setter

	set_evento (a_string: STRING)
		require
			not_void: a_string /= Void
		do
			evento := a_string
		end

	set_condizione (a_string: STRING)
		require
			not_void: a_string /= Void
		do
			condizione := a_string
		end

	set_target (uno_stato: STATO)
		require
			not_void: uno_stato /= Void
		do
			target := uno_stato
		end

	set_sorgente (uno_stato: STATO)
		require
			not_void: uno_stato /= Void
		do
			sorgente := uno_stato
		end

	set_internal
		do
			internal := TRUE
		end

feature -- check

	check_evento (istante: LINKED_SET [STRING] ): BOOLEAN
		do
			if attached evento as e then
				if istante.has (e) then
					result:= TRUE
				end
			else
				result:= TRUE
			end
		end

	check_condizioni (condizioni: HASH_TABLE [BOOLEAN, STRING]; data: HASH_TABLE [INTEGER, STRING]): BOOLEAN
	do
		result := check_condizione_booleano (condizioni) and check_condizione_intero (data)
	end

	check_condizione_booleano (condizioni: HASH_TABLE [BOOLEAN, STRING]): BOOLEAN
	-- Controlla se la condizione dell'evento è verificata.
	do
		if condizione ~ "condizione_vuota" then
			result:= true
		else
			if condizioni.has (condizione) then
				result:= condizioni.item (condizione)
			else
				result:= true
			end
		end
	end

	check_condizione_intero(data: HASH_TABLE [INTEGER, STRING]): BOOLEAN
	local
		loc: STRING
		cond_num: INTEGER
	do
		Result := true
		if condizione.has ('<') then
			loc := condizione.substring (1,   condizione.index_of ('<', 1) - 1)
			if condizione.has_substring ("<=") then
				cond_num := condizione.substring (condizione.index_of ('<', 1) + 2, condizione.count).to_integer
				Result := data.item (loc) <= cond_num
			else
				cond_num := condizione.substring ( condizione.index_of ('<', 1) + 1, condizione.count).to_integer
				Result := data.item (loc) < cond_num
			end
		elseif condizione.has ('>') then
			loc := condizione.substring (1,  condizione.index_of ('>', 1) - 1)
			if condizione.has_substring (">=") then
				cond_num := condizione.substring (condizione.index_of ('>', 1) + 2, condizione.count).to_integer
				Result := data.item (loc) >= cond_num
			else
				cond_num := condizione.substring ( condizione.index_of ('>', 1) + 1, condizione.count).to_integer
				Result := data.item (loc) > cond_num
			end
		elseif condizione.has ('=') then
			if condizione.has_substring ("/=") then
				loc := condizione.substring (1,   condizione.index_of ('/', 1) - 1)
				cond_num := condizione.substring (condizione.index_of ('/', 1) + 2, condizione.count).to_integer
				Result := data.item (loc) /= cond_num
			else
				loc := condizione.substring (1,  condizione.index_of ('=', 1) - 1)
				cond_num := condizione.substring ( condizione.index_of ('=', 1) + 1, condizione.count).to_integer
				Result := data.item (loc) = cond_num
			end
		end
	end
end
