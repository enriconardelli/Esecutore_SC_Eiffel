note
	description: "Summary description for {CONDIZIONE_VUOTA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE_VUOTA

inherit
	CONDIZIONE

create
	make

feature

	make
	do
		variabile := "NULL"
	end
end
