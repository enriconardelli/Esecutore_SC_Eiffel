note
	description: "Summary description for {ESECUTORE_TEST_TRANSIZIONI_MERGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE_TEST_TRANSIZIONI_MERGE

inherit
	ESECUTORE_TEST

feature --test

	t_costrutto_merge_1
	 --Maria Ludovica Sarandrea, 23/05/2021
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_merge_1.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_merge_eventi_con_merge.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto S", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"S"))
		end

	t_costrutto_merge_1_1
	 --Maria Ludovica Sarandrea, 23/05/2021
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_merge_1.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_merge_eventi_non_merge.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto S", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"S"))
		end

	t_costrutto_merge_2
	 --Maria Ludovica Sarandrea, 23/05/2021
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_merge_2.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_merge_eventi_con_merge.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti S1 S2", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"S2"))
		end

	t_costrutto_merge_3
	 --Maria Ludovica Sarandrea, 23/05/2021
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_merge_3.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_merge_eventi_con_merge.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto S", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"S"))
		end

	t_costrutto_merge_3_1
	 --Maria Ludovica Sarandrea, 23/05/2021
	 	local
	 		conf_finale : LINKED_SET[STRING]
		do
			create conf_finale.make
			conf_finale.force("S")
			evoluzione_state_chart("costrutto_merge_3.xml", "costrutto_merge_eventi_non_merge.txt", conf_finale)
		end

	t_costrutto_merge_4
	 --Maria Ludovica Sarandrea, 23/05/2021
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_merge_4.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_merge_eventi_con_merge.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto S", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"S"))
		end

	t_costrutto_merge_4_1
	 --Maria Ludovica Sarandrea, 23/05/2021
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_merge_4.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_merge_eventi_non_merge.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto S", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"S"))
		end

	t_costrutto_merge_6
	 -- Sara Forte, 25/05/2021
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_merge_6.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_merge_eventi_con_merge.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto S", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"A1") and conf_has_state(esecutore.state_chart.conf_base,"C2"))
		end

	t_costrutto_merge_8
	 -- Sara Forte, 25/05/2021
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_merge_8.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_merge_eventi_con_merge.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto S", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"S"))
		end

	t_costrutto_merge_10
	 -- Sara Forte, 25/05/2021
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_merge_10.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_merge_eventi_con_merge.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto S", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"S"))
		end

-- RISOLVERE: a transizione_multitarget_ammissibile bisognerebbe passare un argomento di tipo LIST[READABLE_STRING_32], ma come fare?
--	t_costrutto_merge_non_ammissibile_2
--	 --Maria Ludovica Sarandrea, 23/05/2021
--		local
--			esecutore: ESECUTORE
--		do
--			nomi_files_prova [1] := test_data_dir + "costrutto_merge_non_ammissibile_2.xml"
--			nomi_files_prova [2] := test_data_dir + "costrutto_merge_eventi_con_merge.txt"
--			create esecutore.make (nomi_files_prova)
--			assert ("ERRORE il sistema non riconosce che la configurazione di stati non è ammissibile per il costrutto merge", not esecutore.state_chart.transizione_multitarget_ammissibile (??)
--		end

--	t_costrutto_merge_non_ammissibile_3
--	 --Maria Ludovica Sarandrea, 23/05/2021
--		local
--			esecutore: ESECUTORE
--		do
--			nomi_files_prova [1] := test_data_dir + "costrutto_merge_non_ammissibile_3.xml"
--			nomi_files_prova [2] := test_data_dir + "costrutto_merge_eventi_con_merge.txt"
--			create esecutore.make (nomi_files_prova)
--			assert ("ERRORE il sistema non riconosce che la configurazione di stati non è ammissibile per il costrutto merge", not esecutore.state_chart.transizione_multitarget_ammissibile (??)
--		end

end
