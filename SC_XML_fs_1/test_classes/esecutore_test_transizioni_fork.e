note
	description: "Summary description for {ESECUTORE_TEST_TRANSIZIONI_FORK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE_TEST_TRANSIZIONI_FORK

inherit
	ESECUTORE_TEST

feature --test

	t_costrutto_fork_1
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_1.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_con_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A1,B1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"A1") and conf_has_state(esecutore.state_chart.conf_base,"B1") )
		end

	t_costrutto_fork_1_1
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_1.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_non_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A1,B2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"A1") and conf_has_state(esecutore.state_chart.conf_base,"B2") )
		end

	t_costrutto_fork_2
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_2.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_con_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A,B2,C2 )", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A") and conf_has_state(esecutore.state_chart.conf_base,"B2") and conf_has_state(esecutore.state_chart.conf_base,"C2") )
		end

	t_costrutto_fork_2_1
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_2_1.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_con_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A,B,C )", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A") and conf_has_state(esecutore.state_chart.conf_base,"B") and conf_has_state(esecutore.state_chart.conf_base,"C") )
		end

	t_costrutto_fork_3
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_3.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_con_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A,B11,B21 )", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A") and conf_has_state(esecutore.state_chart.conf_base,"B11") and conf_has_state(esecutore.state_chart.conf_base,"B21") )
		end

	t_costrutto_fork_3_bis
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_3_bis.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_con_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A,B11,B211 )", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A") and conf_has_state(esecutore.state_chart.conf_base,"B11") and conf_has_state(esecutore.state_chart.conf_base,"B211") )
		end

	t_costrutto_fork_3_1
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_3.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_non_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A,B11,B22 )", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A") and conf_has_state(esecutore.state_chart.conf_base,"B11") and conf_has_state(esecutore.state_chart.conf_base,"B22") )
		end

	t_costrutto_fork_4
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_4.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_con_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A,B1,C )", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A") and conf_has_state(esecutore.state_chart.conf_base,"B1") and conf_has_state(esecutore.state_chart.conf_base,"C") )
		end

	t_costrutto_fork_4_1
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_4.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_non_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A,B2,C )", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A") and conf_has_state(esecutore.state_chart.conf_base,"B2") and conf_has_state(esecutore.state_chart.conf_base,"C") )
		end

	t_costrutto_fork_5
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_5.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_con_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A2,B11,B22 )", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A2") and conf_has_state(esecutore.state_chart.conf_base,"B11") and conf_has_state(esecutore.state_chart.conf_base,"B22") )
		end

	t_costrutto_fork_5_bis
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_5_bis.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_con_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A2,B11,B211 )", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A2") and conf_has_state(esecutore.state_chart.conf_base,"B11") and conf_has_state(esecutore.state_chart.conf_base,"B211") )
		end


	t_costrutto_fork_6
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_6.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_con_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( B1,B2,B3,C2 )", esecutore.state_chart.conf_base.count = 4 and conf_has_state(esecutore.state_chart.conf_base,"B1") and conf_has_state(esecutore.state_chart.conf_base,"B2") and conf_has_state(esecutore.state_chart.conf_base,"B3") and conf_has_state(esecutore.state_chart.conf_base,"C2") )
		end

	t_costrutto_fork_7
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_7.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_con_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A1,B1,C1 )", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A1") and conf_has_state(esecutore.state_chart.conf_base,"B1") and conf_has_state(esecutore.state_chart.conf_base,"C1") )
		end

	t_costrutto_fork_8
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_8.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_con_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A11,A2,B122 )", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A11") and conf_has_state(esecutore.state_chart.conf_base,"A2") and conf_has_state(esecutore.state_chart.conf_base,"B122") )
		end

	t_costrutto_fork_9
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_9.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_con_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A11,A22,B11,B12 )", esecutore.state_chart.conf_base.count = 4 and conf_has_state(esecutore.state_chart.conf_base,"A11") and conf_has_state(esecutore.state_chart.conf_base,"A22") and conf_has_state(esecutore.state_chart.conf_base,"B11") and conf_has_state(esecutore.state_chart.conf_base,"B12"))
		end

	t_costrutto_fork_10
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_10.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_con_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti (A111,A12,B1a,B21,B22,B31,C11,C31,C32)", esecutore.state_chart.conf_base.count = 9 and conf_has_state(esecutore.state_chart.conf_base,"A111") and conf_has_state(esecutore.state_chart.conf_base,"A12") and conf_has_state(esecutore.state_chart.conf_base,"B1a") and conf_has_state(esecutore.state_chart.conf_base,"B21") and conf_has_state(esecutore.state_chart.conf_base,"B22") and conf_has_state(esecutore.state_chart.conf_base,"B31") and conf_has_state(esecutore.state_chart.conf_base,"C31") and conf_has_state(esecutore.state_chart.conf_base,"C32") and conf_has_state(esecutore.state_chart.conf_base,"C11"))
		end

	t_costrutto_fork_non_ammissibile
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_non_ammissibile.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_con_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti (S)", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"S"))
		end

	t_costrutto_fork_non_ammissibile_2
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_non_ammissibile_2.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_con_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti (S)", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"S"))
		end

	t_costrutto_fork_non_ammissibile_3
	 --Filippo & Iezzi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "costrutto_fork_non_ammissibile_3.xml"
			nomi_files_prova [2] := test_data_dir + "costrutto_fork_eventi_con_fork.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti (S)", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"S"))
		end


end
