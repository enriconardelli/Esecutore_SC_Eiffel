note
	description: "Summary description for {ESECUTORE_TEST_DETERMINISMO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE_TEST_DETERMINISMO

inherit

	ESECUTORE_TEST

feature -- Test routines

	t_non_determinismo_1_1
	 --Filippo & Iezzi 08/05/2020
	 --finisce in C perché esegue la transizione più interna
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "non_determinismo_1.xml"
			nomi_files_prova [2] := test_data_dir + "non_determinismo_1_1_eventi.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( C )", esecutore.conf_base_corrente.count = 1 and conf_has_state(esecutore.conf_base_corrente,"C") )
		end

	t_non_determinismo_1_2
	 --Filippo & Iezzi 08/05/2020
	 --finisce in B perchè compare prima nel file xml
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "non_determinismo_1.xml"
			nomi_files_prova [2] := test_data_dir + "non_determinismo_1_2_eventi.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( B )", esecutore.conf_base_corrente.count = 1 and conf_has_state(esecutore.conf_base_corrente,"B") )
		end

	t_non_determinismo_1_3
	 --Filippo & Iezzi 08/05/2020
	 --finisce in D1 perchè esegue la transizione dal primo stato della configurazione
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "non_determinismo_1.xml"
			nomi_files_prova [2] := test_data_dir + "non_determinismo_1_3_eventi.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( D1 )", esecutore.conf_base_corrente.count = 1 and conf_has_state(esecutore.conf_base_corrente,"D1") )
		end

	t_non_determinismo_1_4
	 --Filippo & Iezzi 08/05/2020
	 --finisce in D1 perchè esegue la transizione dal primo stato della configurazione
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "non_determinismo_1.xml"
			nomi_files_prova [2] := test_data_dir + "non_determinismo_1_4_eventi.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( D1 )", esecutore.conf_base_corrente.count = 1 and conf_has_state(esecutore.conf_base_corrente,"D1") )
		end

	t_non_determinismo_1_5
	-- Alessandro Filippo & Giulia Iezzi 25/05/2020
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_1_5.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_1_5_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (A3,B11,B12b)", esecutore.conf_base_corrente.count = 3 and conf_has_state(esecutore.conf_base_corrente,"A3") and conf_has_state(esecutore.conf_base_corrente,"B11")  and conf_has_state(esecutore.conf_base_corrente,"B12b"))
	end

	t_non_determinismo_1_6
	-- Alessandro Filippo & Giulia Iezzi 25/05/2020
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_1_6.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_1_6_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (B1,B21)", esecutore.conf_base_corrente.count = 2 and conf_has_state(esecutore.conf_base_corrente,"B1") and conf_has_state(esecutore.conf_base_corrente,"B21"))
	end

	t_non_determinismo_1_7
	-- Alessandro Filippo & Giulia Iezzi 25/05/2020
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_1_7.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_1_7_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (C)", esecutore.conf_base_corrente.count = 1 and conf_has_state(esecutore.conf_base_corrente,"C"))
	end

	t_non_determinismo_2_1
	-- Arianna Calzuola & Riccardo Malandruccolo 08/05/2020
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "non_determinismo_2_1.xml"
	  		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_1_eventi.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (P1B,P2A)", esecutore.conf_base_corrente.count = 2 and conf_has_state(esecutore.conf_base_corrente,"P1B") and conf_has_state(esecutore.conf_base_corrente,"P2A"))
		end

	t_non_determinismo_2_2
	-- Arianna Calzuola & Riccardo Malandruccolo 08/05/2020
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "non_determinismo_2_2.xml"
	  		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_2_eventi.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE 2_2.1: il sistema entra in due stati XOR", esecutore.conf_base_corrente.count = 1)
			assert("ERRORE 2_2.2: il sistema non entra in A", conf_has_state(esecutore.conf_base_corrente,"A"))
		end

	t_non_determinismo_2_3
	-- Arianna Calzuola & Riccardo Malandruccolo 08/05/2020
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "non_determinismo_2_3.xml"
	  		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_3_eventi.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE 2_3.1: il sistema esce dallo stato P parallelo", esecutore.conf_base_corrente.count = 2)
			assert("ERRORE 2_3.2: il sistema non entra in (B,P2)", conf_has_state(esecutore.conf_base_corrente,"B") and conf_has_state(esecutore.conf_base_corrente,"P2"))
		end

	t_non_determinismo_2_4
	-- Arianna & Riccardo 21/05/2020
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "non_determinismo_2_4.xml"
	  		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_4_eventi.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (P1A2,P1B1,P2)", esecutore.conf_base_corrente.count = 3 and conf_has_state(esecutore.conf_base_corrente,"P1A2") and conf_has_state(esecutore.conf_base_corrente,"P1B1") and conf_has_state(esecutore.conf_base_corrente,"P2"))
		end

	t_non_determinismo_2_5_1
	-- Arianna & Riccardo 21/05/2020
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "non_determinismo_2_5.xml"
	  		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_5_1_eventi.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (P1B,P2A,R1B,R2A)", esecutore.conf_base_corrente.count = 4 and conf_has_state(esecutore.conf_base_corrente,"P1B") and conf_has_state(esecutore.conf_base_corrente,"P2A") and conf_has_state(esecutore.conf_base_corrente,"R1B") and conf_has_state(esecutore.conf_base_corrente,"R2A"))
		end

	t_non_determinismo_2_5_2
	-- Arianna & Riccardo 21/05/2020
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "non_determinismo_2_5.xml"
	  		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_5_2_eventi.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (P1B,P2A,G)", esecutore.conf_base_corrente.count = 3 and conf_has_state(esecutore.conf_base_corrente,"P1B") and conf_has_state(esecutore.conf_base_corrente,"P2A") and conf_has_state(esecutore.conf_base_corrente,"G"))
		end

	t_non_determinismo_2_6
	-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_2_6.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_6_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (P1A1B, P1A2, P1A3B, P2A2, P2B, P2C1A, P2C1B, A2, B1, P3B)", esecutore.conf_base_corrente.count = 10 and conf_has_state(esecutore.conf_base_corrente,"P1A1B") and conf_has_state(esecutore.conf_base_corrente,"P1A2")  and conf_has_state(esecutore.conf_base_corrente,"P1A3B") and conf_has_state(esecutore.conf_base_corrente,"P2A2")  and conf_has_state(esecutore.conf_base_corrente,"P2B") and conf_has_state(esecutore.conf_base_corrente,"P2C1A")  and conf_has_state(esecutore.conf_base_corrente,"P2C1B") and conf_has_state(esecutore.conf_base_corrente,"A2")  and conf_has_state(esecutore.conf_base_corrente,"B1") and conf_has_state(esecutore.conf_base_corrente,"P3B"))
	end

end
