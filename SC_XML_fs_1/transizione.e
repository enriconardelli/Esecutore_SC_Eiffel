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

	target: STATO

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
					result:= TRUE
				end
			else
				result:= TRUE
			end
		end

	check_condizione (hash_delle_condizioni: HASH_TABLE [BOOLEAN, STRING] ): BOOLEAN
	-- Controlla se la condizione dell'evento è verificata.
	do
		if condizione ~ "condizione_vuota" then
				result:= TRUE
		else
			result:= hash_delle_condizioni.item (condizione)
		end
	end

end
