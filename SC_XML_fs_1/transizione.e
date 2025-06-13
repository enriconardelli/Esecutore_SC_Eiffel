note
	description: "La classe che rappresenta le transizioni"
	author: "EN + studenti corsi PSI"
	date: "Agosto 2021"
	revision: "$Revision$"

class
	TRANSIZIONE

create
	make_con_destinazione

feature -- costante

	Valore_Nullo : STRING = "NULL"

feature -- creazione

	make_con_destinazione (stato_destinazione, stato_sorgente: STATO)
		--	in caso di destinazioni o sorgenti multiple viene invocata con la prima e le altre si aggiungono dopo
		do
			create sorgente.make
			create destinazione.make
			set_sorgente (stato_sorgente)
			set_destinazione (stato_destinazione)
            create azioni.make_empty
			evento := Void
			interna := False
			condizione := Valore_Nullo
			fork := False
			merge := False
		end

feature -- attributi

	evento: detachable STRING

	condizione: CONDIZIONE

    azioni: ARRAY [AZIONE]

    sorgente: LINKED_LIST [STATO]

	destinazione: LINKED_LIST [STATO]

	interna: BOOLEAN

	fork: BOOLEAN

	merge: BOOLEAN

feature -- setter

	set_evento (a_string: STRING)
		do
			evento := a_string
		end

	set_condizione (a_condizione: CONDIZIONE)
		do
			condizione := a_condizione
		end

	set_destinazione (uno_stato: STATO)
		do
			destinazione.force(uno_stato)
		end

	set_sorgente (uno_stato: STATO)
		do
			sorgente.force(uno_stato)
		end

	set_interna
		do
			interna := True
		end

	set_fork
		do
			fork := True
		end

	set_merge
		do
			merge := True
		end

	add_destinazioni (destinazioni: LINKED_LIST [STATO])
		do
			across destinazioni as d
			loop
				if not destinazione.has(d.item) then
					destinazione.force(d.item)
				else
					print("AVVISO: lo stato >|" + d.item.id + "|< è gia presente tra le destinazioni!%N")
				end
			end
		end

	add_sorgenti (sorgenti: LINKED_LIST [STATO])
		do
			across sorgenti as s
			loop
				if not sorgente.has(s.item) then
					sorgente.force(s.item)
				else
					print("AVVISO: lo stato >|" + s.item.id + "|< è gia presente tra le sorgenti!%N")
				end
			end
		end

feature -- check

	check_evento (eventi_istante_corrente: LINKED_SET [STRING] ): BOOLEAN
		do
			if attached evento as e then
				if eventi_istante_corrente.has (e) then
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
