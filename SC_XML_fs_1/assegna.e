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

	modifica_valore (variabili_booleane: HASH_TABLE [BOOLEAN, STRING]; variabili_intere: HASH_TABLE [INTEGER, STRING])
		deferred
		end

feature -- esecuzione

	esegui (variabili_booleane: HASH_TABLE [BOOLEAN, STRING]; variabili_intere: HASH_TABLE [INTEGER, STRING])
		do
			modifica_valore (variabili_booleane, variabili_intere)
		end

end
