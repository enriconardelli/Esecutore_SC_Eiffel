note
	description: "Summary description for {STORIA_SHALLOW}."
	author: "Arianna Calzuola & Riccardo Malandruccolo"
	date: "$Date$"
	revision: "$Revision$"

class
	STORIA_SHALLOW

inherit

	STORIA

create
	make_history_with_id, make_history

feature -- attributi

	stato_memorizzato: detachable STATO

feature -- creazione

	make_history_with_id (un_id: STRING; un_genitore: STATO_XOR)
		do
			genitore := un_genitore
			id := un_id
		end

	make_history (un_genitore: STATO_XOR)
		do
			genitore := un_genitore
		end

feature -- gestione storia

	memorizza_stato (stato: STATO)
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
