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

feature {NONE} -- Initialization
	make (variabile_input: STRING)
		do
			variabile := variabile_input
		end
end
