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

	t_storie_inscatolate_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storie_inscatolate.xml"
  			nomi_files_prova [2] := test_data_dir + "storie_inscatolate_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R1B,R2A)", conf_has_state(esecutore.conf_base_corrente,"R1B") and conf_has_state(esecutore.conf_base_corrente,"R2A"))
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
		-- verifica che l'ordine in cui vengono salvati gli stati nella storia è corretto
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

	t_storia_con_internal_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S1)", conf_has_state(esecutore.conf_base_corrente,"S1"))
		end

	t_storia_con_internal_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

	t_storia_con_internal_4
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_4.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S1)", conf_has_state(esecutore.conf_base_corrente,"S1"))
		end

	t_storia_con_internal_5
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_5.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S1)", conf_has_state(esecutore.conf_base_corrente,"S1"))
		end

	t_storia_con_internal_6
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_internal.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_internal_eventi_6.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (S2)", conf_has_state(esecutore.conf_base_corrente,"S2"))
		end

end


