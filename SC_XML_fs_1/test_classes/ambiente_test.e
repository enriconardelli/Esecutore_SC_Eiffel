note
	description: "Summary description for {AMBIENTE_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AMBIENTE_TEST

inherit
	EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Supporto
	a_path: PATH
	test_data_dir: STRING
	altro_configurazione_prova, configurazione_prova: CONFIGURAZIONE

feature -- Test routines

	on_prepare
		do
			create a_path.make_current
			create test_data_dir.make_from_string ("test_data")
			test_data_dir.append_character(a_path.directory_separator)
			create configurazione_prova.make(test_data_dir + "tre_stati_atomici.xml")
			create altro_configurazione_prova.make(test_data_dir + "tre_stati_atomici.xml")
		end

feature -- Test routines

	test_verifica_eventi_esterni_1
		local
			ambiente: AMBIENTE
		do
			create ambiente.make_empty
			ambiente.acquisisci_eventi (test_data_dir + "tre_stati_atomici_eventi_6.txt")
			-- in "tre_stati_atomici_eventi_6.xml" ci sono eventi non noti alla SC
			assert("non viene rilevato evento esterno assente",ambiente.verifica_eventi_esterni(configurazione_prova)=False)
		end

	test_verifica_eventi_esterni_2
		local
			ambiente: AMBIENTE
		do
			create ambiente.make_empty
			ambiente.acquisisci_eventi (test_data_dir + "tre_stati_atomici_eventi_5.txt")
			-- tutti gli eventi in "tre_stati_atomici_eventi_5.xml" sono noti alla SC
			assert("viene falsamente rilevato assenza di evento esterno assente",ambiente.verifica_eventi_esterni(altro_configurazione_prova)=True)
		end

end
