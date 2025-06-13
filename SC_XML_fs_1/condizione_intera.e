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
	variabile2: STRING --POI TOGLI SE NON NECESSARIA
	is_empty: BOOLEAN

feature -- Initialization
	make (variabile_input: STRING; operazione_input: STRING; variabile2_input: STRING)
		do
			variabile := variabile_input
			operazione := operazione_input
			variabile2 := variabile2_input
			is_empty:= variabile.is_empty and operazione.is_empty and variabile2.is_empty
		end

	make_empty
		do
			variabile := "V"
			operazione := "V"
			variabile2 := "V"
			is_empty:= True
		end

end
