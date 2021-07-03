note
	description: "Summary description for {STATO_ATOMICO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATO_ATOMICO

inherit
	STATO

create
	make_with_id, make_final_with_id, make_with_id_and_parent

feature--setter

	set_stato_atomico
		do
			stato_atomico := True
		end

feature --situazione

	antenato_di (uno_stato: STATO):BOOLEAN
		do
			Result:= False
		end

end
