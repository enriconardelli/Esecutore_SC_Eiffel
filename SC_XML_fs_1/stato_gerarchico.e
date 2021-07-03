note
	description: "Summary description for {STATO_GERARCHICO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STATO_GERARCHICO

inherit
	PROVVISORIO

--create
--	make_with_id, make_with_id_and_parent

feature
	initial: ARRAY [STATO]
--		 il figlio iniziale di default (tutti i figli nel caso di STATO_AND)


	figli: ARRAY [STATO]
--		 gli stati figli dello stato corrente

	storia: detachable STORIA

feature

	make_with_id (un_id: STRING)
--		require
--			non_e_stringa_nulla: not (un_id ~ "")
		do
			id := un_id
			create initial.make_empty
			create figli.make_empty
			create transizioni.make_empty
			create onEntry.make_empty
			create onExit.make_empty
--		ensure
--			attributo_assegnato: id = un_id
		end

feature --set

	set_final
		do
			finale := False
		end

	set_atomico
		do
			stato_atomico := False
		end

	set_initial
		deferred
		end

feature -- modifica

	add_figlio (uno_stato: STATO)
		do
			figli.force (uno_stato, figli.count + 1)
		end

	add_storia (una_storia: STORIA)
		do
			storia := una_storia
		end
feature --situazione

	antenato_di (uno_stato: STATO):BOOLEAN
		do
			Result := True
		end

	ha_sottostati_attivi:BOOLEAN
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

feature --utilita

	stampa
	do
		print("--------------------%N")
		print("stato con id = " + id + "%N")
		if attached genitore as g then print("  genitore: " + g.id + "%N") end
		if not initial.is_empty then
			print("  initial: ")
			across initial as i
			loop print(i.item.id + ", ")
			end
			print("%N")
		end
		if not figli.is_empty then
			print("  figli: ")
			across figli as f
			loop print (f.item.id + ", ")
			end
			print("%N")
		end
	end
end
