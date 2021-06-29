note
	description: "Summary description for {ESECUTORE_TEST_DETERMINISMO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE_TEST_DETERMINISMO

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

	t_non_determinismo_1_1
	 --Filippo & Iezzi 08/05/2020
	 --finisce in C perché esegue la transizione più interna
		 do
			conf_finale.force("C")
			evoluzione_state_chart("non_determinismo_1.xml", "non_determinismo_1_1_eventi.txt", conf_finale)
		end

	t_non_determinismo_1_2
	 --Filippo & Iezzi 08/05/2020
	 --finisce in B perché compare prima nel file xml
		 do
			conf_finale.force("B")
			evoluzione_state_chart("non_determinismo_1.xml", "non_determinismo_1_2_eventi.txt", conf_finale)
		end

	t_non_determinismo_1_3
	 --Filippo & Iezzi 08/05/2020
	 --finisce in D1 perché esegue la transizione dal primo stato della configurazione
		 do
			conf_finale.force("D1")
			evoluzione_state_chart("non_determinismo_1.xml", "non_determinismo_1_3_eventi.txt", conf_finale)
		end

	t_non_determinismo_1_3_alt
	 --finisce in D1 perché esegue la transizione dal primo stato della configurazione
		 do
			conf_finale.force("D1")
			evoluzione_state_chart("non_determinismo_1_alt.xml", "non_determinismo_1_3_eventi.txt", conf_finale)
		end

	t_non_determinismo_1_4
	 --Filippo & Iezzi 08/05/2020
	 --finisce in D1 perché esegue la transizione dal primo stato della configurazione
		 do
			conf_finale.force("D1")
			evoluzione_state_chart("non_determinismo_1.xml", "non_determinismo_1_4_eventi.txt", conf_finale)
		end

	t_non_determinismo_1_4_alt
	 --finisce in D1 perché esegue la transizione dal primo stato della configurazione
		 do
			conf_finale.force("D1")
			evoluzione_state_chart("non_determinismo_1_alt.xml", "non_determinismo_1_4_eventi.txt", conf_finale)
		end

	t_non_determinismo_1_5
	-- Alessandro Filippo & Giulia Iezzi 25/05/2020
		 do
			conf_finale.force("A3")
			conf_finale.force("B11")
			conf_finale.force("B12b")
			evoluzione_state_chart("non_determinismo_1_5.xml", "non_determinismo_1_5_eventi.txt", conf_finale)
		end


	t_non_determinismo_1_5_1
		 do
			conf_finale.force("A3")
			conf_finale.force("B11a")
			conf_finale.force("B12a")
			evoluzione_state_chart("non_determinismo_1_5_1.xml", "non_determinismo_1_5_eventi.txt", conf_finale)
		end


	t_non_determinismo_1_5_2
		 do
			conf_finale.force("A3")
			conf_finale.force("B11a")
			conf_finale.force("B12b")
			evoluzione_state_chart("non_determinismo_1_5_2.xml", "non_determinismo_1_5_eventi.txt", conf_finale)
		end


	t_non_determinismo_1_5_3
		 do
			conf_finale.force("A3")
			conf_finale.force("B11a")
			conf_finale.force("B12b")
			evoluzione_state_chart("non_determinismo_1_5_3.xml", "non_determinismo_1_5_eventi.txt", conf_finale)
		end

	t_non_determinismo_1_6
	-- Alessandro Filippo & Giulia Iezzi 25/05/2020
		 do
			conf_finale.force("B1")
			conf_finale.force("B21")
			evoluzione_state_chart("non_determinismo_1_6.xml", "non_determinismo_1_6_eventi.txt", conf_finale)
		end

	t_non_determinismo_1_6_var
	-- TODO: rispetto a 1_6 gli eventi compaiono in ordine diverso (sempre nello stesso istante)
		 do
			conf_finale.force("B1")
			conf_finale.force("B21")
			evoluzione_state_chart("non_determinismo_1_6.xml", "non_determinismo_1_6_eventi_var.txt", conf_finale)
		end

	t_non_determinismo_1_7_1
	-- Alessandro Filippo & Giulia Iezzi 25/05/2020
		 do
			conf_finale.force("C")
			evoluzione_state_chart("non_determinismo_1_7_1.xml", "non_determinismo_1_7_eventi.txt", conf_finale)
		end

	t_non_determinismo_1_7_2
		 do
			conf_finale.force("B11")
			conf_finale.force("A2")
			evoluzione_state_chart("non_determinismo_1_7_2.xml", "non_determinismo_1_7_eventi.txt", conf_finale)
		end

	t_non_determinismo_1_7_3
		 do
			conf_finale.force("C")
			evoluzione_state_chart("non_determinismo_1_7_3.xml", "non_determinismo_1_7_eventi.txt", conf_finale)
		end

	t_non_determinismo_1_7_4
		 do
			conf_finale.force("B11")
			conf_finale.force("A1")
			evoluzione_state_chart("non_determinismo_1_7_4.xml", "non_determinismo_1_7_eventi.txt", conf_finale)
		end

	t_non_determinismo_2_1
	-- Arianna Calzuola & Riccardo Malandruccolo 08/05/2020
		 do
			conf_finale.force("P1B")
			conf_finale.force("P2A")
			evoluzione_state_chart("non_determinismo_2_1.xml", "non_determinismo_2_1_eventi.txt", conf_finale)
		end

	t_non_determinismo_2_2
	-- Arianna Calzuola & Riccardo Malandruccolo 08/05/2020
		 do
			conf_finale.force("A")
			evoluzione_state_chart("non_determinismo_2_2.xml", "non_determinismo_2_2_eventi.txt", conf_finale)
		end

	t_non_determinismo_2_3
	-- Arianna Calzuola & Riccardo Malandruccolo 08/05/2020
		 do
			conf_finale.force("B")
			conf_finale.force("P2")
			evoluzione_state_chart("non_determinismo_2_3.xml", "non_determinismo_2_3_eventi.txt", conf_finale)
		end

	t_non_determinismo_2_4
	-- Arianna & Riccardo 21/05/2020
		 do
			conf_finale.force("P1A2")
			conf_finale.force("P1B1")
			conf_finale.force("P2")
			evoluzione_state_chart("non_determinismo_2_4.xml", "non_determinismo_2_4_eventi.txt", conf_finale)
		end

	t_non_determinismo_2_5_1
	-- Arianna & Riccardo 21/05/2020
		 do
			conf_finale.force("P1B")
			conf_finale.force("P2A")
			conf_finale.force("R1B")
			conf_finale.force("R2A")
			evoluzione_state_chart("non_determinismo_2_5.xml", "non_determinismo_2_5_1_eventi.txt", conf_finale)
		end

	t_non_determinismo_2_5_2
	-- Arianna & Riccardo 21/05/2020
		 do
			conf_finale.force("P1B")
			conf_finale.force("P2A")
			conf_finale.force("G")
			evoluzione_state_chart("non_determinismo_2_5.xml", "non_determinismo_2_5_2_eventi.txt", conf_finale)
		end

	t_non_determinismo_2_6
	-- Arianna Calzuola & Riccardo Malandruccolo 22/05/2020
		 do
			conf_finale.force("P1A1B")
			conf_finale.force("P1A2")
			conf_finale.force("P1A3B")
			conf_finale.force("P2A2")
			conf_finale.force("P2B")
			conf_finale.force("P2C1A")
			conf_finale.force("P2C1B")
			conf_finale.force("A2")
			conf_finale.force("B1")
			conf_finale.force("P3B1")
			evoluzione_state_chart("non_determinismo_2_6.xml", "non_determinismo_2_6_eventi.txt", conf_finale)
		end

	t_non_determinismo_2_7_1
		 do
			conf_finale.force("P1B")
			conf_finale.force("P2A")
			conf_finale.force("G")
			evoluzione_state_chart("non_determinismo_2_7.xml", "non_determinismo_2_7_eventi.txt", conf_finale)
		end

	t_non_determinismo_2_7_2
		 do
			conf_finale.force("P1B")
			conf_finale.force("P2A")
			conf_finale.force("R1B")
			conf_finale.force("R2A")
			evoluzione_state_chart("non_determinismo_2_7_alt.xml", "non_determinismo_2_7_eventi.txt", conf_finale)
		end

	t_non_determinismo_2_8_1
		 do
			conf_finale.force("H")
			evoluzione_state_chart("non_determinismo_2_8.xml", "non_determinismo_2_8_eventi.txt", conf_finale)
		end

	t_non_determinismo_2_8_2
		 do
			conf_finale.force("P1A")
			conf_finale.force("P2A")
			conf_finale.force("R1B")
			conf_finale.force("R2A")
			evoluzione_state_chart("non_determinismo_2_8_alt.xml", "non_determinismo_2_8_eventi.txt", conf_finale)
		end

	t_non_determinismo_2_9_1
		 do
			conf_finale.force("F")
			evoluzione_state_chart("non_determinismo_2_9.xml", "non_determinismo_2_9_eventi.txt", conf_finale)
		end

	t_non_determinismo_2_9_2
		 do
			conf_finale.force("F")
			evoluzione_state_chart("non_determinismo_2_9_alt.xml", "non_determinismo_2_9_eventi.txt", conf_finale)
		end
end
