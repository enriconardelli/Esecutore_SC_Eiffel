note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	STATIC_TESTS

inherit
	EQA_TEST_SET

feature -- Test routines

	t_has
			-- Enrico Nardelli, 2020/03/06
		local
			t: INT_LINKED_LIST
		do
			create t
			assert("t e' vuota, t contiene 3?", not t.has (3))
			t.append (3)
			assert("t contiene 3, t contiene 3?", t.has (3))
			assert("t contiene 3, t contiene 4?", not t.has (4))
			t.append (7)
			assert("t contiene 3 e 7, t contiene 3? ", t.has (3))
			assert("t contiene 3 e 7, t contiene 4? ", not t.has (4))
			assert("t contiene 3 e 7, t contiene 7? ", t.has (7))
		end

	t_append
			-- Enrico Nardelli, 2020/03/06
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (3)
			assert("ho aggiunto 3, t contiene 3?", t.has (3))
			assert("ho aggiunto 3, t contiene 4?", not t.has (4))
		end

	t_insert_after
			-- Alessandro Filippo, 2020/03/06
		local
			t: INT_LINKED_LIST
		do
			create t
			t.insert_after(5,6)
			assert("t � vuota, t ha inserito 5 dopo 6 anche se non c'�?", t.has(5))
			t.append (-4)
			t.insert_after(7,-4)
			assert("t contiene -4, ho inserito 7 dopo 4?", t.has (7))
		end

	t_get_element
			-- Riccardo Malandruccolo, 2020/03/06
		local
			t: INT_LINKED_LIST
		do
			create t
			assert("errore: restituisce elemento che non esiste", t.get_element (3) = void)
			t.append (3)
			assert("errore: non restituisce elemento che esiste", t.get_element (3) /= void)
			assert("errore: non restituisce il valore corretto", attached t.get_element(3) as el implies el.value = 3)
			assert("errore: restituisce elementi che non esistono", t.get_element(4) = void)

			t.append (7)
			assert("errore: non restituisce elemento che esiste", t.get_element (3) /= void)
			assert("errore: restituisce elemento che non esiste", t.get_element (4) = void)
			assert("errore: non restituisce elemento che esiste", t.get_element (7) /= void)
			assert("errore: restituisce valore sbagliato di elemento che esiste", attached t.get_element (3) as el implies el.value = 3)
			assert("errore: restituisce valore sbagliato di elemento che esiste", attached t.get_element (7) as el implies el.value = 7)
		end

	t_first
			-- Claudia Agulini, 2020/03/06
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (1)
			t.append (3)
			t.append (5)
			t.start
			if attached t.active_element as ae and attached t.first_element as fe then
				assert("t contiene 1,3,5, active � 1?", ae.value = fe.value)
			end
		end


	t_insert_after_reusing
			-- Federico Fiorini, 2020/03/06
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (5)
			t.append (7)
			t.append (2)
			t.insert_after_reusing (1,  0)
			assert("t contiene 4 elementi?", t.count = 4)
			if attached t.last_element as le then
	        	assert("t non contiene il valore 0, il valore 1 � stato inserito alla fine della lista?", le.value = 1)
			end
		end


end


