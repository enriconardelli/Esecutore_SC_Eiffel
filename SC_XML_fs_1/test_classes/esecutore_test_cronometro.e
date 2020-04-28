note
	description: "Summary description for {CONFIGURAZIONE_TEST_CRONOMETRO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE_TEST_CRONOMETRO

inherit
	ESECUTORE_TEST
		redefine on_prepare end

feature -- Test routines

	on_prepare
		do
		    precursor
			nomi_files_prova[1] := test_data_dir + "cronometro_semplice.xml"
			nomi_files_prova[2] := test_data_dir
		end

feature -- Test Cronometro

	t_evolvi_cronometro_1
			-- Il processo dovrebbe arrestarsi nello stato "running"
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "cronometro_semplice_eventi_1.txt"
			create esecutore.make(nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto (RUNNING)", esecutore.conf_base_corrente.count = 1 and esecutore.conf_base_corrente[1].id.is_equal("running") )
		end

	t_evolvi_cronometro_2
			-- Il processo dovrebbe arrestarsi nello stato "stopped"
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "cronometro_semplice_eventi_2.txt"
			create esecutore.make(nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto (STOPPED)", esecutore.conf_base_corrente.count = 1 and esecutore.conf_base_corrente[1].id.is_equal ("stopped"))
		end

	t_evolvi_cronometro_3
			-- Il processo dovrebbe arrestarsi nello stato "reset"
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "cronometro_semplice_eventi_3.txt"
			create esecutore.make(nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto (RESET)", esecutore.conf_base_corrente.count = 1 and esecutore.conf_base_corrente[1].id.is_equal ("reset"))
		end

	t_evolvi_cronometro_4
			-- Il processo dovrebbe arrestarsi nello stato "paused"
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "cronometro_semplice_eventi_4.txt"
			create esecutore.make(nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto (PAUSED)", esecutore.conf_base_corrente.count = 1 and esecutore.conf_base_corrente[1].id.is_equal ("paused"))
		end

	t_evolvi_cronometro_5
			-- Il processo dovrebbe arrestarsi nello stato "running"
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "cronometro_semplice_eventi_5.txt"
			create esecutore.make(nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto (RUNNING)", esecutore.conf_base_corrente.count = 1 and esecutore.conf_base_corrente[1].id.is_equal ("running"))
		end

	t_evolvi_cronometro_6
			-- Il processo dovrebbe arrestarsi nello stato "paused"
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "cronometro_semplice_eventi_multipli_1.txt"
			create esecutore.make(nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto (PAUSED)", esecutore.conf_base_corrente.count = 1 and esecutore.conf_base_corrente[1].id.is_equal ("paused"))
		end

	t_evolvi_cronometro_7
			-- Il processo dovrebbe arrestarsi nello stato "stopped"
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "cronometro_semplice_eventi_multipli_2.txt"
			create esecutore.make(nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto (STOPPED)", esecutore.conf_base_corrente.count = 1 and esecutore.conf_base_corrente[1].id.is_equal ("stopped"))
		end

end
