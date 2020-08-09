note
	description: "La classe che rappresenta l'azione di assegnazione"
	author: "Gabriele Cacchioni & Davide Canalis & Daniele Fakhoury & Eloisa Scarsella"
	date: "9-04-2015"
	revision: "0"

class
	ASSEGNAZIONE

inherit

	AZIONE

create
	make_with_cond_and_value, make_with_data_and_value, make_with_data_and_type

feature --attributi

	elemento_da_modificare: STRING
		-- id del <data> di tipo booleano o intero

	valore_bool_da_assegnare: BOOLEAN
		-- valore booleano da riassegnare

	valore_int_da_assegnare: INTEGER
		-- valore intero da riassegnare

	tipo_di_aggiornamento: detachable STRING
		-- incremento o decremento ('inc' o 'dec')

feature -- creazione per booleani

	make_with_cond_and_value (una_condizione: STRING; un_valore: BOOLEAN)
		do
			elemento_da_modificare := una_condizione
			valore_bool_da_assegnare := un_valore
		end

	modifica_condizioni (condizioni: HASH_TABLE [BOOLEAN, STRING])
		do
			condizioni.replace (valore_bool_da_assegnare, elemento_da_modificare)
		end

	action_with_boolean (condizioni: HASH_TABLE [BOOLEAN, STRING])
		do
			if condizioni.has (elemento_da_modificare) then
				print ("  ASSIGN: " + elemento_da_modificare + " = " + valore_bool_da_assegnare.out + "%N")
				modifica_condizioni(condizioni)
			end
		end

feature -- creazione per interi

	make_with_data_and_value (un_data: STRING; un_valore: INTEGER)
		do
			elemento_da_modificare := un_data
			valore_int_da_assegnare := un_valore
		end

	make_with_data_and_type (un_data: STRING; un_tipo: STRING)
		require
			un_tipo ~ "inc" or un_tipo ~ "dec"
		do
			elemento_da_modificare := un_data
			tipo_di_aggiornamento := un_tipo
		end

	modifica_valori (valori_data: HASH_TABLE [INTEGER, STRING])
		do
			if attached tipo_di_aggiornamento as type then
				if type ~ "inc" then
					valori_data.replace (valori_data[elemento_da_modificare]+1, elemento_da_modificare)
					print("  -> data " + elemento_da_modificare + " = " + valori_data[elemento_da_modificare].out + "%N")
				elseif type ~ "dec" then
					valori_data.replace (valori_data[elemento_da_modificare]-1, elemento_da_modificare)
					print("  -> data " + elemento_da_modificare + " = " + valori_data[elemento_da_modificare].out + "%N")
				end
			else
				valori_data.replace (valore_int_da_assegnare, elemento_da_modificare)
				print("  -> data " + elemento_da_modificare + " = " + valori_data[elemento_da_modificare].out + "%N")
			end
		end

	action_with_integer (valori_data: HASH_TABLE [INTEGER, STRING])
		do
			if attached tipo_di_aggiornamento as type and valori_data.has (elemento_da_modificare) then
				print ("  ASSIGN: " + type + " " + elemento_da_modificare + "%N")
				modifica_valori(valori_data)
			elseif valori_data.has (elemento_da_modificare) then
				print ("  ASSIGN: " + elemento_da_modificare + " = " + valore_int_da_assegnare.out + "%N")
				modifica_valori(valori_data)
			end
		end

feature

	action (condizioni: HASH_TABLE [BOOLEAN, STRING]; valori_data: HASH_TABLE [INTEGER, STRING])
		do
			action_with_boolean (condizioni)
			action_with_integer (valori_data)
		end
end
