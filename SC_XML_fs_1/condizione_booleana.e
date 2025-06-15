note
	description: "Summary description for {CONDIZIONE_BOOELANA}."
	author: "Marco Aragona & Gabriele Messina"
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE_BOOLEANA

inherit
	CONDIZIONE

create
	make

feature
	make(variabile_input: STRING)
		do
		variabile:=variabile_input
	end
end

