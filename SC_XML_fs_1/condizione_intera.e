note
	description: "Summary description for {CONDIZIONE}."
	author: "Marco Aragona & Gabriele Messina"
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE_INTERA

inherit
	CONDIZIONE

create
	make, make_empty

feature -- attributi
	operazione: STRING
	valore: INTEGER--POI TOGLI SE NON NECESSARIA
	is_empty: BOOLEAN

feature -- Initialization
	make (variabile_input: STRING; operazione_input: STRING; valore_input: INTEGER)
		do
			variabile := variabile_input
			operazione := operazione_input
			valore := valore_input
			is_empty:= variabile.is_empty and operazione.is_empty and valore=0
		end

	make_empty
		do
			variabile := "V"
			operazione := "V"
			valore := 0
			is_empty:= True
		end
end
