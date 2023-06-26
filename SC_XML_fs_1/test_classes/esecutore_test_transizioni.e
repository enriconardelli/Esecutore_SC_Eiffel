note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	ESECUTORE_TEST_TRANSIZIONI

inherit

	ESECUTORE_TEST
		redefine
			on_prepare
		end

feature {NONE} -- Supporto

	conf_finale: LINKED_SET [STRING]

	test_data_dir_local: STRING = "transizioni"

	evoluzione_state_chart_local (eventi: STRING; stati_corretti: LINKED_SET [STRING])
		do
			test_data_dir_local.append_character (a_path.directory_separator)
			evoluzione_state_chart (test_data_dir_local + "transizioni_legali.xml", test_data_dir_local + eventi, stati_corretti)
		end

feature -- Test routines

	on_prepare
		do
			Precursor
			create conf_finale.make
		end

	t_transizioni_legali
		do
			conf_finale.force ("A1a")
			conf_finale.force ("W")
			conf_finale.force ("Z")
			conf_finale.force ("B1")
			evoluzione_state_chart_local ("transizioni_legali_eventi_1.txt", conf_finale)
		end

		-- TODO: il file nella directory generale di test ""transizioni_legali_illegali"" contiene anche
		--       transizioni_illegali e non si può mandare testare così com'è perché le transizioni illegali
		--       impediscono la successiva esecuzione della SC

	t_transizioni_cond_in_stato
		do
			
		end

end
