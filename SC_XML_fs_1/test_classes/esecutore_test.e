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

	argomenti: ARRAY [STRING]
	a_path: PATH
	test_data_dir: STRING

feature -- Test routines

	on_prepare
		do
			create a_path.make_current
			create test_data_dir.make_from_string ("test_data")
			test_data_dir.append_character(a_path.directory_separator)
			create argomenti.make_filled ("", 1, 3)

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

	evoluzione_state_chart(stati: STRING; eventi: STRING; stati_corretti: LINKED_SET[STRING])
	--Prende in input il file .xml della state-chart e il file .txt degli eventi e restituisce errore se
	--il sistema non termina negli stati corretti.
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + stati
			argomenti [2] := test_data_dir + eventi
			create esecutore.make (argomenti)
			assert ("ERRORE il sistema non ha terminato nello stato corretto ", conf_has_states(esecutore.state_chart.config_base, stati_corretti))
		end

	evoluzione_state_chart_limitata(stati: STRING; eventi: STRING; limite: STRING; stati_corretti: LINKED_SET[STRING])
	--Prende in input il file .xml della state-chart e il file .txt degli eventi e restituisce errore se
	--il sistema non termina negli stati corretti.
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + stati
			argomenti [2] := test_data_dir + eventi
			argomenti [3] := limite
			create esecutore.make (argomenti)
			assert ("ERRORE il sistema non ha terminato nello stato corretto ", conf_has_states(esecutore.state_chart.config_base, stati_corretti))
		end

	evoluzione_state_chart_con_dato_intero(stati: STRING; eventi: STRING; variabile: STRING; intero: INTEGER)
	--Prende in input il file .xml della state-chart e il file .txt degli eventi e restituisce errore se
	--il sistema non termina negli stati corretti.
		local
			esecutore: ESECUTORE
		do
			argomenti [1] := test_data_dir + stati
			argomenti [2] := test_data_dir + eventi
			create esecutore.make (argomenti)
			assert ("ERRORE La variabile non ha valore desiderato. ", esecutore.state_chart.variabili.intere.at(variabile) = intero)


		end
end
