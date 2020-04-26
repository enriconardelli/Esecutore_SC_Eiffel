note
	description: "Summary description for {STATO_AND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATO_AND

inherit
	STATO
	redefine
		make_with_id
	end

create
	make_with_id

feature -- creazione

	make_with_id (un_id: STRING)
		do
			Precursor (un_id)
			create stati_figli.make_empty
		end

feature -- attributi

	stati_figli: ARRAY [STATO]

feature -- setter

	add_figlio (uno_stato: STATO)
	require
		uno_stato_esistente: uno_stato /= Void
	do
		stati_figli.force (uno_stato, stati_figli.count + 1)
	end

	set_stato_default
		local
			i: INTEGER
		do
			from
				i:= stati_figli.lower
			until
				i= stati_figli.upper + 1
			loop
				stato_default.force ( stati_figli.item (i) , stato_default.count +1 )
				i:= i+1
			end
		end

end
