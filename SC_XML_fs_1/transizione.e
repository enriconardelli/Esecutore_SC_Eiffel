note
	description: "La classe che rappresenta le transizioni"
	author: "EN + studenti corsi PSI"
	date: "Maggio 2021"
	revision: "$Revision$"

class
	TRANSIZIONE

create
	make_with_target

feature -- costante

	Valore_Nullo : STRING = "NULL"

feature -- creazione

--	NOTA: non cambia perch� in caso di destinazioni multiple viene invocata con la prima
	make_with_target(stato_destinazione, stato_sorgente: STATO)
		do
			create destinazione.make
			set_sorgente(stato_sorgente)
			set_target(stato_destinazione)
            create azioni.make_empty
			evento := Void
			internal := False
			condizione := Valore_Nullo
			-- AGGIUNTE FORK
			fork := False
--			la create successiva scompare
--			create multi_target.make
			-- FINE AGGIUNTE
		end

feature -- attributi

	evento: detachable STRING

	condizione: STRING

    azioni: ARRAY [AZIONE]

    sorgente: STATO

	-- TODO: eliminare multi_target e ridefinire `destinazione' come LINKED_LIST [STATO]
	-- OLD	destinazione: STATO
	 destinazione: LINKED_LIST [STATO]

	internal: BOOLEAN

	--AGGIUNTE FORK

	fork: BOOLEAN

	-- TODO: eliminare multi_target e ridefinire `destinazione' come LINKED_LIST [STATO]
--	multi_target: detachable LINKED_LIST [STATO]

	--FINE AGGIUNTE

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
-- OLD			destinazione := uno_stato
		end

	set_sorgente (uno_stato: STATO)
		do
			sorgente := uno_stato
		end

	set_internal
		do
			internal := True
		end

	-- AGGIUNTE FORK	

	set_fork
		do
			fork := True
		end

	add_target(uno_stato: STATO)
		do
			if not destinazione.has(uno_stato) then
				destinazione.force(uno_stato)
			end
-- OLD				if uno_stato /= destinazione then
--				if attached multi_target as mt then mt.force(uno_stato) end
--			end
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
