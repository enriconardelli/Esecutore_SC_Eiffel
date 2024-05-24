note
	description: "La classe che rappresenta gli eventi esterni cui la StateChar reagisce"
	author: "EN + studenti corsi PSI"
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
			-- l'insieme degli eventi che occorrono contemporaneamente, cioè
			-- nella stesso quanto di tempo rappresentato da una posizione dell'array

feature --creazione

	make_empty
		do
			create eventi_esterni.make_empty
		end

feature

	acquisisci_eventi (nome_file_eventi: STRING) :BOOLEAN
			-- Legge gli eventi dal file passato come argomento e li inserisce in `eventi_esterni'
		local
			file: PLAIN_TEXT_FILE
			i: INTEGER
			eventi_sulla_riga: LIST [STRING]
			eventi_contemporanei: LINKED_SET [STRING]
		do
			create file.make_with_name (nome_file_eventi)
			if file.exists then
				file.open_read
				from
					i := 1
				until
					file.off
				loop
					file.read_line
					eventi_sulla_riga := file.last_string.twin.split (' ')
					create eventi_contemporanei.make
					eventi_contemporanei.compare_objects
					across eventi_sulla_riga as er
					loop
						eventi_contemporanei.force (er.item)
					end
					eventi_esterni.force (eventi_contemporanei, i)
					i := i + 1
				end
				file.close
				Result := True
			else
				Result := False
			end
		end

	verifica_eventi_esterni(state_chart: CONFIGURAZIONE): BOOLEAN
			-- Verifica che tutti gli eventi nel file compaiano effettivamente tra gli eventi di qualche transizione
			-- Segnala l'eventuale presenza di eventi incompatibili
		local
			eventi_nella_SC: HASH_TABLE [BOOLEAN, STRING]
		do
			create eventi_nella_SC.make (0)
			-- inserisce tutti gli eventi definiti nella SC in eventi_nella_SC
			across state_chart.stati as  scs
			loop
				across scs.item.transizioni as  t
				loop
					if attached t.item.evento as e then
						eventi_nella_SC.put (True, e)
					end
				end
			end
			-- verifica che ogni evento esterno sia presente nella SC
			Result := true
			across eventi_esterni as ee
			loop
				across ee.item as ei
				loop
					if not eventi_nella_SC.has (ei.item) then
						print ("AVVISO: l'evento " + ei.item + " non viene utilizzato dalla statechart letta!%N")
						Result := false
					end
				end
			end
		end

end
