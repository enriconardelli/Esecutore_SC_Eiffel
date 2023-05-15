note
	description: "Summary description for {CONFIGURAZIONE_TEST_PARENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE_TEST_PARENT

inherit

	ESECUTORE_TEST
		redefine
			on_prepare
		end

feature -- Test routines

	on_prepare
		do
			precursor
			nomi_files_prova [1] := test_data_dir + "xor.xml"
			nomi_files_prova [2] := test_data_dir
		end

feature -- Test

	t_xor_base
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "xor_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto (A1b)", esecutore.state_chart.config_base.count = 1 and esecutore.state_chart.config_base [1].id.is_equal ("A1b"))
			if attached esecutore.state_chart.config_base [1].genitore as sp then
				assert ("ERRORE il sistema non ha istanziato correttamente gli stati (A-A1)", sp.id.is_equal ("A1"))
			end
		end

	t_impostazione_default
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "xor_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			if attached esecutore.state_chart.stati.item ("A") as st then
				if attached st.initial as df then
					assert ("ERRORE il sistema non ha impostato correttamente il default di A", df.count = 1 and df [1].id.is_equal ("A1"))
				end
			end
			if attached esecutore.state_chart.stati.item ("A1") as st then
				if attached st.initial as df then
					assert ("ERRORE il sistema non ha impostato correttamente il default di A1", df.count = 1 and df [1].id.is_equal ("A1b"))
				end
			end
			if attached esecutore.state_chart.stati.item ("B") as st then
				if attached st.initial as df then
					assert ("ERRORE il sistema non ha impostato correttamente il default di B", df.count = 1 and df [1].id.is_equal ("B1"))
				end
			end
		end

	t_impostazione_default_initial_assente
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "xor_initial_assente.xml"
			nomi_files_prova [2] := nomi_files_prova [2] + "xor_initial_assente_eventi.txt"
			create esecutore.make (nomi_files_prova)
			if attached esecutore.state_chart.stati.item ("A") as st then
				if attached st.initial as df then
					assert ("ERRORE il sistema non ha impostato correttamente il default di A", df.count = 1 and df [1].id.is_equal ("A1"))
				end
			end
			if attached esecutore.state_chart.stati.item ("B") as st then
				if attached st.initial as df then
					assert ("ERRORE il sistema non ha impostato correttamente il default di B", df.count = 1 and df [1].id.is_equal ("B1"))
				end
			end
		end

	t_impostazione_default_initial_assente_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "entrata_2_azioni_initial_assente.xml"
			nomi_files_prova [2] := nomi_files_prova [2] + "entrata_2_azioni_initial_assente_eventi.txt"
			create esecutore.make (nomi_files_prova)
			if attached esecutore.state_chart.stati.item ("A") as st then
				if attached st.initial as df then
					assert ("ERRORE il sistema non ha impostato correttamente il default di A", df.count = 1 and df [1].id.is_equal ("A2"))
				end
			end
		end

	t_xor_eventi_semplici
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "xor_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto (B1)", esecutore.state_chart.config_base.count = 1 and esecutore.state_chart.config_base [1].id.is_equal ("B1"))
		end

	t_xor_giro_base_completo
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "xor_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto (B2)", esecutore.state_chart.config_base.count = 1 and esecutore.state_chart.config_base [1].id.is_equal ("B2"))
		end

end
