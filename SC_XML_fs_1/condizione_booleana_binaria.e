note
	description: "Summary description for {CONDIZIONE_BOOLEANA_BINARIA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE_BOOLEANA_BINARIA

inherit
	CONDIZIONE_BOOLEANA

create
	make

feature -- attributi
	operazione: STRING
	negata2: BOOLEAN
	variabile2: STRING

feature
	make(negata_input: BOOLEAN; variabile_input: STRING; operazione_input: STRING; negata2_input: BOOLEAN; variabile2_input: STRING)
		do
			negata := negata_input
			variabile := variabile_input
			operazione := operazione_input
			negata2 := negata2_input
			variabile2 := variabile2_input
		end

feature -- Operazioni
    lista_operazioni: ARRAY[STRING]
       once
       		Result := <<"!=", "=","&" ,"|">>
       end

feature -- Valutazione
    valutazione (v1, v2: BOOLEAN): BOOLEAN
        do
        	Result:=False
        	if operazione.is_equal("!=") then
				Result := v1 /= v2
			elseif operazione.is_equal("=") then
				Result := v1 = v2
			elseif operazione.is_equal("&") then
				Result := v1 and v2
			elseif operazione.is_equal("|") then
				Result := v1 or v2
			end
        end

    valuta (variabili_booleane: HASH_TABLE [BOOLEAN, STRING]): BOOLEAN
        local
        	var1, var2: BOOLEAN
        do
        	var1 := variabili_booleane.item(variabile)
        	var2 := variabili_booleane.item(variabile2)
        	if negata then
        		var1 := not var1
        	end
        	if negata then
        		var2 := not var2
        	end
        	Result:= valutazione(var1, var2)
        end
end
