note
	description: "Classe radice del progetto"
	author: " Daniele Fakhoury & Eloisa Scarsella "
	date: "$Date$"
	revision: "  "

class
	ESECUTORE

create
	make, start

feature -- Attributi

	state_chart: CONFIGURAZIONE
			-- rappresenta la SC durante la sua esecuzione

	ambiente_corrente: AMBIENTE
			-- rappresenta l'ambiente in cui la SC si evolve

	conf_base_corrente: ARRAY [STATO]
			-- insieme degli stati base nella configurazione corrente della SC e non di tutti gli stati attivi

	visitati_in_discesa: ARRAY [STATO]
			-- insieme di stati visitati durante l'uscita nella discesa verso il basso a partire dallo stato corrente

feature {NONE} -- Creazione e avvio interattivo

	start (nomi_files: ARRAY [STRING])
			-- prepara la SC e avvia la sua esecuzione
		do
			make (nomi_files)
			print ("%N=========%N EVOLUZIONE INIZIO%N")
			evolvi_SC (ambiente_corrente.eventi_esterni)
			print ("%N EVOLUZIONE FINE!%N=========%N")
		end

feature -- Creazione per i test

	make (nomi_files: ARRAY [STRING])
			-- prepara la SC con i parametri passati come argomento
			-- in Eiffel Studio vanno invece scritti mediante il
			-- menu "Execution" -> "Execution Parameters" -> "Add"
			-- doppio click su spazio bianco accanto a "Arguments"
			-- scrivere i parametri ognuno tra doppi apici
		do
			print ("%N=========%N CREAZIONE INIZIO%N")
			print ("crea la SC in " + nomi_files [1] + "%N")
			create state_chart.make (nomi_files [1])
			create conf_base_corrente.make_empty
			create visitati_in_discesa.make_empty
			conf_base_corrente.copy (state_chart.stato_iniziale)
			create ambiente_corrente.make_empty
			if not state_chart.ha_problemi_con_il_file_della_sc then
				print ("e la esegue con gli eventi in " + nomi_files [2] + "%N")
				ambiente_corrente.acquisisci_eventi (nomi_files [2])
				print ("acquisiti eventi %N")
				if not ambiente_corrente.verifica_eventi_esterni (state_chart) then
					print ("WARNING nel file ci sono eventi che la SC non conosce %N")
				end
				print ("eventi verificati, si esegue la SC %N")
				evolvi_SC (ambiente_corrente.eventi_esterni)
			else
				print ("Ci sono problemi con il file xml.%N")
				print ("Programma terminato.%N")
			end
			print ("%N CREAZIONE FINE%N=========%N")
		end

feature -- evoluzione della statechart

	evolvi_SC (istanti: ARRAY [LINKED_SET [STRING]])
		local
			count_istante_corrente: INTEGER
			i: INTEGER
			prossima_conf_base: ARRAY [STATO]
			condizioni_correnti: HASH_TABLE [BOOLEAN, STRING]
			transizione_corrente: TRANSIZIONE
			target_precedente: detachable STATO
		do
			print ("%Nentrato in evolvi_SC:  %N %N")
			print ("stato iniziale:  ")
			stampa_conf_corrente
			create condizioni_correnti.make (1)
			from
				count_istante_corrente := 1
			until
				stato_final (conf_base_corrente) or count_istante_corrente > istanti.count
			loop
				if attached istanti [count_istante_corrente] as istante_corrente then
					print ("Indice istante corrente = ")
					print (count_istante_corrente)
					print ("%N")
					condizioni_correnti.copy (state_chart.condizioni)
					create prossima_conf_base.make_empty
					target_precedente:=void
					from
						i := conf_base_corrente.lower
					until
						i = conf_base_corrente.upper + 1
					loop
						transizione_corrente := conf_base_corrente [i].transizione_abilitata (istante_corrente, condizioni_correnti)
						if conf_base_corrente[i].attivo and attached transizione_corrente as tc then
							-- `conf_base_corrente[i].attivo' serve per prevenire configurazioni non ammissibili
							if (attached target_precedente implies (attached{STATO_AND} trova_contesto(target_precedente,tc.target))) then
								esegui_azioni (tc, conf_base_corrente [i])
--								disattiva_discendenti (genitore_piu_grande(conf_base_corrente [i], transizione_corrente))
								trova_default (tc.target, prossima_conf_base)
								aggiungi_paralleli (tc.target, prossima_conf_base)
								target_precedente:=tc.target
							else
								prossima_conf_base.force (conf_base_corrente [i], prossima_conf_base.count + 1)
							end
						else
							prossima_conf_base.force (conf_base_corrente [i], prossima_conf_base.count + 1)
						end
						i := i + 1
					end
					prossima_conf_base := stati_attivi_conf(prossima_conf_base)
					prossima_conf_base := riordina_conf_base(prossima_conf_base)
					if not prossima_conf_base.is_empty then
						conf_base_corrente.copy (prossima_conf_base)
					end
				end
				count_istante_corrente := count_istante_corrente + 1
				stampa_conf_corrente
			end
			print ("%NHo terminato l'elaborazione degli eventi nella seguente configurazione base%N")
			stampa_conf_corrente
		end

	stati_attivi_conf(conf_da_modificare: ARRAY[STATO]): ARRAY[STATO]
	-- Arianna & Riccardo 26/04/2020
	-- elimina stati inattivi dalla configurazione
		local
			i: INTEGER
		do
			create Result.make_empty
			from
				i:=conf_da_modificare.lower
			until
				i=conf_da_modificare.upper+1
			loop
				if conf_da_modificare[i].attivo then
					Result.force(conf_da_modificare[i],Result.count+1)
				end
				i:=i+1
			end
		end

	genitore_piu_grande(stato_corrente: STATO; transizione: TRANSIZIONE): STATO
	-- Arianna & Riccardo 01/05/2020
	-- restituisce l'antenato più grande che contiene stato_corrente ed è contenuto nel contesto
		local
			contesto, stato_temp: detachable STATO
		do
			Result := stato_corrente
			if transizione.internal then
				contesto := transizione.sorgente
			else
				contesto := trova_contesto (transizione.sorgente, transizione.target)
			end

			from
				stato_temp := stato_corrente
			until
			 	stato_temp  = contesto
			loop
				if attached stato_temp then
					Result := stato_temp
					stato_temp := stato_temp.stato_genitore
				end
			end
		end


		disattiva_discendenti (stato: STATO)
		-- Arianna & Riccardo 01/05/2020
		do
			if attached{STATO_AND} stato as sa then sa.set_stato_inattivo_con_discendenti
			elseif attached{STATO_XOR} stato as sx then sx.set_stato_inattivo_con_discendenti
			else stato.set_inattivo
			end
		end

--	parallelo_antenato(stato: STATO): detachable STATO
--	-- Riccardo Malandruccolo
--		-- restituisce parallelo antenato più vicino
--		do
--			if attached {STATO_AND} stato then
--				Result := stato
--			elseif attached stato.stato_genitore as gen then
--				if attached {STATO_AND} gen then
--					Result := gen
--				else
--					Result := parallelo_antenato(gen)
--				end
--			end
--		end


	aggiungi_paralleli (target: STATO; prossima_conf_base: ARRAY [STATO])
		local
			i: INTEGER
		do
			target.set_attivo
			if attached {STATO_AND} target.stato_genitore  as sgt and then not sgt.attivo then
				from
					i := sgt.stato_default.lower
				until
					i = sgt.stato_default.upper + 1
				loop
					if not sgt.stato_default [i].is_equal(target) then
						trova_default (sgt.stato_default [i], prossima_conf_base)
					end
					i := i + 1
				end
			end
			if attached target.stato_genitore as sgt then
				aggiungi_paralleli (sgt, prossima_conf_base)
			end
		end

	trova_default (stato: STATO; prossima_conf_base: ARRAY [STATO])
		local
			i: INTEGER
		do
			stato.set_attivo
			if stato.onentry.count>0 then
				across
					stato.onentry as oe
				loop
					oe.item.action (state_chart.condizioni)
				end
			end
			if not stato.stato_default.is_empty then
				from
					i := stato.stato_default.lower
				until
					i = stato.stato_default.upper + 1
				loop
					trova_default (stato.stato_default [i], prossima_conf_base)
					i := i + 1
				end
			elseif not prossima_conf_base.has (stato) then
				-- `stato' è uno stato atomico
				-- TODO serve aggiungere un test che impedisca di inserire in prossima_conf_base uno stato se già c'è?'
				prossima_conf_base.force (stato, prossima_conf_base.count + 1)
			end
		end

	esegui_azioni (transizione: TRANSIZIONE; stato: STATO)
		local
			contesto: detachable STATO
		do
			if transizione.internal then
				contesto := transizione.sorgente
			else
				contesto := trova_contesto (transizione.sorgente, transizione.target)
			end
			-- TODO: impostaziona alternativa_1 esegui_uscita(contesto) che risale fino al genitore_piu_grande e poi
			-- lo visita ricorsivamente urscendo dai suoi discendenti dal basso verso l'alto
			-- TODO: impostazione alternativa_2 per ogni stato in conf_base_corrente si esce di un passo verso l'alto
			-- alla volta, fino ad arrivare al genitore_piu_grande
--			esegui_uscita (stato, contesto)
--			visitati_in_discesa.wipe_out
			esegui_azioni_onexit (stato, contesto)
			esegui_azioni_transizione (transizione.azioni)
			esegui_azioni_onentry (contesto, transizione.target)
		end

	trova_contesto (p_sorgente, p_destinazione: STATO): detachable STATO
			-- trova il contesto in base alla specifica SCXML secondo cui il contesto
			-- è il minimo antenato comune PROPRIO a p_sorgente e p_destinazione
		local
			antenati: HASH_TABLE [STRING, STRING]
			corrente: STATO
		do
			create antenati.make (0)
				-- "marca" tutti gli antenati di p_sorgente incluso
			from
				corrente := p_sorgente.stato_genitore
			until
				corrente = Void
			loop
				antenati.put (corrente.id, corrente.id)
				corrente := corrente.stato_genitore
			end
				-- trova il piï¿½ basso antenato di p_destinazione in "antenati"
			from
				corrente := p_destinazione
			until
				corrente = Void or else antenati.has (corrente.id)
			loop
				corrente := corrente.stato_genitore
			end
			Result := corrente
		end

	esegui_uscita (p_stato_corrente: STATO; p_contesto: detachable STATO)
		do
			if p_stato_corrente /= p_contesto and p_stato_corrente.attivo then
				visitati_in_discesa.force(p_stato_corrente, visitati_in_discesa.count+1)
--	ESEGUE USCITA DAI MIEI DISCENDENTI
				if not p_stato_corrente.stato_atomico then
					across p_stato_corrente.stati_figli as sf
					loop esegui_uscita(sf.item, p_contesto)
					end
				end
-- ESEGUE USCITA DA ME
				esegui_onexit (p_stato_corrente)
				p_stato_corrente.set_inattivo
-- ESEGUE USCITA DAI MIEI EVENTUALI ANTENATI
				if attached p_stato_corrente.stato_genitore as sg and then not visitati_in_discesa.has(sg)then
					esegui_uscita (sg, p_contesto)
				end
			end
		end

	esegui_onexit (p_stato_corrente: STATO)
		do
			if p_stato_corrente.onexit.count>0 then
				across
					p_stato_corrente.onexit as ox
				loop
					ox.item.action (state_chart.condizioni)
				end
			end
		end

	esegui_azioni_onexit (p_stato_corrente: STATO; p_contesto: detachable STATO)
		do
			if p_stato_corrente /= p_contesto and p_stato_corrente.attivo then
				if p_stato_corrente.onexit.count>0 then
					across
						p_stato_corrente.onexit as ox
					loop
						ox.item.action (state_chart.condizioni)
					end
				end
				p_stato_corrente.set_inattivo
				if attached p_stato_corrente.stato_genitore as sg then
					esegui_azioni_onexit (sg, p_contesto)
				end
				if attached {STATO_AND} p_stato_corrente.stato_genitore as sg_and then
					esegui_onexit_figli(sg_and, sg_and)
				end
			end
		end

		esegui_onexit_figli(uno_stato: STATO; contesto: detachable STATO)
		-- Claudia & Federico 04/05/2020
			do
				if not uno_stato.stato_atomico then
					across uno_stato.stati_figli as sf
					loop
						if sf.item.attivo and sf.item.stato_atomico then
							esegui_azioni_onexit(sf.item,contesto)
						end
						esegui_onexit_figli(sf.item,contesto)
					end
				end
			end

	esegui_azioni_transizione (p_azioni: ARRAY [AZIONE])
		local
			i: INTEGER
		do
			from
				i := p_azioni.lower
			until
				i = p_azioni.upper + 1
			loop
				p_azioni [i].action (state_chart.condizioni)
				i := i + 1
			end
		end

	esegui_azioni_onentry (p_contesto: detachable STATO; p_target: STATO)
		do
			if attached p_target.stato_genitore as sg and then sg /= p_contesto then
				-- TODO qui esegue le on_entry risalendo sugli antenati. cioè in ordine inverso a quanto dovrebbe
				esegui_azioni_onentry (p_contesto, sg)
				if sg.onentry.count>0 then
					across
						sg.onentry as oe
					loop
						oe.item.action (state_chart.condizioni)
					end
				end
			end
		end

	stato_final (stato: ARRAY [STATO]): BOOLEAN
		require
			contesto: conf_base_corrente /= VOID
		local
			i: INTEGER
		do
			from
				i := conf_base_corrente.lower
			until
				i = conf_base_corrente.upper + 1
			loop
				if conf_base_corrente [i].finale then
					result := TRUE
				end
				i := i + 1
			end
		end

	riordina_conf_base(conf_base:ARRAY[STATO]): ARRAY[STATO]
	--Agulini Claudia & Fiorini Federico 11/05/2020
	--Viene usata per riordinare la configurazione rispettando l' ordine del file xml
	local
		j: INTEGER
		conf_ordinata: ARRAY[STATO]
	do
		create conf_ordinata.make_empty
		j := conf_ordinata.lower
		across
			state_chart.stati as stati
		loop
			if conf_base.has (stati.item) then
				conf_ordinata.force(stati.item, j)
				j := j + 1
			end
		end
		result := conf_ordinata
	end

	stampa_conf_corrente
		do
			print ("configurazione corrente: ")
			across conf_base_corrente as cc
			loop
				print (cc.item.id + " ")
			end
			print (" %N")
		end

end
