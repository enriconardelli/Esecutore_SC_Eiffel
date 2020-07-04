note
	description: "Summary description for {STORIA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STORIA

feature

	genitore: STATO_XOR

	id: detachable STRING

feature

	svuota_memoria
	deferred
	end

	storia_vuota: BOOLEAN
	deferred
	end

end
