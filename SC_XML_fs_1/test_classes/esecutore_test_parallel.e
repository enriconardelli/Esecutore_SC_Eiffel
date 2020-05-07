note
	description: "Summary description for {ESECUTORE_TEST_PARALLEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE_TEST_PARALLEL

inherit
	ESECUTORE_TEST

feature -- Test

	t_base_parallelo
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_base_parallelo.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_base_parallelo.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A - TRE )", esecutore.conf_base_corrente.count = 2 and conf_has_state(esecutore.conf_base_corrente,"C") and conf_has_state(esecutore.conf_base_corrente,"TRE") )
		end

	t_condizioni_parallelo
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_parallelo_condizioni.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_parallelo_condizioni.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( C )", esecutore.conf_base_corrente.count = 1 and conf_has_state(esecutore.conf_base_corrente,"C") )
	 		assert ("ERRORE il sistema non impostato correttamente le condizioni", esecutore.state_chart.condizioni.item ("alfa"))
		end

	t_entrata
	-- La transizione ha come target lo stato AND
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_entrata.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_entrata.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A2A1 - A2B1 )", esecutore.conf_base_corrente.count = 2 and conf_has_state(esecutore.conf_base_corrente,"A2A1") and conf_has_state(esecutore.conf_base_corrente,"A2B1") )
		end

	t_entrata_2
	-- La transizione ha come target un sotto-stato dello stato AND
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_entrata_2.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_entrata_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A2A2 - A2B1 )", esecutore.conf_base_corrente.count = 2 and conf_has_state(esecutore.conf_base_corrente,"A2A2") and conf_has_state(esecutore.conf_base_corrente,"A2B1") )
		end

	t_uscita
	-- La transizione esce da un sotto-stato dello stato AND
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_uscita.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_uscita.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A1 )", esecutore.conf_base_corrente.count = 1 and conf_has_state(esecutore.conf_base_corrente,"A1") )
		end

	t_esempio_complesso
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_complesso.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_complesso.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A11 )", esecutore.conf_base_corrente.count = 1 and conf_has_state(esecutore.conf_base_corrente,"A11") )
		end

	t_transizione_parallelo_interna
	-- Arianna & Riccardo 26/04/2020
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_transizione_parallelo_interna.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_transizione_parallelo_interna.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A2A2 , A2B2 )", esecutore.conf_base_corrente.count = 2 and conf_has_state(esecutore.conf_base_corrente,"A2A2") and  conf_has_state(esecutore.conf_base_corrente,"A2B2"))
		end

	t_parallelo_una_profondita
	-- Arianna & Riccardo 26/04/2020
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "parallelo_una_profondita.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_xor_1.txt"
			create esecutore.make (nomi_files_prova)
			 assert ("ERRORE lo stato corrente non è (A,UNO)", conf_has_state(esecutore.conf_base_corrente,"A") and conf_has_state(esecutore.conf_base_corrente,"UNO"))
		end

	t_parallelo_piu_profondo
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "parallelo_piu_profondo.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_xor_1.txt"
			create esecutore.make (nomi_files_prova)
			 assert ("ERRORE lo stato corrente non è (A2A1, P1, P2)", conf_has_state(esecutore.conf_base_corrente,"A2A1") and conf_has_state(esecutore.conf_base_corrente,"P1") and conf_has_state(esecutore.conf_base_corrente,"P2"))
		end

	t_misto_parallel_1
	-- Alessandro & Giulia 01/05/2020
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_multi_parallel.xml"
			nomi_files_prova [2] := test_data_dir + "esempio_multi_parallel_eventi.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE lo configurazione base corrente non è (A,B2,B1)", conf_has_state(esecutore.conf_base_corrente,"A") and conf_has_state(esecutore.conf_base_corrente,"B1") and conf_has_state(esecutore.conf_base_corrente,"B2"))
		end

	t_transizioni_interne_parallel
	--Claudia & Federico 01/05/2020
	--Quando vengono eseguite transizioni all' interno di uno stato parallelo, a sua volta contenuto in uno stato parallelo
	--Viene "scordata" la configurazione a livello più alto (nell' esecuzione di questo test la configurazione finale dovrebbe contenere anche lo stato B1, che invece non appare)
	local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_transizioni_interne_parallelo.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_transizioni_interne_parallelo.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE lo configurazione base corrente non è (A1A2,A1B,A1C,B1)", conf_has_state(esecutore.conf_base_corrente,"A1A2") and conf_has_state(esecutore.conf_base_corrente,"A1B") and conf_has_state(esecutore.conf_base_corrente,"A1C") and conf_has_state(esecutore.conf_base_corrente,"B1"))
		end

	t_transizione_non_ammissibile
	-- Arianna Calzuola & Riccardo Malandruccolo 07/05/2020
	local
		esecutore: ESECUTORE
	do
		nomi_files_prova [1] := test_data_dir + "esempio_transizione_non_ammissibile.xml"
  		nomi_files_prova [2] := test_data_dir + "eventi_entrata.txt"
		create esecutore.make (nomi_files_prova)
		assert ("ERRORE lo stato corrente non è (P1, P2)", conf_has_state(esecutore.conf_base_corrente,"P1") and conf_has_state(esecutore.conf_base_corrente,"P2"))
	end
end
