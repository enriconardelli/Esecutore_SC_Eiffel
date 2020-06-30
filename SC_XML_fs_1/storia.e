note
	description: "Summary description for {STORIA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STORIA

create
	make_history, make_deep_history

feature

	stati_memorizzati: ARRAY[STATO]

	genitore: STATO

	deep: BOOLEAN

	id: STRING

feature

	make_history (un_id: STRING; un_genitore: STATO)
	do
		create stati_memorizzati.make_empty
		genitore := un_genitore
		id := un_id
	end

	make_deep_history (un_id: STRING; un_genitore: STATO)
	do
		deep := true
		make_history (un_id, un_genitore)
	end

feature

	memorizza_stati (stati: ARRAY[STATO])
	do
		stati_memorizzati.copy(stati)
	end

	svuota_memoria
	do
		stati_memorizzati.make_empty
	end

end
