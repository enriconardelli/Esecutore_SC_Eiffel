note
	description: "Summary description for {STATO_AND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATO_AND

inherit
	STATO

create
	make_with_id, make_with_id_and_parent

feature -- setter

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
