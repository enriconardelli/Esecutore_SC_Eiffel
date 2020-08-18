note
	description: "La classe astratta che rappresenta l'azione di assegnazione"
	author: "EN + studenti corsi PSI"
	date: "$Date$"
	revision: "0"

deferred class
	ASSEGNA

inherit
	AZIONE

feature -- attributi

	elemento_da_modificare: STRING
		-- id della variabile

feature -- modifica

	modifica_valore (variabili: DATAMODEL)
		deferred
		end

feature -- esecuzione

	esegui (variabili: DATAMODEL)
		do
			modifica_valore (variabili)
		end

end
