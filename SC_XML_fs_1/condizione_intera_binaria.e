note
	description: "Summary description for {CONDIZIONE_INTERA_BINARIA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE_INTERA_BINARIA
inherit
	CONDIZIONE_INTERA

redefine
	valuta
	end

create
	make

feature -- attributi
	variabile2: STRING

feature
	make(variabile_input: STRING; operazione_input: STRING; variabile2_input: STRING)
		do
--			is_null := false
			variabile := variabile_input
			operazione := operazione_input
			variabile2 := variabile2_input
--			is_empty:= variabile.is_empty and operazione.is_empty and variabile2.is_empty
		end

feature -- Valutazione
    valuta (variabili_intere: HASH_TABLE [INTEGER, STRING]): BOOLEAN
        do
        	Result:= valutazione(variabili_intere.item(variabile), variabili_intere.item(variabile2))
        end

end
