note
	description: "Summary description for {CONDIZIONE_BOOELANA}."
	author: "Marco Aragona & Gabriele Messina"
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE_BOOLEANA

inherit
	CONDIZIONE

redefine
    make_empty
    end

create
	make_empty

feature
	make_empty
		do
			is_null := false
			variabile := "NULL"
			is_empty:= True
		end

feature -- Valutazione
    valuta (variabili_booleane: HASH_TABLE [BOOLEAN, STRING]): BOOLEAN
        do
        	Result:=False
        end

    negata(variabili_booleane: HASH_TABLE [BOOLEAN, STRING]): BOOLEAN
    	do
    		Result:= not valuta(variabili_booleane)
    	end
end

