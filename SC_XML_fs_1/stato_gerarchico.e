note
	description: "Summary description for {STATO_GERARCHICO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATO_GERARCHICO

inherit
	STATO
		redefine
			stampa
		end

create
	make_with_id,
	make_final_with_id,
	make_with_id_and_parent

feature --setter

	set_stato_atomico
		do
			stato_atomico := False
		end

feature --situazione

	add_figlio (uno_stato: STATO)
		do
			figli.force (uno_stato, figli.count + 1)
		end

	antenato_di (uno_stato: STATO): BOOLEAN
			-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
			-- controlla se il Current � antenato "proprio" di `uno_stato`antenato_di (uno_stato: STATO): BOOLEAN
			-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
			-- controlla se il Current � antenato "proprio" di `uno_stato`
		do
			if attached uno_stato.genitore as sg then
				if sg = Current then
					Result := True
				else
					Result := antenato_di (sg)
				end
			else
				Result := False
			end
		end

feature --utilit�

	stampa
		do
			Precursor {STATO}
			if not initial.is_empty then
				print (" initial: ")
				across
					initial as i
				loop
					print (i.item.id + ", ")
				end
				print ("%N")
			end
			if not figli.is_empty then
				print (" figli: ")
				across
					figli as f
				loop
					print (f.item.id + ", ")
				end
				print ("%N")
			end
		end

end 


