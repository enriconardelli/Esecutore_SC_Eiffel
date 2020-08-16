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

feature {NONE} -- supporto

	test_data_dir_local: STRING = "transizioni"

	on_prepare
		do
			precursor
			test_data_dir_local.append_character(a_path.directory_separator)
			nomi_files_prova [1] := test_data_dir + test_data_dir_local + "transizioni.xml"
			nomi_files_prova [2] := test_data_dir + test_data_dir_local
		end

feature -- Test routines

	t_transizioni_legali_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "transizioni_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( A1a A2b B1 )", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A1a") and conf_has_state(esecutore.state_chart.conf_base,"A2b") and conf_has_state(esecutore.state_chart.conf_base,"B1") )
		end

	t_transizioni_legali_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "transizioni_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( A1a A2b B1 )", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A1a") and conf_has_state(esecutore.state_chart.conf_base,"A2b") and conf_has_state(esecutore.state_chart.conf_base,"B1") )
		end

	t_transizioni_legali_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "transizioni_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( A1a A2b B2 )", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A1a") and conf_has_state(esecutore.state_chart.conf_base,"A2b") and conf_has_state(esecutore.state_chart.conf_base,"B2") )
		end

	t_transizioni_legali_4
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "transizioni_eventi_4.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( A1a A2b B2 )", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A1a") and conf_has_state(esecutore.state_chart.conf_base,"A2b") and conf_has_state(esecutore.state_chart.conf_base,"B2") )
		end

	t_transizioni_legali_5
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "transizioni_eventi_5.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( A1a A2b B2 )", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A1a") and conf_has_state(esecutore.state_chart.conf_base,"A2b") and conf_has_state(esecutore.state_chart.conf_base,"B2") )
		end

	t_transizioni_legali_6
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "transizioni_eventi_6.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( A1b A2b B2 )", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A1b") and conf_has_state(esecutore.state_chart.conf_base,"A2b") and conf_has_state(esecutore.state_chart.conf_base,"B2") )
		end

	t_transizioni_legali_7
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "transizioni_eventi_7.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( A1a X Y B2 )", esecutore.state_chart.conf_base.count = 4 and conf_has_state(esecutore.state_chart.conf_base,"A1a") and conf_has_state(esecutore.state_chart.conf_base,"X") and conf_has_state(esecutore.state_chart.conf_base,"Y") and conf_has_state(esecutore.state_chart.conf_base,"B2") )
		end

	t_transizioni_legali_8
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "transizioni_eventi_8.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( A1a X Y B2 )", esecutore.state_chart.conf_base.count = 4 and conf_has_state(esecutore.state_chart.conf_base,"A1a") and conf_has_state(esecutore.state_chart.conf_base,"X") and conf_has_state(esecutore.state_chart.conf_base,"Y") and conf_has_state(esecutore.state_chart.conf_base,"B2") )
		end

	t_transizioni_legali_9
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "transizioni_eventi_9.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( A1a X Z B2 )", esecutore.state_chart.conf_base.count = 4 and conf_has_state(esecutore.state_chart.conf_base,"A1a") and conf_has_state(esecutore.state_chart.conf_base,"X") and conf_has_state(esecutore.state_chart.conf_base,"Z") and conf_has_state(esecutore.state_chart.conf_base,"B2") )
		end

end


