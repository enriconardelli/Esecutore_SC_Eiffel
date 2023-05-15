note
	description: "Summary description for {STATO_AND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATO_AND

inherit

	STATO_GERARCHICO

create
	make_with_id, make_final_with_id, make_with_id_and_parent

feature -- setter

	set_initial
		do
			across
				figli as f
			loop
				initial.force (f.item, initial.count + 1)
			end
		end

end
