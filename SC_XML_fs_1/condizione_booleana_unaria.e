note
	description: "Summary description for {CONDIZIONE_BOOLEANA_UNARIA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE_BOOLEANA_UNARIA

inherit
	CONDIZIONE_BOOLEANA

create
	make

feature
	make(variabile_input: STRING)
		do
			is_null := false
			variabile := variabile_input
			is_empty:= variabile.is_empty
		end

end
