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
	make_empty

feature -- attributi
	operazione: STRING
	valore: INTEGER
	is_empty: BOOLEAN

feature -- Initialization
	make_empty
		do
			is_null := false
			variabile := "NULL"
			operazione := "NULL"
			valore := 0
			is_empty:= True
		end

feature
	set (variabile_input: STRING; operazione_input: STRING; valore_input: INTEGER)
		do
			is_null := false
			variabile := variabile_input
			operazione := operazione_input
			valore := valore_input
			is_empty:= variabile.is_empty and operazione.is_empty and valore=0
		end

feature -- Valutazione
    valuta (variabile_istanziata: INTEGER): BOOLEAN
        do
        	Result:=False
        	if operazione.is_equal("<=") then
				Result := variabile_istanziata <= valore
			elseif operazione.is_equal("<") then
				Result := variabile_istanziata < valore
			elseif operazione.is_equal(">=") then
				Result := variabile_istanziata >= valore
			elseif operazione.is_equal(">") then
				Result := variabile_istanziata > valore
			elseif operazione.is_equal("/=") then
				Result := variabile_istanziata /= valore
			elseif operazione.is_equal("=") then
				Result := variabile_istanziata = valore
			end
        end

end
