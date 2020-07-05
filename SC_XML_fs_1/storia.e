note
	description: "Summary description for {STORIA}."
	author: "Arianna Calzuola & Riccardo Malandruccolo"
	date: "04/07/20"
	revision: "$Revision$"

deferred class
	STORIA

feature -- attributi

	genitore: STATO_XOR

	id: detachable STRING

feature -- creazione

	make_history_with_id (un_id: STRING; un_genitore: STATO_XOR)
		deferred
		end

	make_history (un_genitore: STATO_XOR)
		deferred
		end

	svuota_memoria
		deferred
		end

	storia_vuota: BOOLEAN
		deferred
		end

end
