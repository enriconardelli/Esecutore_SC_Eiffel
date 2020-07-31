note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "04/07/20"
	revision: "$Revision$"
	testing: "type/manual"

class
	ESECUTORE_TEST_STORIA

inherit
	ESECUTORE_TEST

feature -- Test routines

	t_verifica_parallelo_non_ha_storia
		-- verifica che <history> come figlio diretto di un parallelo non viene considerato
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_su_parallelo.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_su_parallelo_eventi.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (A1,B1)", conf_has_state(esecutore.conf_base_corrente,"A1") and conf_has_state(esecutore.conf_base_corrente,"B1"))
		end

	t_storia_tra_xor_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_tra_xor.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_tra_xor_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (P1)", conf_has_state(esecutore.conf_base_corrente,"P1"))
		end

	t_storia_tra_xor_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_tra_xor.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_tra_xor_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (P3)", conf_has_state(esecutore.conf_base_corrente,"P3"))
		end

	t_storia_tra_xor_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_tra_xor.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_tra_xor_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R2B)", conf_has_state(esecutore.conf_base_corrente,"R2B"))
		end

	t_storia_tra_xor_4
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_tra_xor.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_tra_xor_eventi_4.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (P3)", conf_has_state(esecutore.conf_base_corrente,"P3"))
		end

	t_storia_tra_xor_4_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_tra_xor.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_tra_xor_eventi_4_1.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (P2)", conf_has_state(esecutore.conf_base_corrente,"P2"))
		end

	t_storia_tra_xor_4_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_tra_xor.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_tra_xor_eventi_4_2.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R2B)", conf_has_state(esecutore.conf_base_corrente,"R2B"))
		end

	t_storia_tra_xor_5
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_tra_xor.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_tra_xor_eventi_5.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R1)", conf_has_state(esecutore.conf_base_corrente,"R1"))
		end

	t_storia_complesso_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_complesso.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_complesso_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (C)", conf_has_state(esecutore.conf_base_corrente,"C"))
		end

	t_storia_complesso_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_complesso.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_complesso_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R1B,R2A,S1B,S2,H1B,H2)", conf_has_state(esecutore.conf_base_corrente,"R1B") and conf_has_state(esecutore.conf_base_corrente,"R2A") and conf_has_state(esecutore.conf_base_corrente,"S1B") and conf_has_state(esecutore.conf_base_corrente,"S2") and conf_has_state(esecutore.conf_base_corrente,"H1B") and conf_has_state(esecutore.conf_base_corrente,"H2"))
		end

	t_storia_complesso_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_complesso.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_complesso_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R1B,R2A,P2A2,A2A1A)", conf_has_state(esecutore.conf_base_corrente,"R1B") and conf_has_state(esecutore.conf_base_corrente,"R2A") and conf_has_state(esecutore.conf_base_corrente,"P2A2") and conf_has_state(esecutore.conf_base_corrente,"A2A1A"))
		end

	t_storie_inscatolate_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R1A,R2A)", conf_has_state(esecutore.conf_base_corrente,"R1A") and conf_has_state(esecutore.conf_base_corrente,"R2A"))
		end

	t_storie_inscatolate_1_a
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_eventi_1_a.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R1A,R2A)", conf_has_state(esecutore.conf_base_corrente,"R1A") and conf_has_state(esecutore.conf_base_corrente,"R2A"))
		end

	t_storie_inscatolate_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R1B,R2A)", conf_has_state(esecutore.conf_base_corrente,"R1B") and conf_has_state(esecutore.conf_base_corrente,"R2A"))
		end

	t_storie_inscatolate_2_a
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_eventi_2_a.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R1A,R2B)", conf_has_state(esecutore.conf_base_corrente,"R1A") and conf_has_state(esecutore.conf_base_corrente,"R2B"))
		end

	t_storie_inscatolate_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R1A,R2B)", conf_has_state(esecutore.conf_base_corrente,"R1A") and conf_has_state(esecutore.conf_base_corrente,"R2B"))
		end

	t_storie_inscatolate_3_a
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_eventi_3_a.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R1B,R2A)", conf_has_state(esecutore.conf_base_corrente,"R1B") and conf_has_state(esecutore.conf_base_corrente,"R2A"))
		end

	t_storie_inscatolate_variazione_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate_variazione.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_variazione_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R1B,R2A)", conf_has_state(esecutore.conf_base_corrente,"R1B") and conf_has_state(esecutore.conf_base_corrente,"R2A"))
		end

	t_storie_inscatolate_variazione_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate_variazione.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_variazione_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R1B,R2A)", conf_has_state(esecutore.conf_base_corrente,"R1B") and conf_has_state(esecutore.conf_base_corrente,"R2A"))
		end

	t_storie_inscatolate_variazione_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate_variazione.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_variazione_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R1A,R2B)", conf_has_state(esecutore.conf_base_corrente,"R1A") and conf_has_state(esecutore.conf_base_corrente,"R2B"))
		end

	t_storia_con_parallelo_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_parallelo.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_parallelo_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (A2, B2)", conf_has_state(esecutore.conf_base_corrente,"A2") and conf_has_state(esecutore.conf_base_corrente,"B2"))
		end

	t_storia_con_parallelo_2
		-- verifica che l'ordine in cui vengono salvati gli stati nella storia � corretto
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_parallelo.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_parallelo_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE_parallelo_2_1: la storia non memorizza il giusto numero di stati", (attached esecutore.state_chart.stati.item("P") as item and then attached{STORIA_DEEP} item.storia as storia and then storia.stati_memorizzati.count = 5))
			assert("ERRORE_parallelo_2_2: la storia non salva lo stato P2", (attached esecutore.state_chart.stati.item("P") as item and then attached{STORIA_DEEP} item.storia as storia and then storia.stati_memorizzati[1].id ~ "P2"))
			assert("ERRORE_parallelo_2_3: la storia non salva lo stato A", (attached esecutore.state_chart.stati.item("P") as item and then attached{STORIA_DEEP} item.storia as storia and then storia.stati_memorizzati[2].id ~ "A"))
			assert("ERRORE_parallelo_2_4: la storia non salva lo stato A2", (attached esecutore.state_chart.stati.item("P") as item and then attached{STORIA_DEEP} item.storia as storia and then storia.stati_memorizzati[3].id ~ "A2"))
			assert("ERRORE_parallelo_2_5: la storia non salva lo stato B", (attached esecutore.state_chart.stati.item("P") as item and then attached{STORIA_DEEP} item.storia as storia and then storia.stati_memorizzati[4].id ~ "B"))
			assert("ERRORE_parallelo_2_6: la storia non salva lo stato B2", (attached esecutore.state_chart.stati.item("P") as item and then attached{STORIA_DEEP} item.storia as storia and then storia.stati_memorizzati[5].id ~ "B2"))
		end

	t_storia_con_parallelo_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_parallelo.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_parallelo_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (A1, B1)", conf_has_state(esecutore.conf_base_corrente,"A1") and conf_has_state(esecutore.conf_base_corrente,"B1"))
		end

	t_storia_con_parallelo_variazione_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_parallelo_variazione.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_parallelo_variazione_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (A2, B1)", conf_has_state(esecutore.conf_base_corrente,"A2") and conf_has_state(esecutore.conf_base_corrente,"B1"))
		end

	t_storia_con_internal_01
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_01.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S1)", conf_has_state(esecutore.conf_base_corrente,"S1"))
		end

	t_storia_con_internal_02
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_02.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal_03
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_03.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal_04
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_04.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S1)", conf_has_state(esecutore.conf_base_corrente,"S1"))
		end

	t_storia_con_internal_05
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_05.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S1)", conf_has_state(esecutore.conf_base_corrente,"S1"))
		end

	t_storia_con_internal_06
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_06.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal_07
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_07.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S1)", conf_has_state(esecutore.conf_base_corrente,"S1"))
		end

	t_storia_con_internal_08
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_08.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S1)", conf_has_state(esecutore.conf_base_corrente,"S1"))
		end

	t_storia_con_internal_09
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_09.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S1)", conf_has_state(esecutore.conf_base_corrente,"S1"))
		end

	t_storia_con_internal_10
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_10.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S1)", conf_has_state(esecutore.conf_base_corrente,"S1"))
		end

	t_storia_con_internal_11
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_11.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal_12
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_12.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S1)", conf_has_state(esecutore.conf_base_corrente,"S1"))
		end

	t_storia_con_internal__var_deep_01
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_deep.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_01.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal__var_deep_02
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_deep.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_02.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal__var_deep_03
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_deep.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_03.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal__var_deep_04
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_deep.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_04.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal__var_deep_05
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_deep.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_05.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal__var_deep_06
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_deep.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_06.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal__var_deep_07
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_deep.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_07.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal__var_deep_08
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_deep.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_08.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S1)", conf_has_state(esecutore.conf_base_corrente,"S1"))
		end

	t_storia_con_internal__var_deep_09
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_deep.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_09.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal__var_deep_10
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_deep.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_10.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S1)", conf_has_state(esecutore.conf_base_corrente,"S1"))
		end

	t_storia_con_internal__var_deep_11
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_deep.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_11.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal__var_deep_12
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_deep.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_12.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S1)", conf_has_state(esecutore.conf_base_corrente,"S1"))
		end

	t_storia_con_internal__var_shallow_01
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_shallow.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_01.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal__var_shallow_02
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_shallow.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_02.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal__var_shallow_03
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_shallow.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_03.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal__var_shallow_04
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_shallow.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_04.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal__var_shallow_05
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_shallow.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_05.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal__var_shallow_06
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_shallow.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_06.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal__var_shallow_07
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_shallow.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_07.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal__var_shallow_08
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_shallow.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_08.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S1)", conf_has_state(esecutore.conf_base_corrente,"S1"))
		end


	t_storia_con_internal__var_shallow_09
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_shallow.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_09.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal__var_shallow_10
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_shallow.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_10.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S1)", conf_has_state(esecutore.conf_base_corrente,"S1"))
		end

	t_storia_con_internal__var_shallow_11
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_shallow.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_11.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal__var_shallow_12
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal__var_shallow.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_12.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S1)", conf_has_state(esecutore.conf_base_corrente,"S1"))
		end

	t_parallelo_con_storie_multiple_01
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "parallelo_con_storie_multiple.xml"
  			nomi_files_prova [2] := test_data_dir + "parallelo_con_storie_multiple_eventi_01.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (P1B, P2B2, P3B)", conf_has_state(esecutore.conf_base_corrente,"P1B") and conf_has_state(esecutore.conf_base_corrente,"P2B2") and conf_has_state(esecutore.conf_base_corrente,"P3B"))
		end

	t_parallelo_con_storie_multiple_02
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "parallelo_con_storie_multiple.xml"
  			nomi_files_prova [2] := test_data_dir + "parallelo_con_storie_multiple_eventi_02.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (P1B, P2B2, P3B)", conf_has_state(esecutore.conf_base_corrente,"P1B") and conf_has_state(esecutore.conf_base_corrente,"P2B2") and conf_has_state(esecutore.conf_base_corrente,"P3B"))
		end

	t_parallelo_con_storie_multiple_03
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "parallelo_con_storie_multiple.xml"
  			nomi_files_prova [2] := test_data_dir + "parallelo_con_storie_multiple_eventi_03.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (P1B, P2B2, P3A)", conf_has_state(esecutore.conf_base_corrente,"P1B") and conf_has_state(esecutore.conf_base_corrente,"P2B2") and conf_has_state(esecutore.conf_base_corrente,"P3A"))
		end

	t_parallelo_con_storie_multiple_04
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "parallelo_con_storie_multiple.xml"
  			nomi_files_prova [2] := test_data_dir + "parallelo_con_storie_multiple_eventi_04.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (P1A, P2B1, P3B)", conf_has_state(esecutore.conf_base_corrente,"P1A") and conf_has_state(esecutore.conf_base_corrente,"P2B1") and conf_has_state(esecutore.conf_base_corrente,"P3B"))
		end

	t_storie_inscatolate_complesso_01
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate_complesso.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_complesso_eventi_01.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (Q)", conf_has_state(esecutore.conf_base_corrente,"Q"))
		end

	t_storie_inscatolate_complesso_02
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate_complesso.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_complesso_eventi_02.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (P1B,P2A)", conf_has_state(esecutore.conf_base_corrente,"P1B") and conf_has_state(esecutore.conf_base_corrente,"P2A"))
		end

	t_storie_inscatolate_complesso_03
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate_complesso.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_complesso_eventi_03.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (Q)", conf_has_state(esecutore.conf_base_corrente,"Q"))
		end

	t_storie_inscatolate_complesso_04
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate_complesso.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_complesso_eventi_04.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (I2)", conf_has_state(esecutore.conf_base_corrente,"I2"))
		end

	t_storie_inscatolate_complesso_05
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate_complesso.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_complesso_eventi_05.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (P1A,P2A)", conf_has_state(esecutore.conf_base_corrente,"P1A") and conf_has_state(esecutore.conf_base_corrente,"P2A"))
		end

	t_storie_inscatolate_complesso_06
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate_complesso.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_complesso_eventi_06.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S)", conf_has_state(esecutore.conf_base_corrente,"S"))
		end

	t_storie_inscatolate_complesso_07
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate_complesso.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_complesso_eventi_07.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R2)", conf_has_state(esecutore.conf_base_corrente,"R2"))
		end

	t_storie_inscatolate_complesso_08
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate_complesso.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_complesso_eventi_08.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (P1B,P2A)", conf_has_state(esecutore.conf_base_corrente,"P1B") and conf_has_state(esecutore.conf_base_corrente,"P2A"))
		end

	t_storie_inscatolate_complesso_09
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate_complesso.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_complesso_eventi_09.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (P1B,P2B)", conf_has_state(esecutore.conf_base_corrente,"P1B") and conf_has_state(esecutore.conf_base_corrente,"P2B"))
		end

	t_storie_inscatolate_complesso_10
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate_complesso.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_complesso_eventi_10.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R2)", conf_has_state(esecutore.conf_base_corrente,"R2"))
		end

	t_storie_inscatolate_complesso_11
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate_complesso.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_complesso_eventi_11.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (Q)", conf_has_state(esecutore.conf_base_corrente,"Q"))
		end
	t_storie_inscatolate_complesso_12
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate_complesso.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_complesso_eventi_12.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R1)", conf_has_state(esecutore.conf_base_corrente,"R1"))
		end
end


