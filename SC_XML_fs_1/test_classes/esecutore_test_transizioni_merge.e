note
	description: "Summary description for {ESECUTORE_TEST_TRANSIZIONI_MERGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE_TEST_TRANSIZIONI_MERGE

inherit
	ESECUTORE_TEST
	redefine
		on_prepare
	end

feature {NONE} -- Supporto

	conf_finale: LINKED_SET [STRING]

feature --test
	on_prepare
		do
			Precursor
			create conf_finale.make
		end

	t_costrutto_merge_1
	 --Maria Ludovica Sarandrea, 23/05/2021
	 -- EN, 24/08/2021
		do
			conf_finale.force("A1")
			conf_finale.force("B1")
			evoluzione_state_chart("costrutto_merge_1.xml", "costrutto_merge_eventi_con_merge.txt", conf_finale)
		end

	t_costrutto_merge_1_bis
	 -- EN, 24/08/2021
		do
			conf_finale.force("S")
			evoluzione_state_chart("costrutto_merge_1_bis.xml", "costrutto_merge_eventi_con_merge.txt", conf_finale)
		end

	t_costrutto_merge_1_1
	 --Maria Ludovica Sarandrea, 23/05/2021
		do
			conf_finale.force("S")
			evoluzione_state_chart("costrutto_merge_1.xml", "costrutto_merge_eventi_non_merge.txt", conf_finale)
		end

	t_costrutto_merge_2
	 --Maria Ludovica Sarandrea, 23/05/2021
	 -- EN, 24/08/2021
		do
			conf_finale.force("A")
			conf_finale.force("B1a")
			conf_finale.force("C2")
			evoluzione_state_chart("costrutto_merge_2.xml", "costrutto_merge_eventi_con_merge.txt", conf_finale)
		end

	t_costrutto_merge_2_bis
	 -- EN, 24/08/2021
		do
			conf_finale.force("S1")
			conf_finale.force("S2")
			evoluzione_state_chart("costrutto_merge_2_bis.xml", "costrutto_merge_eventi_con_merge.txt", conf_finale)
		end

	t_costrutto_merge_2_ter
	 -- EN, 24/08/2021
		do
			conf_finale.force("S1")
			conf_finale.force("S2")
			evoluzione_state_chart("costrutto_merge_2_ter.xml", "costrutto_merge_eventi_con_merge.txt", conf_finale)
		end

	t_costrutto_merge_2_ter_1
	 -- EN, 24/08/2021
		do
			conf_finale.force("A")
			conf_finale.force("B1a")
			conf_finale.force("C2")
			evoluzione_state_chart("costrutto_merge_2_ter.xml", "costrutto_merge_eventi_non_merge.txt", conf_finale)
		end

	t_costrutto_merge_3
	 --Maria Ludovica Sarandrea, 23/05/2021
	 -- EN, 24/08/2021
			do
				conf_finale.force("A")
				conf_finale.force("B1")
				conf_finale.force("B21")
				evoluzione_state_chart("costrutto_merge_3.xml", "costrutto_merge_eventi_con_merge.txt", conf_finale)
			end

	t_costrutto_merge_3_1
	 --Maria Ludovica Sarandrea, 23/05/2021
	 -- EN, 24/08/2021
		do
				conf_finale.force("S")
			evoluzione_state_chart("costrutto_merge_3.xml", "costrutto_merge_eventi_non_merge.txt", conf_finale)
		end

	t_costrutto_merge_3_bis
	 -- EN, 24/08/2021
			do
				conf_finale.force("S")
				evoluzione_state_chart("costrutto_merge_3_bis.xml", "costrutto_merge_eventi_con_merge.txt", conf_finale)
			end

	t_costrutto_merge_3_bis_1
	 -- EN, 24/08/2021
			do
				conf_finale.force("S")
				evoluzione_state_chart("costrutto_merge_3_bis.xml", "costrutto_merge_eventi_non_merge.txt", conf_finale)
			end

	t_costrutto_merge_4
	 --Maria Ludovica Sarandrea, 23/05/2021
	 -- EN, 24/08/2021
			do
				conf_finale.force("A")
				conf_finale.force("B11")
				conf_finale.force("B21")
				evoluzione_state_chart("costrutto_merge_4.xml", "costrutto_merge_eventi_con_merge.txt", conf_finale)
			end

	t_costrutto_merge_4_1
	 --Maria Ludovica Sarandrea, 23/05/2021
			do
				conf_finale.force("S")
				evoluzione_state_chart("costrutto_merge_4.xml", "costrutto_merge_eventi_non_merge.txt", conf_finale)
			end

	t_costrutto_merge_4_bis
	 -- EN, 24/08/2021
			do
				conf_finale.force("S")
				evoluzione_state_chart("costrutto_merge_4_bis.xml", "costrutto_merge_eventi_con_merge.txt", conf_finale)
			end

	t_costrutto_merge_4_bis_1
	 -- EN, 24/08/2021
			do
				conf_finale.force("S")
				evoluzione_state_chart("costrutto_merge_4_bis.xml", "costrutto_merge_eventi_non_merge.txt", conf_finale)
			end

	t_costrutto_merge_4_ter
	 -- EN, 24/08/2021
			do
				conf_finale.force("A")
				conf_finale.force("B12")
				conf_finale.force("B21")
				evoluzione_state_chart("costrutto_merge_4_ter.xml", "costrutto_merge_eventi_con_merge.txt", conf_finale)
			end

	t_costrutto_merge_4_ter_1
	 -- EN, 24/08/2021
			do
				conf_finale.force("S")
				evoluzione_state_chart("costrutto_merge_4_ter.xml", "costrutto_merge_eventi_non_merge.txt", conf_finale)
			end

	t_costrutto_merge_6
	 -- Sara Forte, 25/05/2021
			do
				conf_finale.force("A1")
				conf_finale.force("C2")
				evoluzione_state_chart("costrutto_merge_6.xml", "costrutto_merge_eventi_con_merge.txt", conf_finale)
			end

	t_costrutto_merge_8
	 -- Sara Forte, 25/05/2021
			do
				conf_finale.force("S")
				evoluzione_state_chart("costrutto_merge_8.xml", "costrutto_merge_eventi_con_merge.txt", conf_finale)
			end

	t_costrutto_merge_10
	 -- Sara Forte, 25/05/2021
			do
				conf_finale.force("A111")
				conf_finale.force("A12")
				conf_finale.force("B1a")
				conf_finale.force("B21")
				conf_finale.force("B22")
				conf_finale.force("B31")
				conf_finale.force("C11")
				conf_finale.force("C21")
				evoluzione_state_chart("costrutto_merge_10.xml", "costrutto_merge_eventi_con_merge.txt", conf_finale)
			end

--	t_costrutto_merge_non_ammissibile
--	 -- EN, 24/08/2021
--	 	local
--			esecutore: ESECUTORE
--			configurazione: LINKED_LIST [STRING]
--		do
--			nomi_files_prova [1] := test_data_dir + "costrutto_merge_non_ammissibile.xml"
--			nomi_files_prova [2] := test_data_dir + "costrutto_merge_eventi_con_merge.txt"
--			create esecutore.make (nomi_files_prova)
--			create configurazione.make
--			configurazione.extend ("A")
--			configurazione.extend ("B")
--			assert ("ERRORE il sistema non riconosce che la configurazione di stati non è ammissibile per il costrutto merge", not esecutore.state_chart.transizione_multitarget_ammissibile (configurazione))
--		end

-- RISOLVERE: a transizione_multitarget_ammissibile bisognerebbe passare un argomento di tipo LIST[READABLE_STRING_32], ma come fare?
--	t_costrutto_merge_non_ammissibile_2
--	 --Maria Ludovica Sarandrea, 23/05/2021
--		
--			esecutore: ESECUTORE
--		do
--			nomi_files_prova [1] := test_data_dir + "costrutto_merge_non_ammissibile_2.xml"
--			nomi_files_prova [2] := test_data_dir + "costrutto_merge_eventi_con_merge.txt"
--			create esecutore.make (nomi_files_prova)
--			assert ("ERRORE il sistema non riconosce che la configurazione di stati non è ammissibile per il costrutto merge", not esecutore.state_chart.transizione_multitarget_ammissibile (??)
--		end

--	t_costrutto_merge_non_ammissibile_3
--	 --Maria Ludovica Sarandrea, 23/05/2021
--		
--			esecutore: ESECUTORE
--		do
--			nomi_files_prova [1] := test_data_dir + "costrutto_merge_non_ammissibile_3.xml"
--			nomi_files_prova [2] := test_data_dir + "costrutto_merge_eventi_con_merge.txt"
--			create esecutore.make (nomi_files_prova)
--			assert ("ERRORE il sistema non riconosce che la configurazione di stati non è ammissibile per il costrutto merge", not esecutore.state_chart.transizione_multitarget_ammissibile (??)
--		end

end
