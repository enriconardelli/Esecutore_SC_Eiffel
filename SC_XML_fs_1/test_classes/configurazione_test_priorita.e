note
	description: "Summary description for {CONFIGURAZIONE_TEST_PRIORITA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONFIGURAZIONE_TEST_PRIORITA

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

	t_verifica_priorita_semplice
			-- Verifica che le transizioni vengono eseguite con la giusta priorità esplicita.
			-- Caso in cui le transizioni partono dallo stesso <state>
		do
			conf_finale.force ("C")
			evoluzione_state_chart ("priorita_transizione_1.xml", "eventi_vuoto.txt", conf_finale)
		end

	t_verifica_priorita_merge
			-- Verifica che le transizioni vengono eseguite con la giusta priorità esplicita.
			-- Caso in cui le transizioni partono dallo stesso <state>
		do
			conf_finale.force ("A")
			evoluzione_state_chart ("priorita_merge_1.xml", "eventi_vuoto.txt", conf_finale)
		end
end
