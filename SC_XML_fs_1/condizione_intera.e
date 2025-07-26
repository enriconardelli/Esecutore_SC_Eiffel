note
	description: "Summary description for {CONDIZIONE}."
	author: "Marco Aragona & Gabriele Messina"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CONDIZIONE_INTERA

inherit
	CONDIZIONE

feature -- attributi
	operazione: STRING

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

feature
    valuta (variabili_intere: HASH_TABLE [INTEGER, STRING]): BOOLEAN
        deferred
        end
end
