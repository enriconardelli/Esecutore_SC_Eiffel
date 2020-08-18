note
	description: "La classe che rappresenta l'azione di assegnazione per valori BOOLEANI"
	author: "EN + studenti corsi PSI"
	date: "$Date$"
	revision: "0"

class
	ASSEGNA_BOOLEANO

inherit
	ASSEGNA

create
	make_value

feature -- attributi

	booleano_da_assegnare: BOOLEAN
		-- valore booleano da riassegnare

feature -- creazione parametrica

	make_value (variabile, espressione: STRING)
	do
		elemento_da_modificare := variabile
		booleano_da_assegnare := espressione.as_lower ~ "true"
	end

feature -- modifica per booleani

	modifica_valore (variabili: DATAMODEL)
--	modifica_valore (variabili_booleane: HASH_TABLE [BOOLEAN, STRING]; variabili_intere: HASH_TABLE [INTEGER, STRING])
		do
			if variabili.booleane.has (elemento_da_modificare) then
				debug("sc_modifica_variabili") print("  ASSIGN: " + booleano_da_assegnare.out + " --> " + elemento_da_modificare + "%N") end
				variabili.booleane.replace (booleano_da_assegnare, elemento_da_modificare)
				debug("sc_modifica_variabili") print("  -> Booleano: " + elemento_da_modificare + " = " + variabili.booleane[elemento_da_modificare].out + "%N") end
			end
--			if variabili_booleane.has (elemento_da_modificare) then
--				debug("sc_modifica_variabili") print("  ASSIGN: " + booleano_da_assegnare.out + " --> " + elemento_da_modificare + "%N") end
--				variabili_booleane.replace (booleano_da_assegnare, elemento_da_modificare)
--				debug("sc_modifica_variabili") print("  -> Booleano: " + elemento_da_modificare + " = " + variabili_booleane[elemento_da_modificare].out + "%N") end
--			end
		end

end
