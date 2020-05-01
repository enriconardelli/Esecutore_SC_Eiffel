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

--	t_azioni_uscita
--    -- Claudia & Federico 01/05/2020
--    local
--      esecutore: ESECUTORE
--    do
--      nomi_files_prova [1] := test_data_dir + "esempio_azioni_uscita.xml"
--        nomi_files_prova [2] := test_data_dir + "eventi_azioni_uscita.txt"
--      create esecutore.make (nomi_files_prova)
--      assert("ERRORE 5.1 non esco da X", esecutore.state_chart.condizioni.item ("on_exitX"))
--      assert("ERRORE 5.2 non esco da A", esecutore.state_chart.condizioni.item ("on_exitA"))
--      assert("ERRORE 5.3 non esco da A1", esecutore.state_chart.condizioni.item ("on_exitA1"))
--      assert("ERRORE 5.4 non esco da B", esecutore.state_chart.condizioni.item ("on_exitB"))
--    end

end
