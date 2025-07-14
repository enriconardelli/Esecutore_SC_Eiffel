note
	description: "Summary description for {CONDIZIONE_BOOLEANA_BINARIA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE_BOOLEANA_BINARIA

inherit
	CONDIZIONE_BOOLEANA

redefine
	valuta
	end

create
	make

feature -- attributi
	operazione: STRING
	variabile2: STRING

feature
	make(variabile_input: STRING; operazione_input: STRING; variabile2_input: STRING)
		do
			is_null := false
			variabile := variabile_input
			operazione := operazione_input
			variabile2 := variabile2_input
			is_empty:= variabile.is_empty and operazione.is_empty and variabile2.is_empty
		end

feature -- Valutazione
    valutazione (v1, v2: BOOLEAN): BOOLEAN
        do
        	Result:=False
        	if operazione.is_equal("/=") then
				Result := v1 /= v2
			elseif operazione.is_equal("=") then
				Result := v1 = v2
			elseif operazione.is_equal("and") then
				Result := v1 and v2
			elseif operazione.is_equal("or") then
				Result := v1 or v2
			end
        end

    valuta (variabili_booleane: HASH_TABLE [BOOLEAN, STRING]): BOOLEAN
        do
        	Result:= valutazione(variabili_booleane.item(variabile), variabili_booleane.item(variabile2))
        end

end
