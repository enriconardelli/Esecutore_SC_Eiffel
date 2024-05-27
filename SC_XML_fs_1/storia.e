note
	description: "Summary description for {STORIA}."
	author: "Arianna Calzuola & Riccardo Malandruccolo"
	date: "04/07/20"
	revision: "$Revision$"

deferred class
	STORIA

feature -- creazione

	make_history 
		deferred
		end

	svuota_memoria
		deferred
		end

	storia_vuota: BOOLEAN
		deferred
		end

end
