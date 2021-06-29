note
	description: "Summary description for {ESECUTORE_TEST_TRANSIZIONI_FORK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE_TEST_TRANSIZIONI_FORK

inherit
	ESECUTORE_TEST
	redefine
		on_prepare
	end

feature {NONE} -- Supporto

conf_finale: LINKED_SET [STRING]

feature --test
	on_prepare
		do
			Precursor
			create conf_finale.make
		end

	t_costrutto_fork_1
	 --Filippo & Iezzi


		do
			create conf_finale.make
			conf_finale.force("A1")
			conf_finale.force("B1")
			evoluzione_state_chart("costrutto_fork_1.xml", "costrutto_fork_eventi_con_fork.txt", conf_finale)
		end

	t_costrutto_fork_1_1
	 --Filippo & Iezzi
 			do
 				conf_finale.force("A1")
				conf_finale.force("B2")
				evoluzione_state_chart("costrutto_fork_1.xml", "costrutto_fork_eventi_non_fork.txt", conf_finale)
			end

	t_costrutto_fork_1_con_azioni
	 --Filippo & Iezzi


		do
			create conf_finale.make
			conf_finale.force("A1")
			conf_finale.force("B1")
			evoluzione_state_chart("costrutto_fork_1_con_azioni.xml", "costrutto_fork_eventi_con_fork.txt", conf_finale)
		end

	t_costrutto_fork_1_1_con_azioni
	 --Filippo & Iezzi


		do
			create conf_finale.make
			conf_finale.force("A1")
			conf_finale.force("B2")
			evoluzione_state_chart("costrutto_fork_1_con_azioni.xml", "costrutto_fork_eventi_non_fork.txt", conf_finale)
		end

	t_costrutto_fork_2
	 --Filippo & Iezzi


		do
			create conf_finale.make
			conf_finale.force("A")
			conf_finale.force("B2")
			conf_finale.force ("C2")
			evoluzione_state_chart("costrutto_fork_2.xml", "costrutto_fork_eventi_con_fork.txt", conf_finale)
		end


	t_costrutto_fork_2_variante
	 --Filippo & Iezzi


		do
			create conf_finale.make
			conf_finale.force("A")
			conf_finale.force("B2")
			conf_finale.force ("C2")
			evoluzione_state_chart("costrutto_fork_2_variante.xml", "costrutto_fork_eventi_con_fork.txt", conf_finale)
		end


	t_costrutto_fork_2_1
	 --Filippo & Iezzi


		do
			create conf_finale.make
			conf_finale.force("A")
			conf_finale.force("B")
			conf_finale.force ("C")
			evoluzione_state_chart("costrutto_fork_2_1.xml", "costrutto_fork_eventi_con_fork.txt", conf_finale)
		end


	t_costrutto_fork_3
	 --Filippo & Iezzi


		do
			create conf_finale.make
			conf_finale.force("A")
			conf_finale.force("B21")
			conf_finale.force ("B11")
			evoluzione_state_chart("costrutto_fork_3.xml", "costrutto_fork_eventi_con_fork.txt", conf_finale)
		end


	t_costrutto_fork_3_bis
	 --Filippo & Iezzi
 			do
 				conf_finale.force("A")
				conf_finale.force("B211")
				conf_finale.force ("B11")
				evoluzione_state_chart("costrutto_fork_3_bis.xml", "costrutto_fork_eventi_con_fork.txt", conf_finale)
			end

	t_costrutto_fork_3_1
	 --Filippo & Iezzi
 			do
 				conf_finale.force("A")
				conf_finale.force("B22")
				conf_finale.force ("B11")
				evoluzione_state_chart("costrutto_fork_3.xml", "costrutto_fork_eventi_non_fork.txt", conf_finale)
			end

	t_costrutto_fork_4
	 --Filippo & Iezzi


		do
			create conf_finale.make
			conf_finale.force("A")
			conf_finale.force("B1")
			conf_finale.force ("C")
			evoluzione_state_chart("costrutto_fork_4.xml", "costrutto_fork_eventi_con_fork.txt", conf_finale)
		end


	t_costrutto_fork_4_1
	 --Filippo & Iezzi
 			do
 				conf_finale.force("A")
				conf_finale.force("B2")
				conf_finale.force ("C")
				evoluzione_state_chart("costrutto_fork_4.xml", "costrutto_fork_eventi_non_fork.txt", conf_finale)
			end
	t_costrutto_fork_5
	 --Filippo & Iezzi


		do
			create conf_finale.make
			conf_finale.force("A2")
			conf_finale.force("B11")
			conf_finale.force ("B22")
			evoluzione_state_chart("costrutto_fork_5.xml", "costrutto_fork_eventi_con_fork.txt", conf_finale)
		end

	t_costrutto_fork_5_bis
	 --Filippo & Iezzi


		do
			create conf_finale.make
			conf_finale.force("A2")
			conf_finale.force("B211")
			conf_finale.force ("B11")
			evoluzione_state_chart("costrutto_fork_5_bis.xml", "costrutto_fork_eventi_con_fork.txt", conf_finale)
		end


	t_costrutto_fork_6
	 --Filippo & Iezzi
 			do
 				conf_finale.force("B1")
				conf_finale.force("B2")
				conf_finale.force ("B3")
				conf_finale.force ("C2")
				evoluzione_state_chart("costrutto_fork_6.xml", "costrutto_fork_eventi_con_fork.txt", conf_finale)
			end

	t_costrutto_fork_7
	 --Filippo & Iezzi


		do
			create conf_finale.make
			conf_finale.force("A1")
			conf_finale.force("B1")
			conf_finale.force ("C1")
			evoluzione_state_chart("costrutto_fork_7.xml", "costrutto_fork_eventi_con_fork.txt", conf_finale)
		end


	t_costrutto_fork_8
	 --Filippo & Iezzi
 			do
 				conf_finale.force("A11")
				conf_finale.force("A2")
				conf_finale.force ("B122")
				evoluzione_state_chart("costrutto_fork_8.xml", "costrutto_fork_eventi_con_fork.txt", conf_finale)
			end

	t_costrutto_fork_9
	 --Filippo & Iezzi
 			do
 				conf_finale.force("A11")
				conf_finale.force ("A22")
				conf_finale.force("B12")
				conf_finale.force ("B11")
				evoluzione_state_chart("costrutto_fork_9.xml", "costrutto_fork_eventi_con_fork.txt", conf_finale)
			end

	t_costrutto_fork_10


		do
			create conf_finale.make
			conf_finale.force("A111")
			conf_finale.force("A12")
			conf_finale.force("B1a")
			conf_finale.force("B21")
			conf_finale.force("B22")
			conf_finale.force("B31")
			conf_finale.force("C11")
			conf_finale.force("C31")
			conf_finale.force ("C32")
			evoluzione_state_chart("costrutto_fork_10.xml", "costrutto_fork_eventi_con_fork.txt", conf_finale)
		end

	t_costrutto_fork_non_ammissibile
	 --Filippo & Iezzi
		 do
 			conf_finale.force("S")
			evoluzione_state_chart("costrutto_fork_non_ammissibile.xml", "costrutto_fork_eventi_con_fork.txt", conf_finale)
		end


	t_costrutto_fork_non_ammissibile_2
	 --Filippo & Iezzi
 			do
 				conf_finale.force("S")
				evoluzione_state_chart("costrutto_fork_non_ammissibile_2.xml", "costrutto_fork_eventi_con_fork.txt", conf_finale)
			end

	t_costrutto_fork_non_ammissibile_3
	 --Filippo & Iezzi
		 do
 			conf_finale.force("S")
			evoluzione_state_chart("costrutto_fork_non_ammissibile_3.xml", "costrutto_fork_eventi_con_fork.txt", conf_finale)
		end

end
