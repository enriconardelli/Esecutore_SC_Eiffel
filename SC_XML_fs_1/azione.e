note
	description: "Summary description for {AZIONE}."
	author: "Gabriele Cacchioni & Davide Canalis & Daniele Fakhoury & Eloisa Scarsella"
	date: "9-04-2015"
	revision: "0"

deferred class
	AZIONE

feature -- generica

--	action (condizioni: HASH_TABLE [BOOLEAN, STRING])
--		deferred
--		end

	esegui (condizioni: HASH_TABLE [BOOLEAN, STRING]; valori_data: HASH_TABLE [INTEGER, STRING])
		deferred
		end

	svolgi (una_azione: PROCEDURE[])
		do
			una_azione.call
		end

end
