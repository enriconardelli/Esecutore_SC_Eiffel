note
	description: "Summary description for {ESECUTORE_TEST_PARALLEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE_TEST_PARALLEL

inherit
	ESECUTORE_TEST
	redefine
			on_prepare
		end

feature {NONE} -- Supporto

	conf_finale: LINKED_SET [STRING]

feature -- Test routines

	on_prepare
		do
			Precursor
			create conf_finale.make
		end

	t_base_parallelo
 		do
			conf_finale.force("C")
			evoluzione_state_chart("base_parallelo.xml", "base_parallelo_eventi.txt", conf_finale)
		end

	t_condizioni_parallelo
 		do
			conf_finale.force("C")
			evoluzione_state_chart("parallelo_condizioni.xml", "parallelo_condizioni_eventi.txt", conf_finale)
			--assert ("ERRORE il sistema non impostato correttamente le condizioni", esecutore.state_chart.variabili.booleane.item ("alfa"))
		end

	t_entrata
	-- La transizione ha come target lo stato AND
 		do
			conf_finale.force("A2A1")
			conf_finale.force("A2B1")
			evoluzione_state_chart("entrata_1.xml", "entrata_1_eventi.txt", conf_finale)
		end

	t_entrata_2
	-- La transizione ha come target un sotto-stato dello stato AND
 		do
			conf_finale.force("A2A2")
			conf_finale.force("A2B1")
			evoluzione_state_chart("entrata_2.xml", "entrata_2_eventi.txt", conf_finale)
		end

	t_uscita
	-- La transizione esce da un sotto-stato dello stato AND
 		do
			conf_finale.force("A1")
			evoluzione_state_chart("uscita.xml", "uscita_eventi.txt", conf_finale)
		end

	t_esempio_complesso
 		do
			conf_finale.force("A11")
			evoluzione_state_chart("complesso.xml", "complesso_eventi.txt", conf_finale)
		end

	t_transizione_parallelo_interna
	-- Arianna & Riccardo 26/04/2020
 		do
			conf_finale.force("A2A2")
			conf_finale.force("A2B2")
			evoluzione_state_chart("transizione_parallelo_interna.xml", "transizione_parallelo_interna_eventi.txt", conf_finale)
		end

	t_parallelo_una_profondita
	-- Arianna & Riccardo 26/04/2020
 		do
			conf_finale.force("A")
			conf_finale.force("UNO")
			evoluzione_state_chart("parallelo_una_profondita.xml", "parallelo_una_profondita_eventi.txt", conf_finale)
		end

	t_parallelo_piu_profondo
 		do
			conf_finale.force("A2A1")
			conf_finale.force("P1")
			conf_finale.force("P2")
			evoluzione_state_chart("parallelo_piu_profondo.xml", "parallelo_piu_profondo_eventi.txt", conf_finale)
		end

	t_misto_parallel_1
	-- Alessandro & Giulia 01/05/2020
 		do
			conf_finale.force("A")
			conf_finale.force("B2")
			conf_finale.force ("B1")
			evoluzione_state_chart("multi_parallel_1.xml", "multi_parallel_1_eventi.txt", conf_finale)
		end

	t_transizioni_interne_parallel
	--Claudia & Federico 01/05/2020
	--Quando vengono eseguite transizioni all' interno di uno stato parallelo, a sua volta contenuto in uno stato parallelo
	--Viene "scordata" la configurazione a livello più alto (nell' esecuzione di questo test la configurazione finale dovrebbe contenere anche lo stato B1, che invece non appare)
 		do
			conf_finale.force("A1A2")
			conf_finale.force("A1B")
			conf_finale.force ("A1C")
			conf_finale.force ("B1")
			evoluzione_state_chart("transizioni_interne_parallelo.xml", "transizioni_interne_parallelo_eventi.txt", conf_finale)
		end

	t_transizione_non_ammissibile
	-- Arianna Calzuola & Riccardo Malandruccolo 07/05/2020
 		do
			conf_finale.force("P1")
			conf_finale.force("P2")
			evoluzione_state_chart("transizione_non_ammissibile.xml", "transizione_non_ammissibile_eventi.txt", conf_finale)
		end

	t_internal_con_sorgente_parallelo
	-- Arianna Calzuola & Riccardo Malandruccolo 08/05/2020
	-- se la transizione fosse internal si dimenticherebbe della struttura in parallelo
 		do
			conf_finale.force("P1")
			conf_finale.force("P2B")
			evoluzione_state_chart("internal_da_parallelo.xml", "internal_da_parallelo_eventi.txt", conf_finale)
		end

	t_figlio_genitore
	-- Arianna & Riccardo 21/05/2020
 		do
			conf_finale.force("P1A1")
			conf_finale.force("P1B1")
			conf_finale.force ("P2")
			evoluzione_state_chart("transizione_figlio_genitore.xml", "transizione_figlio_genitore_eventi.txt", conf_finale)
		end

	t_transizione_senza_evento_1
 		do
			conf_finale.force("S2")
			conf_finale.force("T2")
			evoluzione_state_chart("transizione_senza_evento_parallelo.xml", "transizione_senza_evento_parallelo_eventi.txt", conf_finale)
		end

	t_transizione_senza_evento_2
 		do
			conf_finale.force("S2")
			conf_finale.force("T2")
			evoluzione_state_chart("transizione_senza_evento_parallelo_bis.xml", "transizione_senza_evento_parallelo_eventi.txt", conf_finale)
		end

end
