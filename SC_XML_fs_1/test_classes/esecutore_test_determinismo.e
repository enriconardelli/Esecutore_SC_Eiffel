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
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( C )", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"C") )
		end

	t_non_determinismo_1_2
	 --Filippo & Iezzi 08/05/2020
	 --finisce in B perché compare prima nel file xml
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "non_determinismo_1.xml"
			nomi_files_prova [2] := test_data_dir + "non_determinismo_1_2_eventi.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( B )", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"B") )
		end

	t_non_determinismo_1_3
	 --Filippo & Iezzi 08/05/2020
	 --finisce in D1 perché esegue la transizione dal primo stato della configurazione
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "non_determinismo_1.xml"
			nomi_files_prova [2] := test_data_dir + "non_determinismo_1_3_eventi.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( D1 )", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"D1") )
		end

	t_non_determinismo_1_3_alt
	 --finisce in D1 perché esegue la transizione dal primo stato della configurazione
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "non_determinismo_1_alt.xml"
			nomi_files_prova [2] := test_data_dir + "non_determinismo_1_3_eventi.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( D1 )", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"D1") )
		end

	t_non_determinismo_1_4
	 --Filippo & Iezzi 08/05/2020
	 --finisce in D1 perché esegue la transizione dal primo stato della configurazione
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "non_determinismo_1.xml"
			nomi_files_prova [2] := test_data_dir + "non_determinismo_1_4_eventi.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( D1 )", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"D1") )
		end

	t_non_determinismo_1_4_alt
	 --finisce in D1 perché esegue la transizione dal primo stato della configurazione
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "non_determinismo_1_alt.xml"
			nomi_files_prova [2] := test_data_dir + "non_determinismo_1_4_eventi.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( D1 )", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"D1") )
		end

	t_non_determinismo_1_5
	-- Alessandro Filippo & Giulia Iezzi 25/05/2020
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_1_5.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_1_5_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (A3,B11,B12b)", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A3") and conf_has_state(esecutore.state_chart.conf_base,"B11")  and conf_has_state(esecutore.state_chart.conf_base,"B12b"))
	end

	t_non_determinismo_1_5_1
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_1_5_1.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_1_5_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (A3,B11a,B12a)", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A3") and conf_has_state(esecutore.state_chart.conf_base,"B11a")  and conf_has_state(esecutore.state_chart.conf_base,"B12a"))
	end

	t_non_determinismo_1_5_2
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_1_5_2.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_1_5_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (A3,B11a,B12b)", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A3") and conf_has_state(esecutore.state_chart.conf_base,"B11a")  and conf_has_state(esecutore.state_chart.conf_base,"B12b"))
	end

	t_non_determinismo_1_5_3
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_1_5_3.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_1_5_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (A3,B11a,B12b)", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"A3") and conf_has_state(esecutore.state_chart.conf_base,"B11a")  and conf_has_state(esecutore.state_chart.conf_base,"B12b"))
	end

	t_non_determinismo_1_6
	-- Alessandro Filippo & Giulia Iezzi 25/05/2020
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_1_6.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_1_6_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (B1,B21)", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"B1") and conf_has_state(esecutore.state_chart.conf_base,"B21"))
	end

	t_non_determinismo_1_6_var
	-- TODO: rispetto a 1_6 gli eventi compaiono in ordine diverso (sempre nello stesso istante)
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_1_6.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_1_6_eventi_var.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (B1,B21)", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"B1") and conf_has_state(esecutore.state_chart.conf_base,"B21"))
	end

	t_non_determinismo_1_7_1
	-- Alessandro Filippo & Giulia Iezzi 25/05/2020
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_1_7_1.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_1_7_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (C)", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"C"))
	end

	t_non_determinismo_1_7_2
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_1_7_2.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_1_7_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (B11,A2)", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"B11") and conf_has_state(esecutore.state_chart.conf_base,"A2"))
	end

	t_non_determinismo_1_7_3
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_1_7_3.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_1_7_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (C)", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"C"))
	end

	t_non_determinismo_1_7_4
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_1_7_4.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_1_7_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (B11,A1)", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"B11") and conf_has_state(esecutore.state_chart.conf_base,"A1"))
	end

	t_non_determinismo_2_1
	-- Arianna Calzuola & Riccardo Malandruccolo 08/05/2020
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_2_1.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_1_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (P1B,P2A)", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"P1B") and conf_has_state(esecutore.state_chart.conf_base,"P2A"))
	end

	t_non_determinismo_2_2
	-- Arianna Calzuola & Riccardo Malandruccolo 08/05/2020
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_2_2.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_2_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE 2_2: il sistema non entra in A", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"A"))
	end

	t_non_determinismo_2_3
	-- Arianna Calzuola & Riccardo Malandruccolo 08/05/2020
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_2_3.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_3_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE 2_3: il sistema non termina in (B,P2)", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"B") and conf_has_state(esecutore.state_chart.conf_base,"P2"))
	end

	t_non_determinismo_2_4
	-- Arianna & Riccardo 21/05/2020
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_2_4.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_4_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (P1A2,P1B1,P2)", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"P1A2") and conf_has_state(esecutore.state_chart.conf_base,"P1B1") and conf_has_state(esecutore.state_chart.conf_base,"P2"))
	end

	t_non_determinismo_2_5_1
	-- Arianna & Riccardo 21/05/2020
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_2_5.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_5_1_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (P1B,P2A,R1B,R2A)", esecutore.state_chart.conf_base.count = 4 and conf_has_state(esecutore.state_chart.conf_base,"P1B") and conf_has_state(esecutore.state_chart.conf_base,"P2A") and conf_has_state(esecutore.state_chart.conf_base,"R1B") and conf_has_state(esecutore.state_chart.conf_base,"R2A"))
	end

	t_non_determinismo_2_5_2
	-- Arianna & Riccardo 21/05/2020
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_2_5.xml"
  		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_5_2_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (P1B,P2A,G)", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"P1B") and conf_has_state(esecutore.state_chart.conf_base,"P2A") and conf_has_state(esecutore.state_chart.conf_base,"G"))
	end

	t_non_determinismo_2_6
	-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_2_6.xml"
 		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_6_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (P1A1B, P1A2, P1A3B, P2A2, P2B, P2C1A, P2C1B, A2, B1, P3B1)", esecutore.state_chart.conf_base.count = 10 and conf_has_state(esecutore.state_chart.conf_base,"P1A1B") and conf_has_state(esecutore.state_chart.conf_base,"P1A2")  and conf_has_state(esecutore.state_chart.conf_base,"P1A3B") and conf_has_state(esecutore.state_chart.conf_base,"P2A2")  and conf_has_state(esecutore.state_chart.conf_base,"P2B") and conf_has_state(esecutore.state_chart.conf_base,"P2C1A")  and conf_has_state(esecutore.state_chart.conf_base,"P2C1B") and conf_has_state(esecutore.state_chart.conf_base,"A2")  and conf_has_state(esecutore.state_chart.conf_base,"B1") and conf_has_state(esecutore.state_chart.conf_base,"P3B1"))
	end

	t_non_determinismo_2_7_1
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_2_7.xml"
 		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_7_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (P1B,P2A,G)", esecutore.state_chart.conf_base.count = 3 and conf_has_state(esecutore.state_chart.conf_base,"P1B") and conf_has_state(esecutore.state_chart.conf_base,"P2A") and conf_has_state(esecutore.state_chart.conf_base,"G"))
	end

	t_non_determinismo_2_7_2
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_2_7_alt.xml"
 		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_7_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (P1B,P2A,R1B,R2A)", esecutore.state_chart.conf_base.count = 4 and conf_has_state(esecutore.state_chart.conf_base,"P1B") and conf_has_state(esecutore.state_chart.conf_base,"P2A") and conf_has_state(esecutore.state_chart.conf_base,"R1B") and conf_has_state(esecutore.state_chart.conf_base,"R2A"))
	end

	t_non_determinismo_2_8_1
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_2_8.xml"
 		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_8_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (H)", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"H"))
	end

	t_non_determinismo_2_8_2
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_2_8_alt.xml"
 		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_8_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (P1A,P2A,R1B,R2A)", esecutore.state_chart.conf_base.count = 4 and conf_has_state(esecutore.state_chart.conf_base,"P1A") and conf_has_state(esecutore.state_chart.conf_base,"P2A") and conf_has_state(esecutore.state_chart.conf_base,"R1B") and conf_has_state(esecutore.state_chart.conf_base,"R2A"))
	end

	t_non_determinismo_2_9_1
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_2_9.xml"
 		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_9_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (F)", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"F"))
	end

	t_non_determinismo_2_9_2
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "non_determinismo_2_9_alt.xml"
 		nomi_files_prova [2] := test_data_dir + "non_determinismo_2_9_eventi.txt"
		create esecutore.make (nomi_files_prova)
		assert("ERRORE: il sistema non termina in (F)", esecutore.state_chart.conf_base.count = 1 and conf_has_state(esecutore.state_chart.conf_base,"F"))
	end

end
