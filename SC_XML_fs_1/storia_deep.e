note
	description: "Summary description for {STORIA_DEEP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STORIA_DEEP

inherit
	STORIA

create
	make_history

feature

	stati_memorizzati: ARRAY[STATO]

feature

	make_history (un_id: STRING; un_genitore: STATO)
	do
		create stati_memorizzati.make_empty
		genitore := un_genitore
		id := un_id
	end

	aggiungi_stati(stati: ARRAY[STATO])
	do
		across
			stati as st
		loop
			if not stati_memorizzati.has (st.item) then
				stati_memorizzati.force(st.item, stati_memorizzati.upper + 1)
			end
		end
	end

	svuota_memoria
	do
		stati_memorizzati.make_empty
	end

	storia_vuota: BOOLEAN
	do
		Result := stati_memorizzati.is_empty
	end
end
