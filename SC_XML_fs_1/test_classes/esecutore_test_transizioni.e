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

	esecutore: detachable ESECUTORE

	t_transizioni_legali_1
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "transizioni_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			if attached esecutore as e then
				assert ("ERRORE il sistema non termina negli stati corretti ( A1a A2b B1 )", e.conf_base_corrente.count = 3 and conf_has_state(e.conf_base_corrente,"A1a") and conf_has_state(e.conf_base_corrente,"A2b") and conf_has_state(e.conf_base_corrente,"B1") )
			end
		end

	t_transizioni_legali_2
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "transizioni_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			if attached esecutore as e then
				assert ("ERRORE il sistema non termina negli stati corretti ( A1a A2b B1 )", e.conf_base_corrente.count = 3 and conf_has_state(e.conf_base_corrente,"A1a") and conf_has_state(e.conf_base_corrente,"A2b") and conf_has_state(e.conf_base_corrente,"B1") )
			end
		end

	t_transizioni_legali_3
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "transizioni_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			if attached esecutore as e then
				assert ("ERRORE il sistema non termina negli stati corretti ( A1a A2b B2 )", e.conf_base_corrente.count = 3 and conf_has_state(e.conf_base_corrente,"A1a") and conf_has_state(e.conf_base_corrente,"A2b") and conf_has_state(e.conf_base_corrente,"B2") )
			end
		end

	t_transizioni_legali_4
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "transizioni_eventi_4.txt"
			create esecutore.make (nomi_files_prova)
			if attached esecutore as e then
				assert ("ERRORE il sistema non termina negli stati corretti ( A1a A2b B2 )", e.conf_base_corrente.count = 3 and conf_has_state(e.conf_base_corrente,"A1a") and conf_has_state(e.conf_base_corrente,"A2b") and conf_has_state(e.conf_base_corrente,"B2") )
			end
		end

	t_transizioni_legali_5
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "transizioni_eventi_5.txt"
			create esecutore.make (nomi_files_prova)
			if attached esecutore as e then
				assert ("ERRORE il sistema non termina negli stati corretti ( A1a A2b B2 )", e.conf_base_corrente.count = 3 and conf_has_state(e.conf_base_corrente,"A1a") and conf_has_state(e.conf_base_corrente,"A2b") and conf_has_state(e.conf_base_corrente,"B2") )
			end
		end

	t_transizioni_legali_6
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "transizioni_eventi_6.txt"
			create esecutore.make (nomi_files_prova)
			if attached esecutore as e then
				assert ("ERRORE il sistema non termina negli stati corretti ( A1b A2b B2 )", e.conf_base_corrente.count = 3 and conf_has_state(e.conf_base_corrente,"A1b") and conf_has_state(e.conf_base_corrente,"A2b") and conf_has_state(e.conf_base_corrente,"B2") )
			end
		end

	t_transizioni_legali_7
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "transizioni_eventi_7.txt"
			create esecutore.make (nomi_files_prova)
			if attached esecutore as e then
				assert ("ERRORE il sistema non termina negli stati corretti ( A1a X Y B2 )", e.conf_base_corrente.count = 4 and conf_has_state(e.conf_base_corrente,"A1a") and conf_has_state(e.conf_base_corrente,"X") and conf_has_state(e.conf_base_corrente,"Y") and conf_has_state(e.conf_base_corrente,"B2") )
			end
		end

	t_transizioni_legali_8
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "transizioni_eventi_8.txt"
			create esecutore.make (nomi_files_prova)
			if attached esecutore as e then
				assert ("ERRORE il sistema non termina negli stati corretti ( A1a X Y B2 )", e.conf_base_corrente.count = 4 and conf_has_state(e.conf_base_corrente,"A1a") and conf_has_state(e.conf_base_corrente,"X") and conf_has_state(e.conf_base_corrente,"Y") and conf_has_state(e.conf_base_corrente,"B2") )
			end
		end

	t_transizioni_legali_9
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "transizioni_eventi_9.txt"
			create esecutore.make (nomi_files_prova)
			if attached esecutore as e then
				assert ("ERRORE il sistema non termina negli stati corretti ( A1a X Z B2 )", e.conf_base_corrente.count = 4 and conf_has_state(e.conf_base_corrente,"A1a") and conf_has_state(e.conf_base_corrente,"X") and conf_has_state(e.conf_base_corrente,"Z") and conf_has_state(e.conf_base_corrente,"B2") )
			end
		end

end


