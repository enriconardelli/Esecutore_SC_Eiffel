note
	description: "Summary description for {CONFIGURAZIONE_TEST_SINTASSI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONFIGURAZIONE_TEST_SINTASSI

inherit
	EQA_TEST_SET

feature -- Test routines

	t_scxml_sintassi
		local
			n: INTEGER
		do
			from
				n := 1
			until
				n = 28
			loop
				test_singolo(n)
				n:= n+1
			end

		end

	test_singolo(n: INTEGER)
		local
			nomi_files_prova: STRING
			configurazione_prova: CONFIGURAZIONE
			a_path: PATH
			test_data_dir: STRING
		do
		    create a_path.make_current
		    create test_data_dir.make_from_string ("test_data")
			test_data_dir.append_character(a_path.directory_separator)
			nomi_files_prova := test_data_dir + "scxml_errato"+n.out+".xml"
			create configurazione_prova.make (nomi_files_prova)

			assert("ERRORE "+ n.out + " scxml non rilevato correttamente", configurazione_prova.errore_costruzione_SC.has (n))
		end

end
