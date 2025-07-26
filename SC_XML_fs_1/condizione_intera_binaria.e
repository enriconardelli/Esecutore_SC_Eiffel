note
	description: "Summary description for {CONDIZIONE_INTERA_BINARIA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE_INTERA_BINARIA
inherit
	CONDIZIONE_INTERA

create
	make

feature -- attributi
	variabile2: STRING

feature
	make(variabile_input: STRING; operazione_input: STRING; variabile2_input: STRING)
		do
			variabile := variabile_input
			operazione := operazione_input
			variabile2 := variabile2_input
		end

feature -- Valutazione
    valuta (variabili_intere: HASH_TABLE [INTEGER, STRING]): BOOLEAN
        do
        	Result:= valutazione(variabili_intere.item(variabile), variabili_intere.item(variabile2))
        end

end
