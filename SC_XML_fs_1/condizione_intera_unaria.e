note
	description: "Summary description for {CONDIZIONE_INTERA_UNARIA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE_INTERA_UNARIA

inherit
	CONDIZIONE_INTERA

redefine
	valuta
	end

create
	make

feature -- attributi
	valore: INTEGER

--feature -- Initialization
--	make_empty
--		do
--			is_null := false
--			variabile := "NULL"
--			operazione := "NULL"
--			valore := 0
--			is_empty:= True
--		end

feature
	make(variabile_input: STRING; operazione_input: STRING; valore_input: INTEGER)
		do
			is_null := false
			variabile := variabile_input
			operazione := operazione_input
			valore := valore_input
			is_empty:= variabile.is_empty and operazione.is_empty and valore=0
		end

--feature
--	set (variabile_input: STRING; operazione_input: STRING; valore_input: INTEGER)
--		do
--			is_null := false
--			variabile := variabile_input
--			operazione := operazione_input
--			valore := valore_input
--			is_empty:= variabile.is_empty and operazione.is_empty and valore=0
--		end

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
