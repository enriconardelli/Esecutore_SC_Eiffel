note
	description: "La classe che rappresenta l'azione di assegnazione"
	author: "EN + studenti corsi PSI"
	date: "$Date$"
	revision: "0"

class
	ASSEGNAZIONE
	-- TODO: rendere la classe astratta e creare due sottoclassi per booleani e interi
	-- TODO: per esempio ASSEGNA_BOOLEANO e ASSEGNA_INTERO
	-- TODO: problema: come gestisco poi in modo parametrico la creazione
	-- TODO: in funzione dei valori passati nella 'make' in 'variabile' e 'espressione'?
	-- TODO: attualmente la gestione viene fatta qua e NON in CONFIGURAZIONE
	-- TODO: ma se qui separo le due sottoclassi dove decido cosa creare?
	-- TODO: devo avere in CONFIGURAZIONE un'istanza della classe ASSEGNAZIONE_CREATORE
	-- TODO: che mi crea e restituisce (attraverso una feature come il make di qua)
	-- TODO: la istanza della sottoclasse di ASSEGNAZIONE corretta

inherit

	AZIONE

create
	make

feature -- attributi

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
			-- Result := create {ASSEGNA_BOOLEANO}.make_value (variabile, espressione)
			booleano_da_assegnare := espressione.as_lower ~ "true"
		elseif valore_intero (espressione) then
			-- Result := create {ASSEGNA_INTERO}.make_value (variabile, espressione)
			intero_da_assegnare := espressione.to_integer
		elseif valore_operazione (espressione) then
			-- Result := create {ASSEGNA_INTERO}.make_oper (variabile, espressione)
			tipo_di_aggiornamento := espressione
		end
	end

feature -- modifica per booleani

	modifica_booleano (variabili_booleane: HASH_TABLE [BOOLEAN, STRING])
		do
			if variabili_booleane.has (elemento_da_modificare) then
				debug("sc_modifica_variabili") print("  ASSIGN: " + booleano_da_assegnare.out + " --> " + elemento_da_modificare + "%N") end
				variabili_booleane.replace (booleano_da_assegnare, elemento_da_modificare)
				debug("sc_modifica_variabili") print("  -> Booleano: " + elemento_da_modificare + " = " + variabili_booleane[elemento_da_modificare].out + "%N") end
			end
		end

feature -- modifica per interi

	modifica_intero (variabili_intere: HASH_TABLE [INTEGER, STRING])
		do
			if variabili_intere.has (elemento_da_modificare) then
				if attached tipo_di_aggiornamento as type then
					debug("sc_modifica_variabili") print("  ASSIGN: " + type + " " + elemento_da_modificare + "%N") end
					if type ~ "inc" then
						variabili_intere.replace (variabili_intere[elemento_da_modificare]+1, elemento_da_modificare)
					elseif type ~ "dec" then
						variabili_intere.replace (variabili_intere[elemento_da_modificare]-1, elemento_da_modificare)
					end
					debug("sc_modifica_variabili") print("  -> Intero: " + elemento_da_modificare + " = " + variabili_intere[elemento_da_modificare].out + "%N") end
				else
					debug("sc_modifica_variabili") print("  ASSIGN: " + intero_da_assegnare.out + " --> " + elemento_da_modificare + "%N") end
					variabili_intere.replace (intero_da_assegnare, elemento_da_modificare)
					debug("sc_modifica_variabili") print("  -> Intero: " + elemento_da_modificare + " = " + variabili_intere[elemento_da_modificare].out + "%N") end
				end
			end
		end

feature -- esecuzione

--	esegui (variabili_booleane: HASH_TABLE [BOOLEAN, STRING]; variabili_intere: HASH_TABLE [INTEGER, STRING])
--		do
--			svolgi (agent modifica_booleano (variabili_booleane))
--			svolgi (agent modifica_intero (variabili_intere))
--		end

	esegui (variabili_booleane: HASH_TABLE [BOOLEAN, STRING]; variabili_intere: HASH_TABLE [INTEGER, STRING])
		do
			modifica_booleano (variabili_booleane)
			modifica_intero (variabili_intere)
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
