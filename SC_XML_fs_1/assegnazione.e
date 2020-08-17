note
	description: "La classe che rappresenta l'azione di assegnazione"
	author: "EN + studenti corsi PSI"
	date: "$Date$"
	revision: "0"

class
	ASSEGNAZIONE
	-- TODO: rendere la classe astratta e creare due sottoclassi per booleani e interi

inherit

	AZIONE

create
	make

feature --attributi

	elemento_da_modificare: STRING
		-- id del <data> di tipo booleano o intero

	booleano_da_assegnare: BOOLEAN
		-- valore booleano da riassegnare

	intero_da_assegnare: INTEGER
		-- valore intero da riassegnare

	tipo_di_aggiornamento: detachable STRING
		-- incremento o decremento ('inc' o 'dec')

feature -- creazione parametrica

	make (variabile, espressione: STRING)
	do
		elemento_da_modificare := variabile
		if valore_booleano (espressione) then
			booleano_da_assegnare := espressione.as_lower ~ "true"
		elseif valore_intero (espressione) then
			intero_da_assegnare := espressione.to_integer
		elseif valore_operazione (espressione) then
			tipo_di_aggiornamento := espressione
		end
	end

feature -- modifica per booleani

	modifica_booleano (variabili_booleane: HASH_TABLE [BOOLEAN, STRING])
		do
			variabili_booleane.replace (booleano_da_assegnare, elemento_da_modificare)
			debug("sc_modifica_variabili") print("  -> Booleano: " + elemento_da_modificare + " = " + variabili_booleane[elemento_da_modificare].out + "%N") end
		end

	azione_su_booleano (variabili_booleane: HASH_TABLE [BOOLEAN, STRING])
		do
			if variabili_booleane.has (elemento_da_modificare) then
				modifica_booleano (variabili_booleane)
				debug("sc_modifica_variabili") print ("  ASSIGN: " + elemento_da_modificare + " = " + booleano_da_assegnare.out + "%N") end
			end
		end

feature -- modifica per interi

	modifica_intero (variabili_intere: HASH_TABLE [INTEGER, STRING])
		do
			if attached tipo_di_aggiornamento as type then
				if type ~ "inc" then
					variabili_intere.replace (variabili_intere[elemento_da_modificare]+1, elemento_da_modificare)
					debug("sc_modifica_variabili") print("  -> Intero: " + elemento_da_modificare + " = " + variabili_intere[elemento_da_modificare].out + "%N") end
				elseif type ~ "dec" then
					variabili_intere.replace (variabili_intere[elemento_da_modificare]-1, elemento_da_modificare)
					debug("sc_modifica_variabili") print("  -> Intero: " + elemento_da_modificare + " = " + variabili_intere[elemento_da_modificare].out + "%N") end
				end
			else
				variabili_intere.replace (intero_da_assegnare, elemento_da_modificare)
				debug("sc_modifica_variabili") print("  -> Intero: " + elemento_da_modificare + " = " + variabili_intere[elemento_da_modificare].out + "%N") end
			end
		end

	azione_su_intero (variabili_intere: HASH_TABLE [INTEGER, STRING])
		do
			if attached tipo_di_aggiornamento as type and variabili_intere.has (elemento_da_modificare) then
				modifica_intero (variabili_intere)
				debug("sc_modifica_variabili") print ("  ASSIGN: " + type + " " + elemento_da_modificare + "%N") end
			elseif variabili_intere.has (elemento_da_modificare) then
				modifica_intero (variabili_intere)
				debug("sc_modifica_variabili") print ("  ASSIGN: " + elemento_da_modificare + " = " + intero_da_assegnare.out + "%N") end
			end
		end

feature

--	action (condizioni: HASH_TABLE [BOOLEAN, STRING]; valori_data: HASH_TABLE [INTEGER, STRING])
--		do
--			action_with_boolean (condizioni)
--			action_with_integer (valori_data)
--		end

	esegui (variabili_booleane: HASH_TABLE [BOOLEAN, STRING]; variabili_intere: HASH_TABLE [INTEGER, STRING])
		do
			svolgi (agent azione_su_booleano (variabili_booleane))
			svolgi (agent azione_su_intero (variabili_intere))
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
