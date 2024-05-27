note
	description: "Summary description for {STORIA_SHALLOW}."
	author: "Arianna Calzuola & Riccardo Malandruccolo"
	date: "04/07/20"
	revision: "$Revision$"

class
	STORIA_SHALLOW

inherit

	STORIA

create
	make_history

feature -- attributi

	stato_memorizzato: detachable STATO

feature -- creazione


	make_history
		do

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
