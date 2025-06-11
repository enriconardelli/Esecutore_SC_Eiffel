note
	description: "Summary description for {CONDIZIONE_INTERA_BINARIA}."
	author: "Marco Aragona & Gabriele Messina"
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE_INTERA_BINARIA

inherit
	CONDIZIONE

create
	make

feature -- attributi
	seconda_variabile: INTEGER

feature {NONE} -- Initialization
	make (variabile_input: STRING; espressione_input: STRING; seconda_variabile_input: INTEGER)
		do
			variabile := variabile_input
			espressione := espressione_input
			seconda_variabile := seconda_variabile_input
		end
end
