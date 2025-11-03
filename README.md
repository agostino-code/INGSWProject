# INGSWProject

##### Introduzione

La gestione dei ristoranti richiede un'organizzazione accurata e

un'efficienza nello svolgimento delle operazioni quotidiane, per

garantire un'esperienza ottimale ai clienti.

Ratatouille è un'applicazione sviluppata per semplificare il lavoro dei camerieri e degli amministratori, consentendo loro di inviare ordini alla cucina, gestire i dipendenti e il menu del ristorante. Grazie all'integrazione con un generatore di OR code, Ratatouille consente inoltre di visualizzare il menu in diverse lingue tramite un sito web. Il supervisore ha accesso solo alla gestione del menu. In questa relazione tecnica verranno analizzate le tecnologie utilizzate per lo sviluppo dell'applicazione, l'architettura del sistema e le principali funzionalità offerte, nonché le metodologie utilizzate per testare l'applicazione e garantire la sua sicurezza.

##### Analisi dei requisiti

Ratatouille23 è un sistema finalizzato alla gestione e all'operatività di attività di ristorazione. L'applicazione offre numerose funzionalità per semplificare la gestione del ristorante e migliorare l'esperienza dei clienti. Di seguito analizziamo in dettaglio i requisiti principali dell'app:

Gestione utenti: uno dei requisiti principali dell'app è la possibilità per l'amministratore di creare utenze per i propri dipendenti, specificando il loro ruolo all'interno del ristorante (sala, cucina, supervisori). Questo consente di limitare l'accesso a determinate funzionalità in base al ruolo dell'utente. Inoltre, ogni utente deve reimpostare la password al primo accesso per motivi di sicurezza.

Personalizzazione menù: l'app consente all'amministratore o ai supervisori di personalizzare il menù del ristorante. In particolare, è possibile creare e/o eliminare elementi dal menu, organizzarli in categorie personalizzabili e definire l'ordine con cui gli elementi
compaiono nel menù.

Inoltre, è richiesto l'auto completamento di alcuni prodotti utilizzando open data come quelli disponibili in it.openfoodfacts.org Questo consente di creare un menù coerente con il tema del ristorante e di tenere traccia degli ingredienti utilizzati.