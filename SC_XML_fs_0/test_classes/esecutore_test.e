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
			nomi_files_prova [1] := "esempio_per_esecutore_test.xml"
			nomi_files_prova [2] := "eventi_per_esecutore_test.txt"

			create esecutore_prova.make (nomi_files_prova)

			create nomi_files_prova.make_filled ("", 1, 2)
			nomi_files_prova[1] := "esempio_per_altro_esecutore_test.xml"
			nomi_files_prova[2] := "eventi_per_altro_esecutore_test.txt"

			create altro_esecutore_prova.make (nomi_files_prova)

		end

	has_state( stati: ARRAY [STATO]; stato: STRING ):BOOLEAN
	-- Controlla se negli 'stati' passati c'� lo 'stato'
		local
			count: INTEGER
		do
			from
				count := stati.lower
			until
				count = stati.upper + 1
			loop
				if stati[count].id.is_equal(stato) then
					result := TRUE
				end
				count := count + 1
			end
		end
		
end
