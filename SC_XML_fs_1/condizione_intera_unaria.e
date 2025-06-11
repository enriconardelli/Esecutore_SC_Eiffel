note
	description: "Summary description for {CONDIZIONE_INTERA_UNARIA}."
	author: "Marco Aragona & Gabriele Messina"
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE_INTERA_UNARIA

inherit
	CONDIZIONE

create
	make

feature -- attributi
	valore: INTEGER

feature {NONE} -- Initialization
	make (variabile_input: STRING; espressione_input: STRING; valore_input: INTEGER)
		do
			variabile := variabile_input
			espressione := espressione_input
			valore := valore_input
		end
end
