note
	description: "Summary description for {CONDIZIONE}."
	author: "Marco Aragona & Gabriele Messina"
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE_INTERA

inherit
	CONDIZIONE

create
	make, make_empty

feature -- attributi
	operazione: STRING
	valore: INTEGER
	is_empty: BOOLEAN

feature {NONE} -- Implementation
	confronti: HASH_TABLE [ROUTINE, STRING]

feature -- Initialization
	make (variabile_input: STRING; operazione_input: STRING; valore_input: INTEGER)
		do
			is_null := false
			variabile := variabile_input
			operazione := operazione_input
			valore := valore_input
			is_empty:= variabile.is_empty and operazione.is_empty and valore=0
			inizializza_confronti
		end

	set (variabile_input: STRING; operazione_input: STRING; valore_input: INTEGER)
		do
			is_null := false
			variabile := variabile_input
			operazione := operazione_input
			valore := valore_input
			is_empty:= variabile.is_empty and operazione.is_empty and valore=0
		end

	make_empty
		do
			is_null := false
			variabile := "NULL"
			operazione := "NULL"
			valore := 0
			is_empty:= True
			inizializza_confronti
		end

feature {NONE} -- Setup
    inizializza_confronti
        do
            create confronti.make (6)
            confronti.put (agent (x: INTEGER): BOOLEAN do Result := x <= valore end, "<=")
            confronti.put (agent (x: INTEGER): BOOLEAN do Result := x >= valore end, ">=")
            confronti.put (agent (x: INTEGER): BOOLEAN do Result := x /= valore end, "/=")
            confronti.put (agent (x: INTEGER): BOOLEAN do Result := x < valore end, "<")
            confronti.put (agent (x: INTEGER): BOOLEAN do Result := x > valore end, ">")
            confronti.put (agent (x: INTEGER): BOOLEAN do Result := x = valore end, "=")
        end

feature -- Valutazione
    valuta (variabile_istanziata: INTEGER): BOOLEAN
        do
            if attached confronti.item(operazione) as confronto then
           		confronto.call(variabile_istanziata)
            end
        end
        
end
