note
	description: "La classe che rappresenta l'azione di assegnazione per valori INTERI"
	author: "EN + studenti corsi PSI"
	date: "$Date$"
	revision: "0"

class
	ASSEGNA_INTERO

inherit
	ASSEGNA

create
	make_value, make_oper

feature -- attributi

	intero_da_assegnare: INTEGER
		-- valore intero da riassegnare

	tipo_di_aggiornamento: detachable STRING
		-- incremento o decremento ('inc' o 'dec')

feature -- creazione parametrica

	make_value (variabile, espressione: STRING)
	do
		elemento_da_modificare := variabile
		intero_da_assegnare := espressione.to_integer
	end

	make_oper (variabile, espressione: STRING)
	do
		elemento_da_modificare := variabile
		tipo_di_aggiornamento := espressione
	end

feature -- modifica per interi

	modifica_valore (variabili_booleane: HASH_TABLE [BOOLEAN, STRING]; variabili_intere: HASH_TABLE [INTEGER, STRING])
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

end
