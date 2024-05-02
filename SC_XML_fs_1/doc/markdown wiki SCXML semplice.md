# Introduzione

Lo scopo di questo file è descrivere le caratteristiche di tutti i file XML che sono riconosciuti ed eseguiti dal progetto SC_XML_fs_1 scritto in EIFFEL. I file eseguibili si basano sulla specifica SCXML con alcune variazioni per renderlo più semplice. Ora elencherò tutti i controlli riguardo la sintassi che esegue il progetto (principalmente nella classe CONFIGURAZIONE)
# Specifiche

## &lt;scxml&gt;

Questo è l'elemento di massimo livello del file. Attualmente non viene controllato che sia abbia etichetta *'scxml'*. 

Nella specifica SCXML deve avere attributi *'xmlns'* e *'version'* ma qui non viene controllato. È possibile inserire attributo *'initial'* per specificare lo stato iniziale. Se c'è *'initial'* il suo valore deve essere un *'id'* valido cioè deve essere *'id'* di uno stato. (warning se non è presente *'initial'*) 

#### Può avere come figli:
- &lt;state&gt;
- &lt;parallel&gt;
- &lt;final&gt;
- &lt;datamodel&gt;
È obbligatorio che ci sia almeno un figlio *&lt;state&gt;* o  *&lt;parallel&gt;*.

## &lt;datamodel&gt;
È un elemento wrapper che contiene 0 o più elementi *&lt;data&gt;*. (warning se ne contiene 0) 
Attualmente non viene verificato che i sui figli siamo *&lt;data&gt;*ma è sufficiente che abbiamo gli attributi corretti.

## &lt;data&gt;
Serve per dichiarare le variabili del Datamodel. Deve avere come attributi *'id'* e *'expr'*.
Non può avere come *'id'* la stringa vuota o blank o 'NULL'.
*'expr'* deve essere 'true' o 'false' oppure un intero.

## &lt;final&gt;
Rappresenta uno stato finale. Deve avere attributo *'id'*. Non ci sono controlli a riguardo

## &lt;state&gt;
Rappresenta uno stato XOR. Se non ha figlii *&lt;state&gt;* o *&lt;parallel&gt;* si chiama stato atomico, altrimenti si chiama stato gerarchico.
Deve avere attributo *'id'*. Non può avere come valore di  *'id'* la stringa vuota o blank o 'NULL' e non può essere un duplicato.
Può avere *'initial'* come attributo se e solo se non è uno stato atomico. L'eventuale valore di *'initial'* deve essere l' *'id'* di un figlio dello stato. 

#### Può avere come figli:
- &lt;transition&gt;
- &lt;onentry&gt;
- &lt;onexit&gt;
- &lt;history&gt;
- &lt;state&gt;
- &lt;parallel&gt;

## &lt;parallel&gt;
Rappresenta uno stato AND.
Deve avere attributo *'id'*. Non può avere come valore di *'id'* la stringa vuota o blank o 'NULL' e non può essere un duplicato.
Deve avere come figlio *&lt;state&gt;* o *&lt;parallel&gt;*

#### Può avere come figli:
- &lt;transition&gt;
- &lt;onentry&gt;
- &lt;onexit&gt;
- &lt;history&gt;
- &lt;state&gt;
- &lt;parallel&gt;
	
## &lt;transition&gt;

Deve avere attributo *'target'* . Il valore di *'target'* deve essere i valori di *'id'* di stati separati da almeno uno spazio.
Se c'è un solo *'id'* come valore di *'target'*, *'transition'* può avere attributo *'souce'*. *'source'* può essere vuoto (warning), se il valore di *'source'* ha più stati (specificati come prima) ho una transazione merge. Se ho più stati target non posso avere attiributo *'source'* e ho una tranzizione fork. Non è possibile avere una transizione fork e merge contemporaneamente. Errore se le sorgenti o le destinazioni non sono compatibile per le transizioni merge e fork.

La transizione singola è illegale se il minimo antenato comune (MAC) è &lt;parallel&gt; e inoltre: sorgente e destinazione sono uno antenato dell'altro e sono tutti &lt;parallel&gt; dal più alto al genitore del più basso, oppure se MAC è diverso da entrambi (attraversamento frontiera).
La transizione singola può avere l'attributo *'type'* con valore internal per specificare se la transizione è interna quando è possibile.
*transition* può avere attributo *'event'* con valore qualsiasi.
*transition* può avere attributo *'cond'. L'eventuale valore di *'cond'* non può essere stringa vuota o blank o NULL. La condizione deve essere una striga che identifica un booleano nel datamodel oppure deve avere una striga che identifica un intero nel datamodel seguita da '<' o '>' o '/' o '='.

#### Può avere come figli:
- &lt;assign&gt;
- &lt;log&gt;
 *&lt;assign&gt;* e  *&lt;log&gt; * possono occorrere 0 o più volte. Altri elementi vengono ignorati con un warning

## &lt;onentry&gt;

#### Può avere come figli:
- &lt;assign&gt;
- &lt;log&gt;

## &lt;onexit&gt;

#### Può avere come figli:
- &lt;assign&gt;
- &lt;log&gt;

## &lt;assign&gt;
*'assign'* deve avere attributo *'location'* e *'expr'*. Il valore di *'location'* deve essere l'*'id'* di un *'data'* nel  *'datamodel'*.   Il valore di *'expr'* deve essere un valore tra questi: 'true' , 'false' , 'inc' , 'dec' o un intero.

## &lt;log&gt;
*'log'* deve avere attributo *'name'*. Il valore di *'name'* può essere qualsiasi. 

## &lt;history&gt;
Questo elemento può essere figlio solo di *'state'* (warning se figlio di *'paralle'*).
Può avere attributi *'id'* e *'type'*.  Il valore di *'id'* può essere qualsiasi. Il valore di *'type'* può essere 'deep', negli altri casi viene considerato 'shallow'.