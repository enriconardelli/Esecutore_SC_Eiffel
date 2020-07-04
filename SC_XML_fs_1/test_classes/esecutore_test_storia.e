note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	ESECUTORE_TEST_STORIA

inherit
	ESECUTORE_TEST

feature -- Test routines

	t_verifica_parallelo_non_ha_storia
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

	t_storia_tra_xor_5
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_tra_xor.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_tra_xor_eventi_5.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (R1)", conf_has_state(esecutore.conf_base_corrente,"R1"))
		end

	t_storia_complesso
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_complesso.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_complesso_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (C)", conf_has_state(esecutore.conf_base_corrente,"C"))
		end

	t_storia_con_parallelo
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "storia_con_parallelo.xml"
  			nomi_files_prova [2] := test_data_dir + "storia_con_parallelo_eventi.txt"
			create esecutore.make (nomi_files_prova)
			assert("ERRORE: il sistema non termina in (A2, B2)", conf_has_state(esecutore.conf_base_corrente,"A2") and conf_has_state(esecutore.conf_base_corrente,"B2"))
		end

end


