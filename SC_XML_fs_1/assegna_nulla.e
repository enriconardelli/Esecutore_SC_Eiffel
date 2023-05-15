note
	description: "La classe che rappresenta l'azione di assegnazione NON SPECIFICATA"
	author: "EN + studenti corsi PSI"
	date: "$Date$"
	revision: "$Revision$"

class
	ASSEGNA_NULLA

inherit

	ASSEGNA

create
	make_empty

feature

	make_empty
		do
			elemento_da_modificare := ""
		end

	modifica_valore (variabili: DATAMODEL)
		do
				-- la classe esiste affinché la feature crea_istanza di ASSEGNA possa restituire un valore attached
		end

end
