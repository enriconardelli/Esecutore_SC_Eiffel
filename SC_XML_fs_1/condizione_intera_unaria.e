note
	description: "Summary description for {CONDIZIONE_INTERA_UNARIA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE_INTERA_UNARIA

inherit
	CONDIZIONE_INTERA

redefine
	valuta
	end

create
	make

feature -- attributi
	valore: INTEGER

feature
	make(variabile_input: STRING; operazione_input: STRING; valore_input: INTEGER)
		do
--			is_null := false
			variabile := variabile_input
			operazione := operazione_input
			valore := valore_input
--			is_empty:= variabile.is_empty and operazione.is_empty and valore=0
		end

feature -- Valutazione
	valuta (variabili_intere: HASH_TABLE [INTEGER, STRING]): BOOLEAN
        do
			Result:= valutazione(variabili_intere.item(variabile), valore)
        end
end
