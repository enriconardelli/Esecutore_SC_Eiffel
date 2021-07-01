note
	description: "Summary description for {STATO_XOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATO_XOR

inherit

	STATO_GERARCHICO

create
	make_with_id, make_with_id_and_parent

feature -- setter

	set_initial
		do
			initial.make_empty
		end

	set_stato_initial (uno_stato: STATO)
		require
			uno_stato_esistente: uno_stato /= Void
		do
			initial.force (uno_stato, 1)
		end
end
