note
	description: "Summary description for {CONDIZIONE_BOOELANA}."
	author: "Marco Aragona & Gabriele Messina"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CONDIZIONE_BOOLEANA

inherit
	CONDIZIONE
	
feature
	negata: BOOLEAN

feature -- Operazioni
    lista_operazioni: ARRAY[STRING]
       once
       		Result := <<"/=", "=","and" ,"or">>
       end

feature -- Valutazione
    valuta (variabili_booleane: HASH_TABLE [BOOLEAN, STRING]): BOOLEAN
        deferred
        end
end

