note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

deferred class
	ESECUTORE_TEST

inherit

	EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Supporto

	nomi_files_prova: ARRAY [STRING]
	a_path: PATH
	test_data_dir: STRING = "test_data"

feature -- Test routines

	on_prepare
		do
			create a_path.make_current
			test_data_dir.append_character(a_path.directory_separator)
			create nomi_files_prova.make_filled ("", 1, 2)

		end

	conf_has_state( conf: ARRAY [STATO]; stato: STRING ):BOOLEAN
	-- Controlla se in `conf' è presente `stato'
		do
			across conf as c
			loop
				if c.item.id.is_equal(stato) then
					Result := TRUE
				end
			end
		end

	conf_has_states( conf: ARRAY [STATO]; stato: LINKED_SET [STRING]):BOOLEAN
	-- Controlla se `conf' e `stato' sono uguali
		do
			Result := True
			if conf.count /= stato.count then
				Result := FALSE
			end
			across stato as s
			loop
		    	if not conf_has_state (conf , s.item) then
		    		Result := False
		    	end
			end

		end

--	evoluzione_state_chart(stati: STRING; eventi: STRING; stati_corretti: LINKED_SET[STRING]): BOOLEAN
--	--Prende in input il file .xml della state-chart e il file .txt degli eventi e restituisce l'elenco degli stati
--	--della configurazione finale.
--		local
--			esecutore: ESECUTORE
--		do
--			nomi_files_prova [1] := test_data_dir + stati
--			nomi_files_prova [2] := test_data_dir + eventi
--			create esecutore.make (nomi_files_prova)
--			Result:= conf_has_state_1(esecutore.state_chart.conf_base, stati_corretti)
--		end

		evoluzione_state_chart(stati: STRING; eventi: STRING; stati_corretti: LINKED_SET[STRING])
		--Prende in input il file .xml della state-chart e il file .txt degli eventi e restituisce errore se
		--il sistema non termina negli stati corretti.
			local
				esecutore: ESECUTORE
			do
				nomi_files_prova [1] := test_data_dir + stati
				nomi_files_prova [2] := test_data_dir + eventi
				create esecutore.make (nomi_files_prova)

				assert ("ERRORE il sistema non ha terminato nello stato corretto ", conf_has_states(esecutore.state_chart.conf_base, stati_corretti))
			end
end
