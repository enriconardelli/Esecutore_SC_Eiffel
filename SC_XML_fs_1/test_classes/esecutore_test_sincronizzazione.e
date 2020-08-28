note
	description: "Summary description for {ESECUTORE_TEST_PARALLEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE_TEST_SINCRONIZZAZIONE

inherit
	ESECUTORE_TEST

-- ogni test _1 _2 _3 _4 legge un evento in più
-- versione _alt cambia l'ordine dei sotto-stati paralleli
-- versione _senza_eventi non ha evento sulla transizione

feature -- la condizione viene cambiata dall'azione della TRANSIZIONE

	t_sincronizzazione_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_4
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_4.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_alt_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_alt_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_alt_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_alt_4
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_4.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_senza_eventi_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_senza_eventi_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_senza_eventi_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_senza_eventi_4
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_4.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_senza_eventi_alt_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_senza_eventi_alt_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_senza_eventi_alt_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_senza_eventi_alt_4
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_4.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

feature -- la condizione viene cambiata dall'azione ONENTRY

	t_sincronizzazione_onentry_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_onentry.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_onentry_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_onentry.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_onentry_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_onentry.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_onentry_4
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_onentry.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_4.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_onentry_alt_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_onentry_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_onentry_alt_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_onentry_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_onentry_alt_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_onentry_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_onentry_alt_4
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_onentry_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_4.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_senza_eventi_onentry_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_onentry.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_senza_eventi_onentry_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_onentry.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_senza_eventi_onentry_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_onentry.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_senza_eventi_onentry_4
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_onentry.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_4.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_senza_eventi_onentry_alt_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_onentry_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_senza_eventi_onentry_alt_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_onentry_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_senza_eventi_onentry_alt_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_onentry_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_senza_eventi_onentry_alt_4
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_onentry_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_4.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

feature -- la condizione viene cambiata dall'azione ONEXIT

	t_sincronizzazione_onexit_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_onexit.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_onexit_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_onexit.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_onexit_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_onexit.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_onexit_4
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_onexit.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_4.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_onexit_alt_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_onexit_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_onexit_alt_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_onexit_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_onexit_alt_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_onexit_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_onexit_alt_4
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_onexit_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_4.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_senza_eventi_onexit_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_onexit.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_senza_eventi_onexit_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_onexit.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_senza_eventi_onexit_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_onexit.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_senza_eventi_onexit_4
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_onexit.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_4.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_senza_eventi_onexit_alt_1
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_onexit_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_1.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_senza_eventi_onexit_alt_2
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_onexit_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_2.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T2 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T2") )
		end

	t_sincronizzazione_senza_eventi_onexit_alt_3
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_onexit_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_3.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S2 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S2") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

	t_sincronizzazione_senza_eventi_onexit_alt_4
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "sincronizzazione_senza_eventi_onexit_alt.xml"
			nomi_files_prova [2] := test_data_dir + "sincronizzazione_eventi_4.txt"
			create esecutore.make (nomi_files_prova)
			assert ("ERRORE il sistema non termina negli stati corretti ( S1 T1 )", esecutore.state_chart.conf_base.count = 2 and conf_has_state(esecutore.state_chart.conf_base,"S1") and conf_has_state(esecutore.state_chart.conf_base,"T1") )
		end

end
