note
	description: "La classe generica per il contenuto eseguibile"
	author: "EN + studenti corsi PSI"
	date: "$Date$"
	revision: "0"

deferred class
	AZIONE

feature -- generica

--	action (condizioni: HASH_TABLE [BOOLEAN, STRING])
--		deferred
--		end

	esegui (variabili_booleane: HASH_TABLE [BOOLEAN, STRING]; variabili_intere: HASH_TABLE [INTEGER, STRING])
		deferred
		end

	svolgi (una_azione: PROCEDURE[])
	-- TODO: da rimuovere perché si implementa semplicemente esegui nelle sottoclassi
		do
			una_azione.call
		end

end
