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
			create figli.make_empty
		end

feature -- setter

	add_figlio (uno_stato: STATO)
		require
			uno_stato_esistente: uno_stato /= Void
		do
			figli.force (uno_stato, figli.count + 1)
		end

	set_default
		local
			i: INTEGER
		do
			from
				i:= figli.lower
			until
				i= figli.upper + 1
			loop
				initial.force ( figli.item (i) , initial.count +1 )
				i:= i+1
			end
		end
end
