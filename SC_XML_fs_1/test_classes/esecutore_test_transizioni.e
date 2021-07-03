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

	evoluzione_state_chart_local(eventi: STRING; stati_corretti: LINKED_SET[STRING])
		do
			test_data_dir_local.append_character(a_path.directory_separator)
			evoluzione_state_chart(test_data_dir_local + "transizioni.xml",test_data_dir_local + eventi,stati_corretti)

		end

feature -- Test routines
	on_prepare
		do
			Precursor
			create conf_finale.make
		end
	t_transizioni_legali_1

		do 	conf_finale.force("A1a")
			conf_finale.force("A2b")
			conf_finale.force("B1")
			evoluzione_state_chart_local("transizioni_eventi_1.txt", conf_finale)
		end


	t_transizioni_legali_2
	do
 		conf_finale.force("A1a")
		conf_finale.force("A2b")
		conf_finale.force("B1")
		evoluzione_state_chart_local("transizioni_eventi_2.txt", conf_finale)
	end

	t_transizioni_legali_3
	do
 		conf_finale.force("A1a")
		conf_finale.force("A2b")
		conf_finale.force("B2")
		evoluzione_state_chart_local("transizioni_eventi_3.txt", conf_finale)
	end

	t_transizioni_legali_4
	do
 		conf_finale.force("A1a")
		conf_finale.force("A2b")
		conf_finale.force("B2")
		evoluzione_state_chart_local("transizioni_eventi_4.txt", conf_finale)
	end

	t_transizioni_legali_5
	do
 		conf_finale.force("A1a")
		conf_finale.force("A2b")
		conf_finale.force("B2")
		evoluzione_state_chart_local("transizioni_eventi_5.txt", conf_finale)
	end

	t_transizioni_legali_6
	do
 		conf_finale.force("A1b")
		conf_finale.force("A2b")
		conf_finale.force("B2")
		evoluzione_state_chart_local("transizioni_eventi_6.txt", conf_finale)
	end

	t_transizioni_legali_7
	do
 		conf_finale.force("A1a")
		conf_finale.force("X")
		conf_finale.force("Y")
		conf_finale.force("B2")
		evoluzione_state_chart_local("transizioni_eventi_7.txt", conf_finale)
	end

	t_transizioni_legali_8
	do
 		conf_finale.force("A1a")
		conf_finale.force("X")
		conf_finale.force ("Y")
		conf_finale.force("B2")
		evoluzione_state_chart_local("transizioni_eventi_8.txt", conf_finale)
	end

	t_transizioni_legali_9
	do
 		conf_finale.force("A1a")
		conf_finale.force("X")
		conf_finale.force("Z")
		conf_finale.force("B2")
		evoluzione_state_chart_local("transizioni_eventi_9.txt", conf_finale)
	end

end


