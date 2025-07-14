note
	description: "Summary description for {CONDIZIONE}."
	author: "Marco Aragona & Gabriele Messina"
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE_INTERA

inherit
	CONDIZIONE

redefine
	make_empty
	end

create make_empty

feature -- attributi
	operazione: STRING

feature -- Initialization
	make_empty
		do
			is_null := false
			variabile := "NULL"
			operazione := "NULL"
			is_empty:= True
		end

feature -- Valutazione
    lista_operazioni: ARRAY[STRING]
       once
       		Result := <<"<=", ">=", "/=" , "<", ">", "=">>
       end

    valutazione (v1, v2: INTEGER): BOOLEAN
        do
        	Result:=False
        	if operazione.is_equal("<=") then
				Result := v1 <= v2
			elseif operazione.is_equal("<") then
				Result := v1 < v2
			elseif operazione.is_equal(">=") then
				Result := v1 >= v2
			elseif operazione.is_equal(">") then
				Result := v1 > v2
			elseif operazione.is_equal("/=") then
				Result := v1 /= v2
			elseif operazione.is_equal("=") then
				Result := v1 = v2
			end
        end

    valuta (variabili_intere: HASH_TABLE [INTEGER, STRING]): BOOLEAN
        do
        	Result:=False
        end
end
