note
	description: "Summary description for {STORIA_DEEP}."
	author: "Arianna Calzuola & Riccardo Malandruccolo"
	date: "04/07/20"
	revision: "$Revision$"

class
	STORIA_DEEP

inherit

	STORIA

create
	make_history

feature -- attributi

	stati_memorizzati: LINKED_LIST [STATO]

feature -- creazione

	make_history
		do
			create stati_memorizzati.make
		end

feature -- gestione storia

	aggiungi_stati (stati: LINKED_LIST [STATO])
		do
			across
				stati as st
			loop
				if not stati_memorizzati.has (st.item) then
					stati_memorizzati.extend (st.item)
				end
			end
		end

	svuota_memoria
		do
			stati_memorizzati.wipe_out
		end

	storia_vuota: BOOLEAN
		do
			Result :=  stati_memorizzati.is_empty
		end

end
