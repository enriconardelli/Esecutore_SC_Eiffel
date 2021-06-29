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

	t_verifica_parallelo_non_ha_storia
			-- verifica che <history> come figlio diretto di un parallelo non viene considerato
		do
			conf_finale.force ("A1")
			conf_finale.force ("B1")
			evoluzione_state_chart ("storia_su_parallelo.xml", "storia_su_parallelo_eventi.txt", conf_finale)
		end

	t_storia_tra_xor_1
		do
			conf_finale.force ("P1")
			evoluzione_state_chart ("storia_tra_xor.xml", "storia_tra_xor_eventi_1.txt", conf_finale)
		end

	t_storia_tra_xor_2
		do
			conf_finale.force ("P3")
			evoluzione_state_chart ("storia_tra_xor.xml", "storia_tra_xor_eventi_2.txt", conf_finale)
		end

	t_storia_tra_xor_3
		do
			conf_finale.force ("R2B")
			evoluzione_state_chart ("storia_tra_xor.xml", "storia_tra_xor_eventi_3.txt", conf_finale)
		end

	t_storia_tra_xor_4
		do
			conf_finale.force ("P3")
			evoluzione_state_chart ("storia_tra_xor.xml", "storia_tra_xor_eventi_4.txt", conf_finale)
		end

	t_storia_tra_xor_4_1
		do
			conf_finale.force ("P2")
			evoluzione_state_chart ("storia_tra_xor.xml", "storia_tra_xor_eventi_4_1.txt", conf_finale)
		end

	t_storia_tra_xor_4_2
		do
			conf_finale.force ("R2B")
			evoluzione_state_chart ("storia_tra_xor.xml", "storia_tra_xor_eventi_4_2.txt", conf_finale)
		end

	t_storia_tra_xor_5
		do
			conf_finale.force ("R1")
			evoluzione_state_chart ("storia_tra_xor.xml", "storia_tra_xor_eventi_5.txt", conf_finale)
		end

	t_storia_complesso_1
		do
			conf_finale.force ("C")
			evoluzione_state_chart ("storia_complesso.xml", "storia_complesso_eventi_1.txt", conf_finale)
		end

	t_storia_complesso_2
		do
			conf_finale.force ("R1B")
			conf_finale.force ("R2A")
			conf_finale.force ("S1B")
			conf_finale.force ("S2")
			conf_finale.force ("H1B")
			conf_finale.force ("H2")
			evoluzione_state_chart ("storia_complesso.xml", "storia_complesso_eventi_2.txt", conf_finale)
		end

	t_storia_complesso_3
		do
			conf_finale.force ("R1B")
			conf_finale.force ("R2A")
			conf_finale.force ("P2A2")
			conf_finale.force ("A2A1A")
			evoluzione_state_chart ("storia_complesso.xml", "storia_complesso_eventi_3.txt", conf_finale)
		end

	t_storie_inscatolate_1
		do
			conf_finale.force ("R1A")
			conf_finale.force ("R2A")
			evoluzione_state_chart ("storie_inscatolate.xml", "storie_inscatolate_eventi_1.txt", conf_finale)
		end

	t_storie_inscatolate_1_a
		do
			conf_finale.force ("R1A")
			conf_finale.force ("R2A")
			evoluzione_state_chart ("storie_inscatolate.xml", "storie_inscatolate_eventi_1_a.txt", conf_finale)
		end

	t_storie_inscatolate_2
		do
			conf_finale.force ("R1B")
			conf_finale.force ("R2A")
			evoluzione_state_chart ("storie_inscatolate.xml", "storie_inscatolate_eventi_2.txt", conf_finale)
		end

	t_storie_inscatolate_2_a
		do
			conf_finale.force ("R1A")
			conf_finale.force ("R2B")
			evoluzione_state_chart ("storie_inscatolate.xml", "storie_inscatolate_eventi_2_a.txt", conf_finale)
		end

	t_storie_inscatolate_3
		do
			conf_finale.force ("R1A")
			conf_finale.force ("R2B")
			evoluzione_state_chart ("storie_inscatolate.xml", "storie_inscatolate_eventi_3.txt", conf_finale)
		end

	t_storie_inscatolate_3_a
		do
			conf_finale.force ("R1B")
			conf_finale.force ("R2A")
			evoluzione_state_chart ("storie_inscatolate.xml", "storie_inscatolate_eventi_3_a.txt", conf_finale)
		end

	t_storie_inscatolate_variazione_1
		do
			conf_finale.force ("R1B")
			conf_finale.force ("R2A")
			evoluzione_state_chart ("storie_inscatolate_variazione.xml", "storie_inscatolate_variazione_eventi_1.txt", conf_finale)
		end

	t_storie_inscatolate_variazione_2
		do
			conf_finale.force ("R1B")
			conf_finale.force ("R2A")
			evoluzione_state_chart ("storie_inscatolate_variazione.xml", "storie_inscatolate_variazione_eventi_2.txt", conf_finale)
		end

	t_storie_inscatolate_variazione_3
		do
			conf_finale.force ("R1A")
			conf_finale.force ("R2B")
			evoluzione_state_chart ("storie_inscatolate_variazione.xml", "storie_inscatolate_variazione_eventi_3.txt", conf_finale)
		end

	t_storia_con_parallelo_1
		do
			conf_finale.force ("A2")
			conf_finale.force ("B2")
			evoluzione_state_chart ("storia_con_parallelo.xml", "storia_con_parallelo_eventi_1.txt", conf_finale)
		end

	t_storia_con_parallelo_2
			-- verifica che l'ordine in cui vengono salvati gli stati nella storia è corretto
			-- da aggiornare
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_parallelo.xml"
			nomi_files_prova [2] := test_data_dir + "storia_con_parallelo_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE_parallelo_2_1: la storia non memorizza il giusto numero di stati", (attached esecutore.state_chart.stati.item ("P") as item and then attached {STORIA_DEEP} item.storia as storia and then storia.stati_memorizzati.count = 5))
			assert ("ERRORE_parallelo_2_2: la storia non salva lo stato P2", (attached esecutore.state_chart.stati.item ("P") as item and then attached {STORIA_DEEP} item.storia as storia and then storia.stati_memorizzati [1].id ~ "P2"))
			assert ("ERRORE_parallelo_2_3: la storia non salva lo stato A", (attached esecutore.state_chart.stati.item ("P") as item and then attached {STORIA_DEEP} item.storia as storia and then storia.stati_memorizzati [2].id ~ "A"))
			assert ("ERRORE_parallelo_2_4: la storia non salva lo stato A2", (attached esecutore.state_chart.stati.item ("P") as item and then attached {STORIA_DEEP} item.storia as storia and then storia.stati_memorizzati [3].id ~ "A2"))
			assert ("ERRORE_parallelo_2_5: la storia non salva lo stato B", (attached esecutore.state_chart.stati.item ("P") as item and then attached {STORIA_DEEP} item.storia as storia and then storia.stati_memorizzati [4].id ~ "B"))
			assert ("ERRORE_parallelo_2_6: la storia non salva lo stato B2", (attached esecutore.state_chart.stati.item ("P") as item and then attached {STORIA_DEEP} item.storia as storia and then storia.stati_memorizzati [5].id ~ "B2"))
		end

	t_storia_con_parallelo_3
		do
			conf_finale.force ("A1")
			conf_finale.force ("B1")
			evoluzione_state_chart ("storia_con_parallelo.xml", "storia_con_parallelo_eventi_3.txt", conf_finale)
		end

	t_storia_con_parallelo_variazione_3
		do
			conf_finale.force ("A2")
			conf_finale.force ("B1")
			evoluzione_state_chart ("storia_con_parallelo_variazione.xml", "storia_con_parallelo_variazione_eventi_3.txt", conf_finale)
		end

	t_storia_con_internal_01
		do
			conf_finale.force ("S1")
			evoluzione_state_chart ("storia_con_internal.xml", "storia_con_internal_eventi_01.txt", conf_finale)
		end

	t_storia_con_internal_02
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal.xml", "storia_con_internal_eventi_02.txt", conf_finale)
		end

	t_storia_con_internal_03
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal.xml", "storia_con_internal_eventi_03.txt", conf_finale)
		end

	t_storia_con_internal_04
		do
			conf_finale.force ("S1")
			evoluzione_state_chart ("storia_con_internal.xml", "storia_con_internal_eventi_04.txt", conf_finale)
		end

	t_storia_con_internal_05
		do
			conf_finale.force ("S1")
			evoluzione_state_chart ("storia_con_internal.xml", "storia_con_internal_eventi_05.txt", conf_finale)
		end

	t_storia_con_internal_06
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal.xml", "storia_con_internal_eventi_06.txt", conf_finale)
		end

	t_storia_con_internal_07
		do
			conf_finale.force ("S1")
			evoluzione_state_chart ("storia_con_internal.xml", "storia_con_internal_eventi_07.txt", conf_finale)
		end

	t_storia_con_internal_08
		do
			conf_finale.force ("S1")
			evoluzione_state_chart ("storia_con_internal.xml", "storia_con_internal_eventi_08.txt", conf_finale)
		end

	t_storia_con_internal_09
		do
			conf_finale.force ("S1")
			evoluzione_state_chart ("storia_con_internal.xml", "storia_con_internal_eventi_09.txt", conf_finale)
		end

	t_storia_con_internal_10
		do
			conf_finale.force ("S1")
			evoluzione_state_chart ("storia_con_internal.xml", "storia_con_internal_eventi_10.txt", conf_finale)
		end

	t_storia_con_internal_11
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal.xml", "storia_con_internal_eventi_11.txt", conf_finale)
		end

	t_storia_con_internal_12
		do
			conf_finale.force ("S1")
			evoluzione_state_chart ("storia_con_internal.xml", "storia_con_internal_eventi_12.txt", conf_finale)
		end

	t_storia_con_internal__var_deep_01
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_01.txt", conf_finale)
		end

	t_storia_con_internal__var_deep_02
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_01.txt", conf_finale)
		end

	t_storia_con_internal__var_deep_03
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_03.txt", conf_finale)
		end

	t_storia_con_internal__var_deep_04
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_04.txt", conf_finale)
		end

	t_storia_con_internal__var_deep_05
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_05.txt", conf_finale)
		end

	t_storia_con_internal__var_deep_06
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_06.txt", conf_finale)
		end

	t_storia_con_internal__var_deep_07
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_07.txt", conf_finale)
		end

	t_storia_con_internal__var_deep_08
		do
			conf_finale.force ("S1")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_08.txt", conf_finale)
		end

	t_storia_con_internal__var_deep_09
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_09.txt", conf_finale)
		end

	t_storia_con_internal__var_deep_10
		do
			conf_finale.force ("S1")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_10.txt", conf_finale)
		end

	t_storia_con_internal__var_deep_11
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_11.txt", conf_finale)
		end

	t_storia_con_internal__var_deep_12
		do
			conf_finale.force ("S1")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_12.txt", conf_finale)
		end

	t_storia_con_internal__var_shallow_01
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_01.txt", conf_finale)
		end

	t_storia_con_internal__var_shallow_02
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_02.txt", conf_finale)
		end

	t_storia_con_internal__var_shallow_03
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_03.txt", conf_finale)
		end

	t_storia_con_internal__var_shallow_04
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_04.txt", conf_finale)
		end

	t_storia_con_internal__var_shallow_05
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_05.txt", conf_finale)
		end

	t_storia_con_internal__var_shallow_06
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_06.txt", conf_finale)
		end

	t_storia_con_internal__var_shallow_07
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_07.txt", conf_finale)
		end

	t_storia_con_internal__var_shallow_08
		do
			conf_finale.force ("S1")
			evoluzione_state_chart ("storia_con_internal__var_deep.xml", "storia_con_internal_eventi_08.txt", conf_finale)
		end

	t_storia_con_internal__var_shallow_09
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal__var_shallow.xml", "storia_con_internal_eventi_09.txt", conf_finale)
		end

	t_storia_con_internal__var_shallow_10
		do
			conf_finale.force ("S1")
			evoluzione_state_chart ("storia_con_internal__var_shallow.xml", "storia_con_internal_eventi_10.txt", conf_finale)
		end

	t_storia_con_internal__var_shallow_11
		do
			conf_finale.force ("S2")
			evoluzione_state_chart ("storia_con_internal__var_shallow.xml", "storia_con_internal_eventi_11.txt", conf_finale)
		end

	t_storia_con_internal__var_shallow_12
		do
			conf_finale.force ("S1")
			evoluzione_state_chart ("storia_con_internal__var_shallow.xml", "storia_con_internal_eventi_12.txt", conf_finale)
		end

	t_parallelo_con_storie_multiple_01
		do
			conf_finale.force ("P1B")
			conf_finale.force ("P2B2")
			conf_finale.force ("P3B")
			evoluzione_state_chart ("parallelo_con_storie_multiple.xml", "parallelo_con_storie_multiple_eventi_01.txt", conf_finale)
		end

	t_parallelo_con_storie_multiple_02
		do
			conf_finale.force ("P1B")
			conf_finale.force ("P2B2")
			conf_finale.force ("P3B")
			evoluzione_state_chart ("parallelo_con_storie_multiple.xml", "parallelo_con_storie_multiple_eventi_02.txt", conf_finale)
		end

	t_parallelo_con_storie_multiple_03
		do
			conf_finale.force ("P1B")
			conf_finale.force ("P2B2")
			conf_finale.force ("P3A")
			evoluzione_state_chart ("parallelo_con_storie_multiple.xml", "parallelo_con_storie_multiple_eventi_03.txt", conf_finale)
		end

	t_parallelo_con_storie_multiple_04
		do
			conf_finale.force ("P1A")
			conf_finale.force ("P2B1")
			conf_finale.force ("P3B")
			evoluzione_state_chart ("parallelo_con_storie_multiple.xml", "parallelo_con_storie_multiple_eventi_04.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_01
		do
			conf_finale.force ("Q")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_01.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_02
		do
			conf_finale.force ("P1B")
			conf_finale.force ("P2A")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_02.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_03
		do
			conf_finale.force ("Q")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_03.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_04
		do
			conf_finale.force ("I2")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_04.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_05
		do
			conf_finale.force ("P1A")
			conf_finale.force ("P2A")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_05.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_06
		do
			conf_finale.force ("S")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_06.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_06_a
		do
			conf_finale.force ("S")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_06_a.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_06_b
		do
			conf_finale.force ("P1B")
			conf_finale.force ("P2B")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_06_b.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_06_c
		do
			conf_finale.force ("Q")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_06_c.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_06_d
		do
			conf_finale.force ("R1")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_06_d.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_07
		do
			conf_finale.force ("R2")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_07.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_08
		do
			conf_finale.force ("P1B")
			conf_finale.force ("P2A")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_08.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_09
		do
			conf_finale.force ("P1B")
			conf_finale.force ("P2B")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_09.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_10
		do
			conf_finale.force ("R2")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_10.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_11
		do
			conf_finale.force ("Q")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_11.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_11_a
		do
			conf_finale.force ("Q")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_11_a.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_11_b
		do
			conf_finale.force ("Q")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_11_b.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_12
		do
			conf_finale.force ("R1")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_12.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_13
		do
			conf_finale.force ("Q")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_13.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_13_a
		do
			conf_finale.force ("P1B")
			conf_finale.force ("P2B")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_13_a.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_13_b
		do
			conf_finale.force ("Q")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_13_b.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_13_c
		do
			conf_finale.force ("P1A")
			conf_finale.force ("P2A")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_13_c.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_14
		do
			conf_finale.force ("Q")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_14.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_15
		do
			conf_finale.force ("S")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_15.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_16
		do
			conf_finale.force ("Q")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_16.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_16_a
		do
			conf_finale.force ("Q")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_16_a.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_17
		do
			conf_finale.force ("Q")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_17.txt", conf_finale)
		end

	t_storie_inscatolate_complesso_17_a
		do
			conf_finale.force ("Q")
			evoluzione_state_chart ("storie_inscatolate_complesso.xml", "storie_inscatolate_complesso_eventi_17_a.txt", conf_finale)
		end

	t_storie_inscatolate_alternativo_03
		do
			conf_finale.force ("Q")
			evoluzione_state_chart ("storie_inscatolate_alternativo.xml", "storie_inscatolate_alternativo_eventi_03.txt", conf_finale)
		end

	t_storie_inscatolate_alternativo_03_a
		do
			conf_finale.force ("F2")
			evoluzione_state_chart ("storie_inscatolate_alternativo.xml", "storie_inscatolate_alternativo_eventi_03_a.txt", conf_finale)
		end

	t_storie_inscatolate_alternativo_03_b
		do
			conf_finale.force ("Q")
			evoluzione_state_chart ("storie_inscatolate_alternativo.xml", "storie_inscatolate_alternativo_eventi_03_b.txt", conf_finale)
		end

	t_storie_inscatolate_alternativo_03_c
		do
			conf_finale.force ("F2")
			evoluzione_state_chart ("storie_inscatolate_alternativo.xml", "storie_inscatolate_alternativo_eventi_03_c.txt", conf_finale)
		end

	t_storie_inscatolate_alternativo_07
		do
			conf_finale.force ("R2")
			evoluzione_state_chart ("storie_inscatolate_alternativo.xml", "storie_inscatolate_alternativo_eventi_07.txt", conf_finale)
		end

	t_storie_inscatolate_alternativo_07_a
		do
			conf_finale.force ("F2")
			evoluzione_state_chart ("storie_inscatolate_alternativo.xml", "storie_inscatolate_alternativo_eventi_07_a.txt", conf_finale)
		end

	t_storie_inscatolate_alternativo_15
		do
			conf_finale.force ("S")
			evoluzione_state_chart ("storie_inscatolate_alternativo.xml", "storie_inscatolate_alternativo_eventi_15.txt", conf_finale)
		end

	t_storie_inscatolate_alternativo_15_a
		do
			conf_finale.force ("F2")
			evoluzione_state_chart ("storie_inscatolate_alternativo.xml", "storie_inscatolate_alternativo_eventi_15_a.txt", conf_finale)
		end

	t_storie_inscatolate_alternativo_16
		do
			conf_finale.force ("S")
			evoluzione_state_chart ("storie_inscatolate_alternativo.xml", "storie_inscatolate_alternativo_eventi_16.txt", conf_finale)
		end

	t_storie_inscatolate_alternativo_16_a
		do
			conf_finale.force ("Q")
			evoluzione_state_chart ("storie_inscatolate_alternativo.xml", "storie_inscatolate_alternativo_eventi_16_a.txt", conf_finale)
		end

	t_storie_inscatolate_alternativo_16_b
		do
			conf_finale.force ("Q")
			evoluzione_state_chart ("storie_inscatolate_alternativo.xml", "storie_inscatolate_alternativo_eventi_16_b.txt", conf_finale)
		end

	t_storie_inscatolate_alternativo_16_c
		do
			conf_finale.force ("P1B")
			conf_finale.force ("P2A")
			evoluzione_state_chart ("storie_inscatolate_alternativo.xml", "storie_inscatolate_alternativo_eventi_16_c.txt", conf_finale)
		end

	t_storie_inscatolate_alternativo_17
		do
			conf_finale.force ("F1")
			evoluzione_state_chart ("storie_inscatolate_alternativo.xml", "storie_inscatolate_alternativo_eventi_17.txt", conf_finale)
		end

	t_storie_inscatolate_alternativo_17_a
		do
			conf_finale.force ("P1B")
			conf_finale.force ("P2B")
			evoluzione_state_chart ("storie_inscatolate_alternativo.xml", "storie_inscatolate_alternativo_eventi_17_a.txt", conf_finale)
		end

	t_storie_inscatolate_alternativo_17_b
		do
			conf_finale.force ("P1B")
			conf_finale.force ("P2B")
			evoluzione_state_chart ("storie_inscatolate_alternativo.xml", "storie_inscatolate_alternativo_eventi_17_b.txt", conf_finale)
		end

	t_storie_inscatolate_alternativo_17_c
		do
			conf_finale.force ("P1B")
			conf_finale.force ("P2A")
			evoluzione_state_chart ("storie_inscatolate_alternativo.xml", "storie_inscatolate_alternativo_eventi_17_c.txt", conf_finale)
		end

end
