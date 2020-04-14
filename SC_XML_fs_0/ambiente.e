note
	description: "Summary description for {AMBIENTE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AMBIENTE

create
	make_empty --, make

feature -- Attributi

	eventi_esterni: ARRAY [LINKED_SET [STRING]]
			-- memorizza gli eventi letti dal file
			-- l'array rappresenta gli istanti mentre ogni linked_list l'insieme degli eventi che occorrono nell'istante specifico

feature --creazione

	make_empty
		do
			create eventi_esterni.make_empty
		end

feature

	acquisisci_eventi (nome_file_eventi: STRING)
			-- Legge gli eventi dal file passato come secondo argomento e li inserisce in `eventi_esterni'

		local
			file: PLAIN_TEXT_FILE
			i: INTEGER
			events_read: LIST [STRING]
			istante: LINKED_SET [STRING]
		do
			create file.make_open_read (nome_file_eventi)
			from
				i := 1
			until
				file.off
			loop
				file.read_line
				events_read := file.last_string.twin.split (' ')
				create istante.make
				istante.compare_objects
				across
					events_read as er
				loop
					istante.force (er.item)
				end
				eventi_esterni.force (istante, i)
				i := i + 1
			end
			file.close
		end

	verifica_eventi_esterni(state_chart: CONFIGURAZIONE): BOOLEAN
			-- Verifica che tutti gli eventi nel file compaiano effettivamente tra gli eventi di qualche transizione
			-- Segnala l'eventuale presenza di eventi incompatibili
		local
			eventi_nella_SC: HASH_TABLE [BOOLEAN, STRING]
			i, j: INTEGER
			evento_assente: BOOLEAN
		do
			create eventi_nella_SC.make (0)
				-- inserisce tutti gli eventi definiti nella SC in eventi_nella_SC
			from
				state_chart.stati.start
			until
				state_chart.stati.after
			loop
				if attached state_chart.stati.item_for_iteration.transizioni as tr then
					from
						j := 1
					until
						j = tr.count + 1
					loop
						if attached tr [j].evento as e then
							eventi_nella_SC.put (True, e)
						end
						j := j + 1
					end
				end
				state_chart.stati.forth
			end
				-- verifica che ogni evento esterno sia presente nella SC
			from
				i := eventi_esterni.lower
			until
				i = eventi_esterni.upper + 1
			loop
				from
					j := eventi_esterni [i].lower
				until
					j = eventi_esterni [i].count + 1
				loop
					if attached eventi_esterni[i].i_th (j) as ei then
						if not eventi_nella_SC.has (ei) then
						print ("%N ATTENZIONE!! l'evento" + ei + "non viene utilizzato!")
						evento_assente := True
						end
					end
					j := j + 1
				end
				i := i + 1
			end
			Result := not evento_assente
		end

end
