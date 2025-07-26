note
	description: "Summary description for {CONFIGURAZIONE_TEST_AZIONI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE_TEST_AZIONI

inherit

	ESECUTORE_TEST
--		redefine
--			on_prepare
--		end

feature -- Test routines

--	on_prepare
--		do
--			precursor
--			nomi_files_prova [1] := test_data_dir
--			nomi_files_prova [2] := test_data_dir
--		end

feature -- Test

	t_xor_azioni
		local
			esecutore: ESECUTORE
		do
	    argomenti [1] := test_data_dir + "xor.xml"
			argomenti [2] := test_data_dir + "xor_eventi_2.txt"
			create esecutore.make (argomenti)
			assert ("ERRORE il sistema non ha eseguito l'azione on_entryB", esecutore.state_chart.variabili.booleane.item ("on_entryB"))
			assert ("ERRORE il sistema non ha eseguito l'azione on_entryB1", esecutore.state_chart.variabili.booleane.item ("on_entryB1"))
			assert ("ERRORE il sistema non ha eseguito l'azione on_exitA", esecutore.state_chart.variabili.booleane.item ("on_exitA"))
			assert ("ERRORE il sistema non ha eseguito l'azione on_exitA1", esecutore.state_chart.variabili.booleane.item ("on_exitA1"))
			assert ("ERRORE il sistema non ha eseguito l'azione on_exitA1a", not esecutore.state_chart.variabili.booleane.item ("on_exitA1a"))
			assert ("ERRORE il sistema non ha eseguito l'azione on_exitA1b", esecutore.state_chart.variabili.booleane.item ("on_exitA1b"))
		end


	t_azioni_uscita
    -- Claudia & Federico 01/05/2020
    local
      esecutore: ESECUTORE
    do
      argomenti [1] := test_data_dir + "azioni_uscita.xml"
      argomenti [2] := test_data_dir + "azioni_uscita_eventi.txt"
      create esecutore.make (argomenti)
      assert("ERRORE 5.1 non esco da X", esecutore.state_chart.variabili.booleane.item ("on_exitX"))
      assert("ERRORE 5.2 non esco da A", esecutore.state_chart.variabili.booleane.item ("on_exitA"))
      assert("ERRORE 5.3 non esco da A1", esecutore.state_chart.variabili.booleane.item ("on_exitA1"))
      assert("ERRORE 5.4 non esco da B", esecutore.state_chart.variabili.booleane.item ("on_exitB"))
      assert("ERRORE 5.5: lo stato di arrivo non Ã¨ Y", conf_has_state(esecutore.state_chart.config_base,"Y"))
    end

		t_parallel_azioni_entrata
		-- Arianna & Riccardo 01/05/2020
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "entrata_azioni_2.xml"
  		argomenti [2] := test_data_dir + "entrata_azioni_2_eventi.txt"
			create esecutore.make (argomenti)
			assert ("ERRORE 3.1 il sistema non ha eseguito l'azione on_exitA1", esecutore.state_chart.variabili.booleane.item ("on_exitA1"))
			assert ("ERRORE 3.2 il sistema non ha eseguito l'azione on_entryA2",  esecutore.state_chart.variabili.booleane.item ("on_entryA2"))
			assert ("ERRORE 3.3 il sistema non ha eseguito l'azione on_entryA2A", esecutore.state_chart.variabili.booleane.item ("on_entryA2A"))
			assert ("ERRORE 3.4 il sistema ha eseguito l'azione on_entryA2A1 che Ã¨ lo stato di default", not esecutore.state_chart.variabili.booleane.item ("on_entryA2A1"))
			assert ("ERRORE 3.4 il sistema non ha eseguito l'azione on_entryA2A2", esecutore.state_chart.variabili.booleane.item ("on_entryA2A2"))
			assert ("ERRORE 3.5 il sistema non ha eseguito l'azione on_entryA2B",  esecutore.state_chart.variabili.booleane.item ("on_entryA2B"))
			assert ("ERRORE 3.6 il sistema non ha eseguito l'azione on_entryA2B1", esecutore.state_chart.variabili.booleane.item ("on_entryA2B1"))
    		assert ("ERRORE 3.7 il sistema non ha eseguito l'azione on_entryA2B2", not esecutore.state_chart.variabili.booleane.item ("on_entryA2B2"))
    		assert ("ERRORE 3.8 il sistema non ha eseguito l'azione on_entryp", esecutore.state_chart.variabili.booleane.item ("on_entryp"))
		end

		t_transizione_interna
		-- Arianna & Riccardo 01/05/2020
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "transizione_interna.xml"
  		argomenti [2] := test_data_dir + "transizione_interna_eventi.txt"
			create esecutore.make (argomenti)
			assert("ERRORE 4.1 esco da S", not esecutore.state_chart.variabili.booleane.item ("on_exitS"))
			assert("ERRORE 4.2 entro in S", not esecutore.state_chart.variabili.booleane.item ("on_entryS"))
			assert("ERRORE 4.3 non esco da T", esecutore.state_chart.variabili.booleane.item ("on_exitT"))
			assert("ERRORE 4.4 non rientro in T", esecutore.state_chart.variabili.booleane.item ("on_entryT"))
		end

		t_onexit_complesso
		-- Claudia & Federico 04/05/2020
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "onexit_complesso.xml"
			argomenti [2] := test_data_dir + "onexit_complesso_eventi_1.txt"
			create esecutore.make (argomenti)
			assert("Errore 1: lo stato di arrivo non Ã¨ T", conf_has_state(esecutore.state_chart.config_base,"T"))
			assert("Errore B2: non doveva venir eseguita l' onexit di B2", not esecutore.state_chart.variabili.booleane.item("on_exitB2"))
			assert("Errore S: non viene eseguita l' onexit di S", esecutore.state_chart.variabili.booleane.item("on_exitS"))
			assert("Errore A: non viene eseguita l' onexit di A", esecutore.state_chart.variabili.booleane.item("on_exitA"))
			assert("Errore A1: non viene eseguita l' onexit di A1", esecutore.state_chart.variabili.booleane.item("on_exitA1"))
			assert("Errore A11: non viene eseguita l' onexit di A11", esecutore.state_chart.variabili.booleane.item("on_exitA11"))
			assert("Errore A111: non viene eseguita l' onexit di A111", esecutore.state_chart.variabili.booleane.item("on_exitA111"))
			assert("Errore A2: non viene eseguita l' onexit di A2", esecutore.state_chart.variabili.booleane.item("on_exitA2"))
			assert("Errore A21: non viene eseguita l' onexit di A21", esecutore.state_chart.variabili.booleane.item("on_exitA21"))
			assert("Errore B: non viene eseguita l' onexit di B", esecutore.state_chart.variabili.booleane.item("on_exitB"))
			assert("Errore B1: non viene eseguita l' onexit di B1", esecutore.state_chart.variabili.booleane.item("on_exitB1"))
			assert("Errore C: non viene eseguita l' onexit di C", esecutore.state_chart.variabili.booleane.item("on_exitC"))
			assert("Errore C1: non viene eseguita l' onexit di C1", esecutore.state_chart.variabili.booleane.item("on_exitC1"))
			assert("Errore C11: non viene eseguita l' onexit di C11", esecutore.state_chart.variabili.booleane.item("on_exitC11"))
			assert("Errore C11A: non viene eseguita l' onexit di C11A", esecutore.state_chart.variabili.booleane.item("on_exitC11A"))
			assert("Errore C11A1: non viene eseguita l' onexit di C11A1", esecutore.state_chart.variabili.booleane.item("on_exitC11A1"))
			assert("Errore C11B: non viene eseguita l' onexit di C11B", esecutore.state_chart.variabili.booleane.item("on_exitC11B"))
			assert("Errore D: non viene eseguita l' onexit di D", esecutore.state_chart.variabili.booleane.item("on_exitD"))
			assert("Errore T: non doveva venir eseguita l' onexit di T", not esecutore.state_chart.variabili.booleane.item("on_exitT"))
		end

		t_onexit_complesso_2
		-- Claudia & Federico 18/05/2020
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "onexit_complesso.xml"
			argomenti [2] := test_data_dir + "onexit_complesso_eventi_2.txt"
			create esecutore.make (argomenti)
			assert("Errore 1: lo stato di arrivo non Ã¨ T", conf_has_state(esecutore.state_chart.config_base,"T"))
			assert("Errore B2: non viene eseguita l' onexit di B2", esecutore.state_chart.variabili.booleane.item("on_exitB2"))
			assert("Errore S: non viene eseguita l' onexit di S", esecutore.state_chart.variabili.booleane.item("on_exitS"))
			assert("Errore A: non viene eseguita l' onexit di A", esecutore.state_chart.variabili.booleane.item("on_exitA"))
			assert("Errore A1: non viene eseguita l' onexit di A1", esecutore.state_chart.variabili.booleane.item("on_exitA1"))
			assert("Errore A11: non viene eseguita l' onexit di A11", esecutore.state_chart.variabili.booleane.item("on_exitA11"))
			assert("Errore A111: non viene eseguita l' onexit di A111", esecutore.state_chart.variabili.booleane.item("on_exitA111"))
			assert("Errore A2: non viene eseguita l' onexit di A2", esecutore.state_chart.variabili.booleane.item("on_exitA2"))
			assert("Errore A21: non viene eseguita l' onexit di A21", esecutore.state_chart.variabili.booleane.item("on_exitA21"))
			assert("Errore B: non viene eseguita l' onexit di B", esecutore.state_chart.variabili.booleane.item("on_exitB"))
			assert("Errore B1: non viene eseguita l' onexit di B1", esecutore.state_chart.variabili.booleane.item("on_exitB1"))
			assert("Errore C: non viene eseguita l' onexit di C", esecutore.state_chart.variabili.booleane.item("on_exitC"))
			assert("Errore C1: non viene eseguita l' onexit di C1", esecutore.state_chart.variabili.booleane.item("on_exitC1"))
			assert("Errore C11: non viene eseguita l' onexit di C11", esecutore.state_chart.variabili.booleane.item("on_exitC11"))
			assert("Errore C11A: non viene eseguita l' onexit di C11A", esecutore.state_chart.variabili.booleane.item("on_exitC11A"))
			assert("Errore C11A1: non viene eseguita l' onexit di C11A1", esecutore.state_chart.variabili.booleane.item("on_exitC11A1"))
			assert("Errore C11B: non viene eseguita l' onexit di C11B", esecutore.state_chart.variabili.booleane.item("on_exitC11B"))
			assert("Errore D: non viene eseguita l' onexit di D", esecutore.state_chart.variabili.booleane.item("on_exitD"))
			assert("Errore T: non viene eseguita l' onexit di T", esecutore.state_chart.variabili.booleane.item("on_exitT"))
		end

		t_onexit_complesso_3
		-- Claudia & Federico 18/05/2020
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "onexit_complesso.xml"
			argomenti [2] := test_data_dir + "onexit_complesso_eventi_3.txt"
			create esecutore.make (argomenti)
			assert("Errore B2: non viene eseguita l' onexit di B2", esecutore.state_chart.variabili.booleane.item("on_exitB2"))
			assert("Errore S: non viene eseguita l' onexit di S", esecutore.state_chart.variabili.booleane.item("on_exitS"))
			assert("Errore A: non viene eseguita l' onexit di A", esecutore.state_chart.variabili.booleane.item("on_exitA"))
			assert("Errore A1: non viene eseguita l' onexit di A1", esecutore.state_chart.variabili.booleane.item("on_exitA1"))
			assert("Errore A11: non viene eseguita l' onexit di A11", esecutore.state_chart.variabili.booleane.item("on_exitA11"))
			assert("Errore A111: non viene eseguita l' onexit di A111", esecutore.state_chart.variabili.booleane.item("on_exitA111"))
			assert("Errore A2: non viene eseguita l' onexit di A2", esecutore.state_chart.variabili.booleane.item("on_exitA2"))
			assert("Errore A21: non viene eseguita l' onexit di A21", esecutore.state_chart.variabili.booleane.item("on_exitA21"))
			assert("Errore B: non viene eseguita l' onexit di B", esecutore.state_chart.variabili.booleane.item("on_exitB"))
			assert("Errore B1: non viene eseguita l' onexit di B1", esecutore.state_chart.variabili.booleane.item("on_exitB1"))
			assert("Errore C: non viene eseguita l' onexit di C", esecutore.state_chart.variabili.booleane.item("on_exitC"))
			assert("Errore C1: non viene eseguita l' onexit di C1", esecutore.state_chart.variabili.booleane.item("on_exitC1"))
			assert("Errore C11: non viene eseguita l' onexit di C11", esecutore.state_chart.variabili.booleane.item("on_exitC11"))
			assert("Errore C11A: non viene eseguita l' onexit di C11A", esecutore.state_chart.variabili.booleane.item("on_exitC11A"))
			assert("Errore C11A1: non viene eseguita l' onexit di C11A1", esecutore.state_chart.variabili.booleane.item("on_exitC11A1"))
			assert("Errore C11B: non viene eseguita l' onexit di C11B", esecutore.state_chart.variabili.booleane.item("on_exitC11B"))
			assert("Errore D: non viene eseguita l' onexit di D", esecutore.state_chart.variabili.booleane.item("on_exitD"))
			assert("Errore T: non viene eseguita l' onexit di T", esecutore.state_chart.variabili.booleane.item("on_exitT"))
		end

	t_storia_azioni_onentry
	-- Arianna & Riccardo 05/07/2020
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "storia_con_parallelo.xml"
  			argomenti [2] := test_data_dir + "storia_con_parallelo_eventi_1.txt"
			create esecutore.make (argomenti)
			assert("ERRORE_P: non viene eseguita l' onentry di P", esecutore.state_chart.variabili.booleane.item ("on_entryP"))
			assert("ERRORE_P2: non viene eseguita l' onentry di P2", esecutore.state_chart.variabili.booleane.item ("on_entryP2"))
			assert("ERRORE_A: non viene eseguita l' onentry di A", esecutore.state_chart.variabili.booleane.item ("on_entryA"))
			assert("ERRORE_B: non viene eseguita l' onentry di B", esecutore.state_chart.variabili.booleane.item ("on_entryB"))
			assert("ERRORE_A2: non viene eseguita l' onentry di A2", esecutore.state_chart.variabili.booleane.item ("on_entryA2"))
			assert("ERRORE_B2: non viene eseguita l' onentry di B2", esecutore.state_chart.variabili.booleane.item ("on_entryB2"))
		end

	t_azioni_con_interi_1_1
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "azioni_con_interi_1.xml"
  			argomenti [2] := test_data_dir + "azioni_con_interi_1_eventi_1.txt"
			create esecutore.make (argomenti)
			assert("ERRORE: il sistema non termina in (Y)", conf_has_state(esecutore.state_chart.config_base,"Y"))
		end

	t_azioni_con_interi_1_2
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "azioni_con_interi_1.xml"
  			argomenti [2] := test_data_dir + "azioni_con_interi_1_eventi_2.txt"
			create esecutore.make (argomenti)
			assert("ERRORE: il sistema non termina in (Y)", esecutore.state_chart.variabili.intere.item ("N") = 20)
			assert("ERRORE: il sistema non termina in (Y)", esecutore.state_chart.variabili.intere.item ("M") = 4)
			assert("ERRORE: il sistema non termina in (Y)", conf_has_state(esecutore.state_chart.config_base,"Y"))
		end

	t_azioni_con_interi_1_3
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "azioni_con_interi_1.xml"
  			argomenti [2] := test_data_dir + "azioni_con_interi_1_eventi_3.txt"
			create esecutore.make (argomenti)
			assert("ERRORE: il sistema non termina in (A1,B2)", conf_has_state(esecutore.state_chart.config_base,"A1") and conf_has_state(esecutore.state_chart.config_base,"B2"))
		end

	t_azioni_con_interi_2_1
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "azioni_con_interi_2.xml"
  			argomenti [2] := test_data_dir + "azioni_con_interi_2_eventi_1.txt"
			create esecutore.make (argomenti)
			assert("ERRORE: il sistema non termina in (P1B, P2B)", conf_has_state(esecutore.state_chart.config_base,"P1B") and conf_has_state(esecutore.state_chart.config_base,"P2B"))
			assert("ERRORE: M è diverso da 0",  esecutore.state_chart.variabili.intere.item ("M") = 0)
     		assert("ERRORE: N è diverso da -1", esecutore.state_chart.variabili.intere.item ("N") = -1)
		end

	t_azioni_con_interi_2_2
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "azioni_con_interi_2.xml"
  			argomenti [2] := test_data_dir + "azioni_con_interi_2_eventi_2.txt"
			create esecutore.make (argomenti)
			assert("ERRORE: il sistema non termina in (C)", conf_has_state(esecutore.state_chart.config_base,"C"))
			assert("ERRORE: M è diverso da 6",  esecutore.state_chart.variabili.intere.item ("M") = 6)
     		assert("ERRORE: N è diverso da 2", esecutore.state_chart.variabili.intere.item ("N") = 2)
		end

	t_azioni_con_interi_2_3
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "azioni_con_interi_2.xml"
  			argomenti [2] := test_data_dir + "azioni_con_interi_2_eventi_3.txt"
			create esecutore.make (argomenti)
			assert("ERRORE: il sistema non termina in (D)", conf_has_state(esecutore.state_chart.config_base,"D"))
			assert("ERRORE: M è diverso da 8",  esecutore.state_chart.variabili.intere.item ("M") = 8)
     		assert("ERRORE: N è diverso da 1", esecutore.state_chart.variabili.intere.item ("N") = 1)
		end

	t_azioni_con_interi_3_1
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "azioni_con_interi_3.xml"
  			argomenti [2] := test_data_dir + "azioni_con_interi_3_eventi_1.txt"
			create esecutore.make (argomenti)
			assert("ERRORE: il sistema non termina in (D)", conf_has_state(esecutore.state_chart.config_base,"D"))
			assert("ERRORE: M è diverso da 3",  esecutore.state_chart.variabili.intere.item ("M") = 3)
     		assert("ERRORE: L è diverso da 10", esecutore.state_chart.variabili.intere.item ("L") = 10)
     		assert("ERRORE: K è diverso da true", esecutore.state_chart.variabili.booleane.item ("K"))
		end

	t_azioni_con_interi_3_2
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "azioni_con_interi_3.xml"
  			argomenti [2] := test_data_dir + "azioni_con_interi_3_eventi_2.txt"
			create esecutore.make (argomenti)
			assert("ERRORE: il sistema non termina in (B1B, B2A)", conf_has_state(esecutore.state_chart.config_base,"B1B") and conf_has_state(esecutore.state_chart.config_base,"B2A"))
			assert("ERRORE: M è diverso da 3",  esecutore.state_chart.variabili.intere.item ("M") = 3)
     		assert("ERRORE: L è diverso da 3", esecutore.state_chart.variabili.intere.item ("L") = 3)
     		assert("ERRORE: K è diverso da false", not esecutore.state_chart.variabili.booleane.item ("K"))
		end

	t_azioni_con_interi_3_variazione_1
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "azioni_con_interi_3_variazione.xml"
  			argomenti [2] := test_data_dir + "azioni_con_interi_3_variazione_eventi_1.txt"
			create esecutore.make (argomenti)
			assert("ERRORE: il sistema non termina in (B1C, B2A)", conf_has_state(esecutore.state_chart.config_base,"B1C") and conf_has_state(esecutore.state_chart.config_base,"B2A"))
			assert("ERRORE: M è diverso da 3",  esecutore.state_chart.variabili.intere.item ("M") = 3)
     		assert("ERRORE: L è diverso da 10", esecutore.state_chart.variabili.intere.item ("L") = 10)
     		assert("ERRORE: K è diverso da true", esecutore.state_chart.variabili.booleane.item ("K"))
		end

	t_azioni_con_interi_3_variazione_2
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "azioni_con_interi_3_variazione.xml"
  			argomenti [2] := test_data_dir + "azioni_con_interi_3_variazione_eventi_2.txt"
			create esecutore.make (argomenti)
			assert("ERRORE: il sistema non termina in (C)", conf_has_state(esecutore.state_chart.config_base,"C"))
			assert("ERRORE: M è diverso da 4",  esecutore.state_chart.variabili.intere.item ("M") = 4)
     		assert("ERRORE: L è diverso da 3", esecutore.state_chart.variabili.intere.item ("L") = 3)
     		assert("ERRORE: K è diverso da true",  esecutore.state_chart.variabili.booleane.item ("K"))
		end

	t_azioni_con_interi_3_variazione_3
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "azioni_con_interi_3_variazione.xml"
  			argomenti [2] := test_data_dir + "azioni_con_interi_3_variazione_eventi_3.txt"
			create esecutore.make (argomenti)
			assert("ERRORE: il sistema non termina in (B1C, B2A)", conf_has_state(esecutore.state_chart.config_base,"B1C") and conf_has_state(esecutore.state_chart.config_base,"B2A"))
			assert("ERRORE: M è diverso da 3",  esecutore.state_chart.variabili.intere.item ("M") = 3)
     		assert("ERRORE: L è diverso da 10", esecutore.state_chart.variabili.intere.item ("L") = 10)
     		assert("ERRORE: K è diverso da true", esecutore.state_chart.variabili.booleane.item ("K"))
		end

	t_azioni_con_interi_3_variazione_4
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "azioni_con_interi_3_variazione.xml"
  			argomenti [2] := test_data_dir + "azioni_con_interi_3_variazione_eventi_4.txt"
			create esecutore.make (argomenti)
			assert("ERRORE: il sistema non termina in (B1A, B2A)", conf_has_state(esecutore.state_chart.config_base,"B1A") and conf_has_state(esecutore.state_chart.config_base,"B2A"))
			assert("ERRORE: M è diverso da 3",  esecutore.state_chart.variabili.intere.item ("M") = 3)
     		assert("ERRORE: L è diverso da 3", esecutore.state_chart.variabili.intere.item ("L") = 3)
     		assert("ERRORE: K è diverso da true", esecutore.state_chart.variabili.booleane.item ("K"))
		end

	t_azioni_con_interi_3_variazione_4_alt
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "azioni_con_interi_3_variazione_alt.xml"
  			argomenti [2] := test_data_dir + "azioni_con_interi_3_variazione_eventi_4.txt"
			create esecutore.make (argomenti)
			assert("ERRORE: il sistema non termina in (B1B, B2A)", conf_has_state(esecutore.state_chart.config_base,"B1B") and conf_has_state(esecutore.state_chart.config_base,"B2A"))
			assert("ERRORE: M è diverso da 3",  esecutore.state_chart.variabili.intere.item ("M") = 3)
     		assert("ERRORE: L è diverso da 3", esecutore.state_chart.variabili.intere.item ("L") = 3)
     		assert("ERRORE: K è diverso da true", esecutore.state_chart.variabili.booleane.item ("K"))
		end

	t_intero_binario
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + "intero_binario.xml"
  			argomenti [2] := test_data_dir + "azioni_con_interi_1_eventi_1.txt"
			create esecutore.make (argomenti)
			assert("ERRORE: il sistema non termina in (Y)", conf_has_state(esecutore.state_chart.config_base,"Y"))
		end
end
