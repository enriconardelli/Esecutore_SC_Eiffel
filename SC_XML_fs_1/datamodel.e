note
	description: "Summary description for {DATAMODEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DATAMODEL

create
	make

feature -- attributi

	booleane: HASH_TABLE [BOOLEAN, STRING]
		-- rappresenta le variabili (cioè i <data> del <datamodel>) di tipo booleano e il loro valore

	intere: HASH_TABLE [INTEGER, STRING]
		-- rappresenta le variabili (cioè i <data> del <datamodel>) di tipo intero e il loro valore

	-- altre variabili da aggiungere, p.es. stringhe

feature -- creazione

	make
		do
			create booleane.make (1)
			create intere.make (1)
		end



end
