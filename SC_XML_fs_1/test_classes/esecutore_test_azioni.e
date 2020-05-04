note
	description: "Summary description for {CONFIGURAZIONE_TEST_AZIONI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE_TEST_AZIONI

inherit

	ESECUTORE_TEST
		redefine
			on_prepare
		end

feature -- Test routines

	on_prepare
		do
			precursor
			nomi_files_prova [1] := test_data_dir + "esempio_xor_azioni.xml"
			nomi_files_prova [2] := test_data_dir
		end

feature -- Test

	t_xor_azioni
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "eventi_xor_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha eseguito l'azione on_entryB", esecutore.state_chart.condizioni.item ("on_entryB"))
			assert ("ERRORE il sistema non ha eseguito l'azione on_entryB1", esecutore.state_chart.condizioni.item ("on_entryB1"))
			assert ("ERRORE il sistema non ha eseguito l'azione on_exitA", esecutore.state_chart.condizioni.item ("on_exitA"))
			assert ("ERRORE il sistema non ha eseguito l'azione on_exitA1", esecutore.state_chart.condizioni.item ("on_exitA1"))
			assert ("ERRORE il sistema non ha eseguito l'azione on_exitA1a", not esecutore.state_chart.condizioni.item ("on_exitA1a"))
			assert ("ERRORE il sistema non ha eseguito l'azione on_exitA1b", esecutore.state_chart.condizioni.item ("on_exitA1b"))
		end


	t_azioni_uscita
    -- Claudia & Federico 01/05/2020
    local
      esecutore: ESECUTORE
    do
      nomi_files_prova [1] := test_data_dir + "esempio_azioni_uscita.xml"
        nomi_files_prova [2] := test_data_dir + "eventi_azioni_uscita.txt"
      create esecutore.make (nomi_files_prova)
      assert("ERRORE 5.1 non esco da X", esecutore.state_chart.condizioni.item ("on_exitX"))
      assert("ERRORE 5.2 non esco da A", esecutore.state_chart.condizioni.item ("on_exitA"))
      assert("ERRORE 5.3 non esco da A1", esecutore.state_chart.condizioni.item ("on_exitA1"))
      assert("ERRORE 5.4 non esco da B", esecutore.state_chart.condizioni.item ("on_exitB"))
    end

		t_parallel_azioni_entrata
		-- Arianna & Riccardo 01/05/2020
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_entrata_2_azioni.xml"
	  		nomi_files_prova [2] := test_data_dir + "eventi_entrata_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE 3.1 il sistema non ha eseguito l'azione on_exitA1", esecutore.state_chart.condizioni.item ("on_exitA1"))
			assert ("ERRORE 3.2 il sistema non ha eseguito l'azione on_entryA2",  esecutore.state_chart.condizioni.item ("on_entryA2"))
			assert ("ERRORE 3.3 il sistema non ha eseguito l'azione on_entryA2A", esecutore.state_chart.condizioni.item ("on_entryA2A"))
			assert ("ERRORE 3.4 il sistema ha eseguito l'azione on_entryA2A1 che è lo stato di default", not esecutore.state_chart.condizioni.item ("on_entryA2A1"))
			assert ("ERRORE 3.4 il sistema non ha eseguito l'azione on_entryA2A2", esecutore.state_chart.condizioni.item ("on_entryA2A2"))
			assert ("ERRORE 3.5 il sistema non ha eseguito l'azione on_entryA2B",  esecutore.state_chart.condizioni.item ("on_entryA2B"))
			assert ("ERRORE 3.6 il sistema non ha eseguito l'azione on_entryA2B1", esecutore.state_chart.condizioni.item ("on_entryA2B1"))
    		assert ("ERRORE 3.7 il sistema non ha eseguito l'azione on_entryA2B2", not esecutore.state_chart.condizioni.item ("on_entryA2B2"))
    		assert ("ERRORE 3.8 il sistema non ha eseguito l'azione on_entryp", esecutore.state_chart.condizioni.item ("on_entryp"))
		end

		t_transizione_interna
		-- Arianna & Riccardo 01/05/2020
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_transizione_interna.xml"
	  		nomi_files_prova [2] := test_data_dir + "eventi_transizione_interna.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE 4.1 esco da S", not esecutore.state_chart.condizioni.item ("on_exitS"))
			assert("ERRORE 4.2 entro in S", not esecutore.state_chart.condizioni.item ("on_entryS"))
			assert("ERRORE 4.3 non esco da T", esecutore.state_chart.condizioni.item ("on_exitT"))
			assert("ERRORE 4.4 non rientro in T", esecutore.state_chart.condizioni.item ("on_entryT"))
		end

		t_onexit_complesso
		-- Claudia & Federico 04/05/2020
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_onexit_complesso.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_onexit_complesso.txt"
			create esecutore.make (nomi_files_prova)
			assert("Errore 1: lo stato di arrivo non è T", conf_has_state(esecutore.conf_base_corrente,"T"))
			assert("Errore 2: non doveva venir eseguita l' onexit di B2", not esecutore.state_chart.condizioni.item("on_exitB2"))
		end

end
