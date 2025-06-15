note
	description: "Summary description for {CONDIZIONE}."
	author: "Marco Aragona & Gabriele Messina"
	date: "$Date$"
	revision: "$Revision$"

class
	CONDIZIONE

create
	set_null

feature -- attributi
	is_null:BOOLEAN
	variabile: STRING

feature
	set_null
		do
			is_null:=True
			variabile:="NULL"
	end
end

