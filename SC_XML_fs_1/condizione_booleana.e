note
	description: "Summary description for {CONDIZIONE_BOOELANA}."
	author: "Marco Aragona & Gabriele Messina"
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE_BOOLEANA

inherit
	CONDIZIONE

create
	make

feature -- attributi
	valore: BOOLEAN

feature {NONE} -- Initialization
	make (variabile_input: STRING; espressione_input: STRING; valore_input: BOOLEAN)
		do
			variabile := variabile_input
			espressione := espressione_input
			valore := valore_input
		end
end
