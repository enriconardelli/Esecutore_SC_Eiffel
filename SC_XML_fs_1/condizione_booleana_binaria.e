note
	description: "Summary description for {CONDIZIONE_BOOELANA_BINARIA}."
	author: "Marco Aragona & Gabriele Messina"
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE_BOOLEANA_BINARIA

inherit
	CONDIZIONE_BOOLEANA

create
	make

feature -- attributi
	operazione: STRING
	variabile2: STRING

feature {NONE} -- Initialization
	make (variabile_input: STRING; operazione_input: STRING; variabile2_input: STRING)
		do
			variabile := variabile_input
			operazione := operazione_input
			variabile2 := variabile2_input
		end
end
