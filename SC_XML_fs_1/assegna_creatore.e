note
	description: "Summary description for {ASSEGNA_CREATORE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ASSEGNA_CREATORE

feature -- creatore

	crea_istanza (variabile, espressione: STRING): ASSEGNA
		-- crea le istanze delle sottoclassi di ASSEGNA in funzione dei parametri passati
	require
		espressione_ammissibile (espressione)
	do
		if valore_booleano (espressione) then
			Result := create {ASSEGNA_BOOLEANO}.make_value (variabile, espressione)
		elseif valore_intero (espressione) then
			Result := create {ASSEGNA_INTERO}.make_value (variabile, espressione)
		elseif valore_operazione (espressione) then
			Result := create {ASSEGNA_INTERO}.make_oper (variabile, espressione)
		else
			-- impedisce errore di compilazione `Result' non assegnato propriamente (VEVI)
			Result := create {ASSEGNA_NULLA}.make_empty
		end
	end

feature -- controllo valori

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

feature -- ammissibilitÓ

	espressione_ammissibile (espressione: STRING): BOOLEAN
		do
			Result := valore_booleano (espressione) or valore_intero (espressione) or valore_operazione (espressione)
		end

	ammissibile (p_azione: XML_ELEMENT; variabili: DATAMODEL): TUPLE [esito: STRING; variabile: STRING; espressione: STRING]
		do
			if not attached p_azione.attribute_by_name ("location") as luogo then
				Result := ["senza_luogo", "", ""]
			elseif not variabili.booleane.has (luogo.value) and not variabili.intere.has (luogo.value) then
				Result := ["luogo_assente", luogo.value.as_string_8, ""]
			elseif not attached p_azione.attribute_by_name ("expr") as espressione then
				Result := ["senza_valore", luogo.value.as_string_8, ""]
			elseif not espressione_ammissibile (espressione.value) then
				Result := ["valore_errato", luogo.value.as_string_8, espressione.value.as_string_8]
			elseif variabili.intere.has (luogo.value) and valore_booleano(espressione.value) then
				Result := ["variabile_intera_con_espressione_booleana", luogo.value.as_string_8, espressione.value.as_string_8]
			elseif variabili.booleane.has (luogo.value) and (valore_intero(espressione.value) or valore_operazione (espressione.value)) then
				Result := ["variabile_booleana_con_espressione_intera", luogo.value.as_string_8, espressione.value.as_string_8]
			else
				Result := ["OK", luogo.value.as_string_8, espressione.value.as_string_8]
			end
		end

end
