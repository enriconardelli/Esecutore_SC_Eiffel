note
	description: "Summary description for {ESECUTORE_TEST_PARALLEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE_TEST_SINCRONIZZAZIONE

inherit
	ESECUTORE_TEST
	redefine
			on_prepare
		end

feature {NONE} -- Supporto

	conf_finale: LINKED_SET [STRING]

feature
	on_prepare
		do
			Precursor
			create conf_finale.make
		end

-- ogni test _1 _2 _3 _4 legge un evento in più
-- versione _alt cambia l'ordine dei sotto-stati paralleli
-- versione _senza_eventi non ha evento sulla transizione

feature -- la condizione viene cambiata dall'azione della TRANSIZIONE

	t_sincronizzazione_1
 		do
 			conf_finale.force("S2")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione.xml", "sincronizzazione_eventi_1.txt", conf_finale)
		end

	t_sincronizzazione_2
 		do
 			conf_finale.force("S1")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione.xml", "sincronizzazione_eventi_2.txt", conf_finale)
		end

	t_sincronizzazione_3
 		do
 			conf_finale.force("S2")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione.xml", "sincronizzazione_eventi_3.txt", conf_finale)
		end

	t_sincronizzazione_4
 		do
 			conf_finale.force("S1")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione.xml", "sincronizzazione_eventi_4.txt", conf_finale)
		end

	t_sincronizzazione_alt_1
 		do
 			conf_finale.force("S2")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_alt.xml", "sincronizzazione_eventi_1.txt", conf_finale)
		end

	t_sincronizzazione_alt_2
 		do
 			conf_finale.force("S1")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_alt.xml", "sincronizzazione_eventi_2.txt", conf_finale)
		end

	t_sincronizzazione_alt_3
 		do
 			conf_finale.force("S2")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_alt.xml", "sincronizzazione_eventi_3.txt", conf_finale)
		end

	t_sincronizzazione_alt_4
 		do
 			conf_finale.force("S1")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_alt.xml", "sincronizzazione_eventi_4.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_1
 		do
 			conf_finale.force("S2")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_senza_eventi.xml", "sincronizzazione_eventi_1.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_2
 		do
 			conf_finale.force("S1")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_senza_eventi.xml", "sincronizzazione_eventi_2.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_3
 		do
 			conf_finale.force("S2")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_senza_eventi.xml", "sincronizzazione_eventi_3.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_4
 		do
 			conf_finale.force("S1")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_senza_eventi.xml", "sincronizzazione_eventi_4.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_alt_1
 		do
 			conf_finale.force("S2")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_senza_eventi_alt.xml", "sincronizzazione_eventi_1.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_alt_2
 		do
 			conf_finale.force("S1")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_senza_eventi_alt.xml", "sincronizzazione_eventi_2.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_alt_3
 		do
 			conf_finale.force("S2")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_senza_eventi_alt.xml", "sincronizzazione_eventi_3.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_alt_4
 		do
 			conf_finale.force("S1")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_senza_eventi_alt.xml", "sincronizzazione_eventi_4.txt", conf_finale)
		end

feature -- la condizione viene cambiata dall'azione ONENTRY

	t_sincronizzazione_onentry_1
 		do
 			conf_finale.force("S2")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_onentry.xml", "sincronizzazione_eventi_1.txt", conf_finale)
		end

	t_sincronizzazione_onentry_2
 		do
 			conf_finale.force("S1")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_onentry.xml", "sincronizzazione_eventi_2.txt", conf_finale)
		end

	t_sincronizzazione_onentry_3
 		do
 			conf_finale.force("S2")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_onentry.xml", "sincronizzazione_eventi_3.txt", conf_finale)
		end

	t_sincronizzazione_onentry_4
 		do
 			conf_finale.force("S1")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_onentry.xml", "sincronizzazione_eventi_4.txt", conf_finale)
		end

	t_sincronizzazione_onentry_alt_1
 		do
 			conf_finale.force("S2")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_onentry_alt.xml", "sincronizzazione_eventi_1.txt", conf_finale)
		end

	t_sincronizzazione_onentry_alt_2
 		do
 			conf_finale.force("S1")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_onentry_alt.xml", "sincronizzazione_eventi_2.txt", conf_finale)
		end

	t_sincronizzazione_onentry_alt_3
 		do
 			conf_finale.force("S2")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_onentry_alt.xml", "sincronizzazione_eventi_3.txt", conf_finale)
		end

	t_sincronizzazione_onentry_alt_4
 		do
 			conf_finale.force("S1")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_onentry_alt.xml", "sincronizzazione_eventi_4.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_onentry_1
 		do
 			conf_finale.force("S2")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_senza_eventi_onentry.xml", "sincronizzazione_eventi_1.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_onentry_2
 		do
 			conf_finale.force("S1")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_senza_eventi_onentry.xml", "sincronizzazione_eventi_2.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_onentry_3
 		do
 			conf_finale.force("S2")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_senza_eventi_onentry.xml", "sincronizzazione_eventi_3.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_onentry_4
 		do
 			conf_finale.force("S1")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_senza_eventi_onentry.xml", "sincronizzazione_eventi_4.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_onentry_alt_1
 		do
 			conf_finale.force("S2")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_senza_eventi_onentry_alt.xml", "sincronizzazione_eventi_1.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_onentry_alt_2
 		do
 			conf_finale.force("S1")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_senza_eventi_onentry_alt.xml", "sincronizzazione_eventi_2.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_onentry_alt_3
 		do
 			conf_finale.force("S2")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_senza_eventi_onentry_alt.xml", "sincronizzazione_eventi_3.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_onentry_alt_4
 		do
 			conf_finale.force("S1")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_senza_eventi_onentry_alt.xml", "sincronizzazione_eventi_4.txt", conf_finale)
		end

feature -- la condizione viene cambiata dall'azione ONEXIT

	t_sincronizzazione_onexit_1
 		do
 			conf_finale.force("S2")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_onexit.xml", "sincronizzazione_eventi_1.txt", conf_finale)
		end

	t_sincronizzazione_onexit_2
 		do
 			conf_finale.force("S1")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_onexit.xml", "sincronizzazione_eventi_2.txt", conf_finale)
		end

	t_sincronizzazione_onexit_3
 		do
 			conf_finale.force("S2")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_onexit.xml", "sincronizzazione_eventi_3.txt", conf_finale)
		end

	t_sincronizzazione_onexit_4
 		do
 			conf_finale.force("S1")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_onexit.xml", "sincronizzazione_eventi_4.txt", conf_finale)
		end

	t_sincronizzazione_onexit_alt_1
 		do
 			conf_finale.force("S2")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_onexit_alt.xml", "sincronizzazione_eventi_1.txt", conf_finale)
		end

	t_sincronizzazione_onexit_alt_2
 		do
 			conf_finale.force("S1")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_onexit_alt.xml", "sincronizzazione_eventi_2.txt", conf_finale)
		end

	t_sincronizzazione_onexit_alt_3
 		do
 			conf_finale.force("S2")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_onexit_alt.xml", "sincronizzazione_eventi_3.txt", conf_finale)
		end

	t_sincronizzazione_onexit_alt_4
 		do
 			conf_finale.force("S1")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_onexit_alt.xml", "sincronizzazione_eventi_4.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_onexit_1
 		do
 			conf_finale.force("S2")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_senza_eventi_onexit.xml", "sincronizzazione_eventi_1.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_onexit_2
 		do
 			conf_finale.force("S1")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_senza_eventi_onexit.xml", "sincronizzazione_eventi_2.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_onexit_3
 		do
 			conf_finale.force("S2")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_senza_eventi_onexit.xml", "sincronizzazione_eventi_3.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_onexit_4
 		do
 			conf_finale.force("S1")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_senza_eventi_onexit.xml", "sincronizzazione_eventi_4.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_onexit_alt_1
 		do
 			conf_finale.force("S2")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_senza_eventi_onexit_alt.xml", "sincronizzazione_eventi_1.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_onexit_alt_2
 		do
 			conf_finale.force("S1")
			conf_finale.force("T2")
			evoluzione_state_chart("sincronizzazione_senza_eventi_onexit_alt.xml", "sincronizzazione_eventi_2.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_onexit_alt_3
 		do
 			conf_finale.force("S2")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_senza_eventi_onexit_alt.xml", "sincronizzazione_eventi_3.txt", conf_finale)
		end

	t_sincronizzazione_senza_eventi_onexit_alt_4
 		do
 			conf_finale.force("S1")
			conf_finale.force("T1")
			evoluzione_state_chart("sincronizzazione_senza_eventi_onexit_alt.xml", "sincronizzazione_eventi_4.txt", conf_finale)
		end
end
