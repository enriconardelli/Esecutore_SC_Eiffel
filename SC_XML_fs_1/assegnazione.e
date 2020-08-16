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
	crea_assegnazione

feature --attributi

	elemento_da_modificare: STRING
		-- id del <data> di tipo booleano o intero

	valore_bool_da_assegnare: BOOLEAN
		-- valore booleano da riassegnare

	valore_int_da_assegnare: INTEGER
		-- valore intero da riassegnare

	tipo_di_aggiornamento: detachable STRING
		-- incremento o decremento ('inc' o 'dec')

feature -- creazione parametrica

	crea_assegnazione (variabile, espressione: STRING)
	do
		elemento_da_modificare := variabile
		if valore_booleano (espressione) then
			valore_bool_da_assegnare := espressione.as_lower ~ "true"
		elseif valore_intero (espressione) then
			valore_int_da_assegnare := espressione.to_integer
		elseif valore_operazione (espressione) then
			tipo_di_aggiornamento := espressione
		end
	end

feature -- modifica per booleani

	modifica_condizioni (condizioni: HASH_TABLE [BOOLEAN, STRING])
		do
			condizioni.replace (valore_bool_da_assegnare, elemento_da_modificare)
		end

	azione_su_booleano (condizioni: HASH_TABLE [BOOLEAN, STRING])
		do
			if condizioni.has (elemento_da_modificare) then
				print ("  ASSIGN: " + elemento_da_modificare + " = " + valore_bool_da_assegnare.out + "%N")
				modifica_condizioni(condizioni)
			end
		end

feature -- modifica per interi

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

	azione_su_intero (valori_data: HASH_TABLE [INTEGER, STRING])
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

--	action (condizioni: HASH_TABLE [BOOLEAN, STRING]; valori_data: HASH_TABLE [INTEGER, STRING])
--		do
--			action_with_boolean (condizioni)
--			action_with_integer (valori_data)
--		end

	esegui (condizioni: HASH_TABLE [BOOLEAN, STRING]; valori_data: HASH_TABLE [INTEGER, STRING])
		do
			svolgi (agent azione_su_booleano (condizioni))
			svolgi (agent azione_su_intero (valori_data))
		end

feature -- supporto

	valore_booleano (valore: STRING): BOOLEAN
		do
			Result := valore.as_lower ~ "true" or valore.as_lower ~ "false"
		end

	valore_intero (valore: STRING): BOOLEAN
		do
			Result := valore.is_integer
		end

	valore_operazione (valore: STRING): BOOLEAN
		do
			Result := valore.as_lower ~ "inc" or valore.as_lower ~ "dec"
		end

end
