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
			nomi_files_prova [1] := test_data_dir + "esempio_test_determinismo.xml"
			nomi_files_prova [2] := test_data_dir + "esempio_test_determinismo_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( C )", esecutore.conf_base_corrente.count = 1 and conf_has_state(esecutore.conf_base_corrente,"C") )
		end

	t_non_determinismo_1_2
	 --Filippo & Iezzi 08/05/2020
	 --finisce in B perchè compare prima nel file xml
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_test_determinismo.xml"
			nomi_files_prova [2] := test_data_dir + "esempio_test_determinismo_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( B )", esecutore.conf_base_corrente.count = 1 and conf_has_state(esecutore.conf_base_corrente,"B") )
		end

	t_non_determinismo_1_3
	 --Filippo & Iezzi 08/05/2020
	 --finisce in D1 perchè esegue la transizione dal primo stato della configurazione
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_test_determinismo.xml"
			nomi_files_prova [2] := test_data_dir + "esempio_test_determinismo_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( D1 )", esecutore.conf_base_corrente.count = 1 and conf_has_state(esecutore.conf_base_corrente,"D1") )
		end

	t_non_determinismo_1_4
	 --Filippo & Iezzi 08/05/2020
	 --finisce in D1 perchè esegue la transizione dal primo stato della configurazione
	 --TODO: fallisce perchè all'entrata nello stato AND cambia l'ordine in cui compaiono gli stati fratelli
	 --rispetto a quello indicato sul file xml
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_test_determinismo.xml"
			nomi_files_prova [2] := test_data_dir + "esempio_test_determinismo_eventi_4.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( D1 )", esecutore.conf_base_corrente.count = 1 and conf_has_state(esecutore.conf_base_corrente,"D1") )
		end

	t_non_determinismo_2_1
	-- Arianna Calzuola & Riccardo Malandruccolo 08/05/2020
	-- fallisce perché in P2A (che viene prima nel file xml) non trova transizioni con evento 'x',
	-- quindi risale fino a quando non trova la transizioni interna di T
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_non_determinismo_priorità.xml"
	  		nomi_files_prova [2] := test_data_dir + "eventi_entrata.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (P1B,P2A)", esecutore.conf_base_corrente.count = 2 and conf_has_state(esecutore.conf_base_corrente,"P1B") and conf_has_state(esecutore.conf_base_corrente,"P2A"))
		end

	t_non_determinismo_2_2
	-- Arianna Calzuola & Riccardo Malandruccolo 08/05/2020
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_non_determinismo_2.xml"
	  		nomi_files_prova [2] := test_data_dir + "eventi_transizione_parallelo_interna.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE 2_2.1: il sistema entra in due stati XOR", esecutore.conf_base_corrente.count = 1)
			assert("ERRORE 2_2.2: il sistema non entra in A", conf_has_state(esecutore.conf_base_corrente,"A"))
		end

	t_non_determinismo_2_3
	-- Arianna Calzuola & Riccardo Malandruccolo 08/05/2020
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_non_determinismo_3.xml"
	  		nomi_files_prova [2] := test_data_dir + "eventi_entrata.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE 2_3.1: il sistema esce dallo stato P parallelo", esecutore.conf_base_corrente.count = 2)
			assert("ERRORE 2_3.2: il sistema non entra in (B,P2)", conf_has_state(esecutore.conf_base_corrente,"B") and conf_has_state(esecutore.conf_base_corrente,"P2"))
		end

end
