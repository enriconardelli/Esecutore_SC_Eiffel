note
	description: "Summary description for {CONDIZIONE_BOOLEANA_UNARIA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE_BOOLEANA_UNARIA

inherit
	CONDIZIONE_BOOLEANA

redefine
	valuta
	end

create
	make

feature
	make(negata_input: BOOLEAN; variabile_input: STRING)
		do
--			is_null := false
			negata := negata_input
			variabile := variabile_input
--			is_empty:= variabile.is_empty
		end

    valuta (variabili_booleane: HASH_TABLE [BOOLEAN, STRING]): BOOLEAN
        do
        	Result:= variabili_booleane.item(variabile)
        	if negata then
        		Result := not Result
        	end
        end
end
