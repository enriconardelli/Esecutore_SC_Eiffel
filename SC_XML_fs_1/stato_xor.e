note
	description: "Summary description for {STATO_XOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATO_XOR

inherit

	STATO
--	redefine
--		make_with_id
--	end

create
	make_with_id, make_with_id_and_parent

--feature -- creazione

--	make_with_id (un_id: STRING)
--		do
--			Precursor (un_id)
--			create figli.make_empty
--		end

feature -- setter

	add_figlio (uno_stato: STATO)
		require
			uno_stato_esistente: uno_stato /= Void
		do
			figli.force (uno_stato, figli.count + 1)
		end

	set_initial (uno_stato: STATO)
		require
			uno_stato_esistente: uno_stato /= Void
		do
			initial.force (uno_stato, 1)
		end
end
