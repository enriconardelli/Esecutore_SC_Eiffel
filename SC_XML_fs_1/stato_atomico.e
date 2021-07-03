note
	description: "Summary description for {STATO_ATOMICO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATO_ATOMICO

inherit
	PROVVISORIO

create
	make_with_id, make_final_with_id, make_with_id_and_parent

feature --creazione

	make_with_id (un_id: STRING)
--		require
--			non_e_stringa_nulla: not (un_id ~ "")
		do
			id := un_id
			create transizioni.make_empty
			create onEntry.make_empty
			create onExit.make_empty
--		ensure
--			attributo_assegnato: id = un_id
		end

	make_final_with_id (un_id: STRING)
		require
			non_e_stringa_nulla: not (un_id ~ "")
		do
			make_with_id (un_id)
			set_final
			set_atomico
		ensure
			attributo_assegnato: id = un_id
			final_assegnato: finale = True
			lo_stato_e_atomico: stato_atomico = True
		end

feature --set

	set_final
		do
			finale := True
		end

	set_atomico
		do
			stato_atomico := True
		end
feature --situazione

	antenato_di (uno_stato: STATO):BOOLEAN
		do
			Result := false
		end

	ha_sottostati_attivi:BOOLEAN
		do
			Result := false
		end

feature --utilita

	stampa
		do
			print("--------------------%N")
			print("stato con id = " + id + "%N")
			if attached genitore as g then print("  genitore: " + g.id + "%N") end
		end
end
