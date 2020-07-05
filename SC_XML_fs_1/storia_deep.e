note
	description: "Summary description for {STORIA_DEEP}."
	author: "Arianna Calzuola & Riccardo Malandruccolo"
	date: "$Date$"
	revision: "$Revision$"

class
	STORIA_DEEP

inherit

	STORIA

create
	make_history_with_id, make_history

feature -- attributi

	stati_memorizzati: ARRAY [STATO]

feature -- creazione

	make_history_with_id (un_id: STRING; un_genitore: STATO_XOR)
		do
			create stati_memorizzati.make_empty
			genitore := un_genitore
			id := un_id
		end

	make_history (un_genitore: STATO_XOR)
		do
			create stati_memorizzati.make_empty
			genitore := un_genitore
		end

feature -- gestione storia

	aggiungi_stati (stati: ARRAY [STATO])
		do
			across
				stati as st
			loop
				if not stati_memorizzati.has (st.item) then
					stati_memorizzati.force (st.item, stati_memorizzati.upper + 1)
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
