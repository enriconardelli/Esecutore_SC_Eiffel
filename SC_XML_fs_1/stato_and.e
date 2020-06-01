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

	set_initial
		local
			i: INTEGER
		do
			across figli as f
			loop
				initial.force (f.item, initial.count + 1)
			end
		end
end
