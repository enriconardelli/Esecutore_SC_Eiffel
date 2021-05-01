note
	description: "La classe che rappresenta le transizioni"
	author: "Gabriele Cacchioni & Davide Canalis"
	date: "14-04-2015"
	revision: "0.2"

class
	TRANSIZIONE

create
	make_with_target

feature -- costante

	Valore_Nullo : STRING = "NULL"

feature -- creazione

	make_with_target(stato_destinazione, stato_sorgente: STATO)
		do
			set_sorgente(stato_sorgente)
			set_target(stato_destinazione)
            create azioni.make_empty
			evento := Void
			internal := False
			condizione := "condizione_vuota"
			-- AGGIUNTE FORK
			fork:=False
			create multi_target.make
			-- FINE AGGIUNTE
		end

feature -- attributi

	evento: detachable STRING

	condizione: STRING

    azioni: ARRAY [AZIONE]

    sorgente: STATO

	destinazione: STATO

	internal: BOOLEAN

	--AGGIUNTE PER FORK

	fork:BOOLEAN

	multi_target: detachable LINKED_LIST [STATO]

	--FINE AGGIUNTE

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
			destinazione := uno_stato
		end

	set_sorgente (uno_stato: STATO)
		require
			not_void: uno_stato /= Void
		do
			sorgente := uno_stato
		end

	set_internal
		do
			internal := True
		end

	-- AGGIUNTE PER FORK	

	set_fork
		do
			fork := TRUE
		end

	add_target(uno_stato: STATO)
		do
			if uno_stato/=target then
			if attached multi_target as mt then mt.force(uno_stato) end
			end
		end

	--FINE AGGIUNTE	


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
	-- Controlla se la condizione sulle variabili booleane � verificata.
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
	-- Controlla se la condizione sulle variabili intere � verificata.
	-- assunzioni che NON vengono controllate:
	--		ci� che c'� prima di '<' o '>' o '=' o '/=' � il nome della variabile
	--		se c'� '=' dopo '<' o '>' allora li segue immediatamente
	--		se c'� '/' allora '=' lo segue immediatamente
	--		tutto ci� che c'� dopo espressione di confronto � trasformabile in numero
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
