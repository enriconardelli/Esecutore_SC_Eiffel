note
	description: "La classe che rappresenta gli eventi esterni cui la StateChar reagisce"
	author: ""
	date: "21/apr/2020"
	revision: "1.1"

class
	AMBIENTE

create
	make_empty --, make

feature -- Attributi

	eventi_esterni: ARRAY [LINKED_SET [STRING]]
			-- memorizza il file degli eventi esterni cui la SC reagisce
			-- l'array rappresenta tutti gli eventi mentre ogni linked_list
			-- l'insieme degli eventi che occorrono in uno stesso istante

feature --creazione

	make_empty
		do
			create eventi_esterni.make_empty
		end

feature

	acquisisci_eventi (nome_file_eventi: STRING)
			-- Legge gli eventi dal file passato come argomento e li inserisce in `eventi_esterni'

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
			across state_chart.stati as  scs
			loop
				if attached scs.item.transizioni as transizioni then
					across transizioni as  t
					loop
						if attached t.item.evento as e then
							eventi_nella_SC.put (True, e)
						end
					end
				end
			end

			-- verifica che ogni evento esterno sia presente nella SC
			-- TODO convertire from loop in across loop
--			across eventi_esterni as ee
			from
				i := eventi_esterni.lower
			until
				i = eventi_esterni.upper + 1
			loop
				-- TODO convertire from loop in across loop
				from
					j := eventi_esterni [i].lower
				until
					j = eventi_esterni [i].count + 1
				loop
					if attached eventi_esterni[i].i_th (j) as ei then
						if not eventi_nella_SC.has (ei) then
						print ("%NATTENZIONE: l'evento " + ei + " non viene utilizzato!%N")
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
