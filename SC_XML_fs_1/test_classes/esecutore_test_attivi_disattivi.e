note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "Arianna Calzuola & Riccardo Malandruccolo"
	date: "01/05/2020"
	revision: "$Revision$"
	testing: "type/manual"

class
	ESECUTORE_TEST_ATTIVI_DISATTIVI

inherit
	ESECUTORE_TEST

feature -- Test routines

	t_test_attivi_inattivi_configurazione_iniziale
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sc_test_attivi_inattivi.xml"
			nomi_files_prova [2] := test_data_dir + "e_xor_1.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE 1.1 non attiva A", attached esecutore.state_chart.stati.item("A") as item and then item.attivo)
			assert ("ERRORE 1.2 non attiva A1", attached esecutore.state_chart.stati.item("A1") as item and then item.attivo)
			assert ("ERRORE 1.3 non attiva A11", attached esecutore.state_chart.stati.item("A11") as item and then item.attivo)
			assert ("ERRORE 1.4 non attiva A111", attached esecutore.state_chart.stati.item("A111") as item and then item.attivo)
			assert ("ERRORE 1.5 non attiva A112", attached esecutore.state_chart.stati.item("A112") as item and then item.attivo)
			assert ("ERRORE 1.6 non attiva A2", attached esecutore.state_chart.stati.item("A2") as item and then item.attivo)
			assert ("ERRORE 1.7 non attiva A21", attached esecutore.state_chart.stati.item("A21") as item and then item.attivo)
			assert ("ERRORE 1.8 non attiva A22", attached esecutore.state_chart.stati.item("A22") as item and then item.attivo)
			assert ("ERRORE 1.9 non attiva A21A", attached esecutore.state_chart.stati.item("A21A") as item and then item.attivo)
			assert ("ERRORE 1.10 non attiva A22A", attached esecutore.state_chart.stati.item("A22A") as item and then item.attivo)
			assert ("ERRORE 1.11 attiva B", attached esecutore.state_chart.stati.item("B") as item and then not item.attivo)

		end


	t_test_inattivi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sc_test_attivi_inattivi.xml"
			nomi_files_prova [2] := test_data_dir + "e_test_inattivi.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE 2.1 non disattiva A111", attached esecutore.state_chart.stati.item("A111") as item and then not item.attivo)
			assert ("ERRORE 2.2 non disattiva A112", attached esecutore.state_chart.stati.item("A112") as item and then not item.attivo)
			assert ("ERRORE 2.3 non disattiva A11", attached esecutore.state_chart.stati.item("A11") as item and then not item.attivo)
			assert ("ERRORE 2.4 non disattiva A1", attached esecutore.state_chart.stati.item("A1") as item and then not item.attivo)
			assert ("ERRORE 2.5 non disattiva A", attached esecutore.state_chart.stati.item("A") as item and then not item.attivo)
			assert ("ERRORE 2.6 non disattiva A21A", attached esecutore.state_chart.stati.item("A21A") as item and then not item.attivo)
			assert ("ERRORE 2.7 non disattiva A22A", attached esecutore.state_chart.stati.item("A22A") as item and then not item.attivo)
			assert ("ERRORE 2.8 non disattiva A21", attached esecutore.state_chart.stati.item("A21") as item and then not item.attivo)
			assert ("ERRORE 2.9 non disattiva A22", attached esecutore.state_chart.stati.item("A22") as item and then not item.attivo)
			assert ("ERRORE 2.10 non disattiva A2", attached esecutore.state_chart.stati.item("A2") as item and then not item.attivo)
		end

	t_test_attivi
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sc_test_attivi_inattivi.xml"
			nomi_files_prova [2] := test_data_dir + "e_test_attivi.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE 3.1 non attiva A111", attached esecutore.state_chart.stati.item("A111") as item and then item.attivo)
			assert ("ERRORE 3.2 non attiva A112", attached esecutore.state_chart.stati.item("A112") as item and then item.attivo)
			assert ("ERRORE 3.3 non attiva A11", attached esecutore.state_chart.stati.item("A11") as item and then item.attivo)
			assert ("ERRORE 3.4 non attiva A1", attached esecutore.state_chart.stati.item("A1") as item and then item.attivo)
			assert ("ERRORE 3.5 non attiva A", attached esecutore.state_chart.stati.item("A") as item and then item.attivo)
			assert ("ERRORE 3.6 non attiva A21A", attached esecutore.state_chart.stati.item("A21A") as item and then item.attivo)
			assert ("ERRORE 3.7 non attiva A22A", attached esecutore.state_chart.stati.item("A22A") as item and then item.attivo)
			assert ("ERRORE 3.8 non attiva A21", attached esecutore.state_chart.stati.item("A21") as item and then item.attivo)
			assert ("ERRORE 3.9 non attiva A22", attached esecutore.state_chart.stati.item("A22") as item and then item.attivo)
			assert ("ERRORE 3.10 non attiva A2", attached esecutore.state_chart.stati.item("A2") as item and then item.attivo)
		end

end


