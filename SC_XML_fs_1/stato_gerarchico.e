note
	description: "Summary description for {STATO_GERARCHICO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STATO_GERARCHICO

inherit
	STATO
		redefine
			stampa
		end

feature --situazione

	add_figlio (uno_stato: STATO)
		do
			figli.force (uno_stato, figli.count + 1)
		end

	antenato_di (uno_stato: STATO): BOOLEAN
			-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
			-- controlla se il Current è antenato "proprio" di `uno_stato`
		do
			if attached uno_stato.genitore as sg then
				if sg = Current then
					Result := True
				else
					Result := antenato_di (sg)
				end
			else
				Result := False
			end
		end


	ha_sottostati_attivi:BOOLEAN
	--Filippo & Iezzi 30/09/2020
		do
			Result:= False
			across figli as f
			loop
				if f.item.attivo then
					Result:=True
				else
					if f.item.figli.count>0 and Result=False then
						Result:=f.item.ha_sottostati_attivi
					end
				end
			end
		end

feature --utilità

	stampa
		do
			Precursor {STATO}
			if not initial.is_empty then
				print (" initial: ")
				across
					initial as i
				loop
					print (i.item.id + ", ")
				end
				print ("%N")
			end
			if not figli.is_empty then
				print (" figli: ")
				across
					figli as f
				loop
					print (f.item.id + ", ")
				end
				print ("%N")
			end
		end

end


