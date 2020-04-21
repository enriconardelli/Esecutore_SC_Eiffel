note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	STATO_TEST

inherit

	EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Supporto

	stato_prova, stato_prova_senza_evento: STATO

	target_prova_1, target_prova_2, target_prova_3: STATO

	target_prova_senza_evento_1, target_prova_senza_evento_2, target_prova_senza_evento_3: STATO

	transizione_prova_1, transizione_prova_2, transizione_prova_3: TRANSIZIONE

	transizione_prova_senza_evento_1, transizione_prova_senza_evento_2, transizione_prova_senza_evento_3: TRANSIZIONE

	cond_prova, cond_prova_senza_evento: HASH_TABLE [BOOLEAN, STRING]

	eventi_prova: LINKED_SET [STRING]

feature {NONE} -- Events

	on_prepare
		do
			-- creo stato di prova con evento
			-- ha 3 transizioni che portano su 3 target distinti
			-- la transizione con evento1 e cond1 porta a target_1
			-- la transizione con evento2 e cond2 porta a target_2
			-- la transizione con evento3 e cond3 porta a target_3
			create stato_prova.make_with_id ("stato_prova")
			create target_prova_1.make_with_id ("target_prova_1")
			create transizione_prova_1.make_with_target (target_prova_1, stato_prova)
			transizione_prova_1.set_evento ("evento1")
			transizione_prova_1.set_condizione ("cond1")
			stato_prova.aggiungi_transizione (transizione_prova_1)
			create target_prova_2.make_with_id ("target_prova_2")
			create transizione_prova_2.make_with_target (target_prova_2, stato_prova)
			transizione_prova_2.set_evento ("evento2")
			transizione_prova_2.set_condizione ("cond2")
			stato_prova.aggiungi_transizione (transizione_prova_2)
			create target_prova_3.make_with_id ("target_prova_3")
			create transizione_prova_3.make_with_target (target_prova_3, stato_prova)
			transizione_prova_3.set_evento ("evento1")
			transizione_prova_3.set_condizione ("cond3")
			stato_prova.aggiungi_transizione (transizione_prova_3)
--			if attached stato_prova as sp then
--				if attached target_prova_1 as tp1 then
--					create transizione_prova_1.make_with_target (tp1,sp)
--				end
--				if attached target_prova_2 as tp2 then
--					create transizione_prova_2.make_with_target (tp2,sp)
--				end
--				if attached target_prova_3 as tp3 then
--					create transizione_prova_3.make_with_target (tp3,sp)
--				end
--			end
--			if attached transizione_prova_1 as trp1 then
--				trp1.set_evento ("evento1")
--				trp1.set_condizione ("cond1")
--				if attached stato_prova as sp then
--					sp.aggiungi_transizione (trp1)
--				end
--			end
--			if attached transizione_prova_2 as trp2 then
--				trp2.set_evento ("evento2")
--				trp2.set_condizione ("cond2")
--				if attached stato_prova as sp then
--					sp.aggiungi_transizione (trp2)
--				end
--			end
--			if attached transizione_prova_3 as trp3 then
--				trp3.set_evento ("evento1")
--				trp3.set_condizione ("cond3")
--				if attached stato_prova as sp then
--					sp.aggiungi_transizione (trp3)
--				end
--			end
			create cond_prova.make (3)
			cond_prova.put (False, "cond1")
			cond_prova.put (False, "cond2")
			cond_prova.put (False, "cond3")

			--creo stato di prova senza evento
			-- ha 3 transizioni che portano su 3 target distinti
			-- la transizione con cond1 porta a target_1
			-- la transizione con cond2 porta a target_2
			-- la transizione con cond2 porta a target_3
			create stato_prova_senza_evento.make_final_with_id ("stato_prova_senza_evento")
			create target_prova_senza_evento_1.make_with_id ("target_prova_senza_evento_1")
			create transizione_prova_senza_evento_1.make_with_target (target_prova_senza_evento_1, stato_prova_senza_evento)
			transizione_prova_senza_evento_1.set_condizione ("cond1")
			stato_prova_senza_evento.aggiungi_transizione (transizione_prova_senza_evento_1)
			create target_prova_senza_evento_2.make_with_id ("target_prova_senza_evento_2")
			create transizione_prova_senza_evento_2.make_with_target (target_prova_senza_evento_2, stato_prova_senza_evento)
			transizione_prova_senza_evento_2.set_condizione ("cond2")
			stato_prova_senza_evento.aggiungi_transizione (transizione_prova_senza_evento_2)
			create target_prova_senza_evento_3.make_with_id ("target_prova_senza_evento_3")
			create transizione_prova_senza_evento_3.make_with_target (target_prova_senza_evento_3, stato_prova_senza_evento)
			transizione_prova_senza_evento_3.set_condizione ("cond2")
			stato_prova_senza_evento.aggiungi_transizione (transizione_prova_senza_evento_3)
--			if attached stato_prova_senza_evento as spse then
--				if attached target_prova_senza_evento_1 as tpse1 then
--					create transizione_prova_senza_evento_1.make_with_target (tpse1,spse)
--				end
--				if attached target_prova_senza_evento_2 as tpse2 then
--					create transizione_prova_senza_evento_2.make_with_target (tpse2,spse)
--				end
--				if attached target_prova_senza_evento_3 as tpse3 then
--					create transizione_prova_senza_evento_3.make_with_target (tpse3,spse)
--				end
--			end
--			if attached transizione_prova_senza_evento_1 as trpse1 then
--				trpse1.set_condizione ("cond1")
--				if attached stato_prova_senza_evento as spse then
--					spse.aggiungi_transizione (trpse1)
--				end
--			end
--			if attached transizione_prova_senza_evento_2 as trpse2 then
--				trpse2.set_condizione ("cond2")
--				if attached stato_prova_senza_evento as spse then
--					spse.aggiungi_transizione (trpse2)
--				end
--			end
--			if attached transizione_prova_senza_evento_3 as trpse3 then
--				trpse3.set_condizione ("cond2")
--				if attached stato_prova_senza_evento as spse then
--					spse.aggiungi_transizione (trpse3)
--				end
--			end
			create cond_prova_senza_evento.make (2)
			cond_prova_senza_evento.put (False, "cond1")
			cond_prova_senza_evento.put (False, "cond2")
			create eventi_prova.make
			eventi_prova.compare_objects
			eventi_prova.force ("evento1")
			eventi_prova.force ("evento2")
			eventi_prova.force ("evento3")
		end

feature -- Test routines

	set_cond_prova (b1, b2, b3: BOOLEAN)
		do
			cond_prova.replace (b1, "cond1")
			cond_prova.replace (b2, "cond2")
			cond_prova.replace (b3, "cond3")
		end

	set_cond_prova_senza_evento (b1, b2: BOOLEAN)
		do
			cond_prova_senza_evento.replace (b1, "cond1")
			cond_prova_senza_evento.replace (b2, "cond2")
		end

	set_eventi_prova (b1, b2, b3: STRING)
		do
			eventi_prova.wipe_out
			eventi_prova.force (b1)
			eventi_prova.force (b2)
			eventi_prova.force (b3)
		end

	t_make_with_id
		do
			create stato_prova.make_with_id ("stato_prova")
--			if attached stato_prova as sp then
				assert ("id NON è 'stato_prova'", stato_prova.id ~ "stato_prova")
				assert ("final NON è 'false'", not stato_prova.finale)
--			end
		end

	t_set_final
		do
			create stato_prova.make_with_id ("stato_prova")
--			if attached stato_prova as sp then
				stato_prova.set_final
				assert ("final NON è 'true'", stato_prova.finale)
--			end
		end

	t_set_OnEntry
		local
			azione_prova: STAMPA
		do
			create stato_prova.make_with_id ("stato_prova")
			create azione_prova.make_with_text ("prova")
--			if attached stato_prova as sp then
				stato_prova.set_OnEntry (azione_prova)
				assert ("Azione OnEntry NON assegnata correttamente", stato_prova.OnEntry ~ azione_prova)
--			end
		end

	t_set_OnExit
		local
			azione_prova: STAMPA
		do
			create stato_prova.make_with_id ("stato_prova")
			create azione_prova.make_with_text ("prova")
--			if attached stato_prova as sp then
				stato_prova.set_OnExit (azione_prova)
				assert ("Azione OnEntry NON assegnata correttamente", stato_prova.OnExit ~ azione_prova)
--			end
		end

		-- Test per features con evento

	t_abilitata_con_evento_non_esistente
	local t:TRANSIZIONE
		do
			set_eventi_prova ("non", "non", "non")
			t:=stato_prova.transizione_abilitata (eventi_prova, cond_prova)
			assert ("ERRORE: transizione abilitata con evento non_esistente", stato_prova.transizione_abilitata (eventi_prova, cond_prova) = Void)
--			if attached stato_prova as sp then
--				assert ("ERRORE: transizione abilitata con evento non_esistente", sp.transizione_abilitata (eventi_prova, cond_prova) = Void)
--			end
		end

	t_abilitata_con_evento_unica
	local t: TRANSIZIONE
		do
			set_cond_prova (TRUE, TRUE, TRUE)
			set_eventi_prova ("non", "evento2", "non")
			assert ("ERRORE: transizione abilitata con evento unica non rilevata", stato_prova.transizione_abilitata (eventi_prova, cond_prova) = transizione_prova_2)
--			if attached stato_prova as sp then
--				assert ("ERRORE: transizione abilitata con evento unica non rilevata", sp.transizione_abilitata (eventi_prova, cond_prova) = transizione_prova_2)
--			end
		end

	t_abilitata_con_evento_molteplici
		do
			set_cond_prova (TRUE, FALSE, TRUE)
			set_eventi_prova ("evento1", "evento2", "evento3")
			assert ("ERRORE: transizione abilitata con evento molteplici non rivela quella corretta", stato_prova.transizione_abilitata (eventi_prova, cond_prova) = transizione_prova_1)
--			if attached stato_prova as sp then
--				assert ("ERRORE: transizione abilitata con evento molteplici non rivela quella corretta", sp.transizione_abilitata (eventi_prova, cond_prova) = transizione_prova_1)
--			end
		end

	t_attivabile_con_evento
		do
--			if attached stato_prova as sp then
				set_cond_prova (TRUE, FALSE, FALSE)
				assert ("la prima transizione attivabile non e' rilevata", stato_prova.attivabile (transizione_prova_1, "evento1", cond_prova))
				set_cond_prova (TRUE, TRUE, FALSE)
				assert ("la seconda transizione attivabile non e' rilevata", stato_prova.attivabile (transizione_prova_2, "evento2", cond_prova))
				set_cond_prova (FALSE, FALSE, TRUE)
				assert ("la terza transizione attivabile non e' rilevata", stato_prova.attivabile (transizione_prova_3, "evento1", cond_prova))
--			end
		end

	t_numero_transizioni_abilitate_con_evento_non_determinismo
		do
			set_cond_prova (TRUE, TRUE, TRUE)
			assert ("ci sono due transizioni abilitate non rilevate", stato_prova.numero_transizioni_abilitate ("evento1", cond_prova) = 2)
--			if attached stato_prova as sp then
--				assert ("ci sono due transizioni abilitate non rilevate", sp.numero_transizioni_abilitate ("evento1", cond_prova) = 2)
--			end
		end

	t_numero_transizioni_abilitate_con_evento_determinismo
		do
			set_cond_prova (TRUE, TRUE, FALSE)
			assert ("unica transizione abilitata non rilevata", stato_prova.numero_transizioni_abilitate ("evento1", cond_prova) = 1)
--			if attached stato_prova as sp then
--				assert ("unica transizione abilitata non rilevata", stato_prova.numero_transizioni_abilitate ("evento1", cond_prova) = 1)
--			end
		end

		-- Test per features senza evento

		--	t_numero_transizioni_abilitate_senza_evento_non_determinismo
		--		do
		--			set_hash_di_prova_senza_evento(FALSE,TRUE)
		--			if attached stato_prova_senza_evento as spse then
		--				assert("ci sono due transizioni abilitate non rilevate", spse.numero_transizioni_abilitate_senza_evento (hash_di_prova_senza_evento)=2)
		--			end
		--		end

		--	t_numero_transizioni_abilitate_senza_evento_determinismo
		--		do
		--			set_hash_di_prova_senza_evento(TRUE,FALSE)
		--			if attached stato_prova_senza_evento as spse then
		--				assert("unica transizione abilitata non rilevata", spse.numero_transizioni_abilitate_senza_evento (hash_di_prova_senza_evento)=1)
		--			end
		--		end

		--	t_attivabile_senza_evento
		--		do
		--			if attached stato_prova_senza_evento as spse then
		--				set_hash_di_prova_senza_evento(TRUE,FALSE)
		--				assert("la prima transizione attivabile non e' rilevata", spse.attivabile_senza_evento (1, hash_di_prova_senza_evento))
		--			end
		--		end

		--	t_target_senza_evento
		--		do
		--			set_hash_di_prova_senza_evento(TRUE,FALSE)
		--			if attached stato_prova_senza_evento as spse then
		--				if attached spse.target_senza_evento (hash_di_prova_senza_evento)as stse then
		--					assert("target scorretto", stse.id ~ "target_prova_senza_evento_1")
		--				end
		--			end
		--			set_hash_di_prova_senza_evento(FALSE,FALSE)
		--			if attached stato_prova_senza_evento as spse then
		--				if attached spse.target_senza_evento (hash_di_prova_senza_evento)as stse then
		--					assert("target scorretto", stse.id = Void)
		--				end
		--			end
		--		end

		--	t_stato_get_events
		--		local
		--			esec: ESECUTORE
		--			eventi: ARRAY [STRING]
		--		do
		--			create esec.start(nomi_files_prova)
		--			if attached esec.state_chart.stati.item ("reset") as reset then
		--				eventi := reset.get_events
		--				assert ("Fatto male count", eventi.count = 1)
		--				assert ("Fatto male contenuto", eventi [1] ~ "watch_start")
		--			end
		--		end

end
