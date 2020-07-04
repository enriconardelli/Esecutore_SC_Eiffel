note
	description: "Summary description for {STORIA_SHALLOW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STORIA_SHALLOW

inherit
	STORIA

create
	make_history

feature

	stato_memorizzato: detachable STATO

feature

	make_history (un_id: STRING; un_genitore: STATO)
	do
		genitore := un_genitore
		id := un_id
	end

feature

	memorizza_stato(stato: STATO)
	do
		stato_memorizzato := stato
	end

	svuota_memoria
	do
		stato_memorizzato := void
	end

	storia_vuota: BOOLEAN
	do
		Result := not attached stato_memorizzato
	end

end
