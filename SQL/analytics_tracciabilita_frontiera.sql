-- Analytics tracciabilità di filiera
/*
1)	se il numero dei resi è maggiore o uguale del 60% delle unità ordinate
		allora eliminiamo tutti i prodotti unitari di quel prodotto
		e andiamo a modificare i parametri ideali delle fasi del prodotto
		tenendo conto dei parametri di qualità del prodotto analizzati dopo il reso (ultimo reso effettuato).
        (ipotizziamo par. ideali ricetta = par. qualità reso)

2)	se le vendite del mese corrente sono incrementate del 30% o più rispetto a quelle del mese precedente e non ci sono stati resi
		aumento del costo del prodotto del 5%
3)  se le vendite del mese corrente sono diminuite del 50% o più rispetto a quelle del mese precedente
		diminuzione del costo del prodotto del 10%

*/
DROP PROCEDURE IF EXISTS tracciabilita;
DELIMITER $$
-- passiamo come parametro il prodotto
CREATE PROCEDURE tracciabilita (IN _prodotto VARCHAR(50))
BEGIN
	
    DECLARE countRecensioniNeg INT DEFAULT 0;
    DECLARE countResi INT DEFAULT 0;
    DECLARE dataUltimoReso DATE DEFAULT NULL;
    
    DECLARE venditePastMonth INT DEFAULT 0;
	DECLARE venditeCurrentMonth INT DEFAULT 0;

    
    -- calcoliamo il numero di recensioni negative del prodotto del mese in corso
    SELECT	COUNT(*)
    FROM	recensione R
			INNER JOIN
            unitaprodotto U ON R.UnitaProdotto = U.Codice
            INNER JOIN
            prodottocaseario P ON U.ProdottoCaseario = P.Nome
    WHERE	P.Nome = _prodotto
			AND
            (
				R.Gradimento < 5
				OR R.Qualita < 5
                OR R.Gusto < 5
			)
			AND
            (
				YEAR(CURRENT_DATE) = YEAR(R.Data)
				AND MONTH(R.Data) = MONTH(CURRENT_DATE)
			)
	INTO countRecensioniNeg;	 
    
    -- calcoliamo il numero di resi del prodotto e la data dell'ultimo reso (mese corrente)
    SELECT	COUNT(*), MAX(R.DataReso)
    FROM	reso R
			INNER JOIN
            unitaprodotto U ON R.UnitaProdotto = U.Codice
            INNER JOIN
            prodottocaseario P ON U.ProdottoCaseario = P.Nome
    WHERE	P.Nome = _prodotto
			AND
            (
				YEAR(CURRENT_DATE) = YEAR(R.DataReso)
				AND MONTH(R.DataReso) = MONTH(CURRENT_DATE)
			)
    INTO countResi, dataUltimoReso;
    
    -- se il numero dei resi è maggiore o uguale del 60% dei prodotti ordinati
    -- allora eliminiamo tutti i prodotti unitari di quel prodotto
    
    -- numero vendite prodotto mese attuale
    SELECT	SUM(S.Quantita)
    FROM	selezione S
			INNER JOIN
            ordine O ON S.Ordine = O.Codice
    WHERE	(
				YEAR(CURRENT_DATE) = YEAR(O.Time)
				AND MONTH(O.Time) = MONTH(CURRENT_DATE)
			)
            AND S.ProdottoCaseario = _prodotto
	INTO venditeCurrentMonth;
    
    -- cancellazione se rispetta la condizione
    IF (countResi >= 0.6*venditeCurrentMonth) AND (countRecensioniNeg > 0) THEN
		DELETE	U.*
        FROM	unitaprodotto U
        WHERE	U.ProdottoCaseario = _prodotto;
        
        /*
        Adesso andiamo a modificare i parametri ideali delle fasi del prodotto
        tenendo conto dei parametri di qualità del prodotto analizzati dopo il reso.
        Creazione di una temporary table per i parametri del prodotto da modificare
        */
        DROP TEMPORARY TABLE IF EXISTS _parametro;
        CREATE TEMPORARY TABLE _parametro(
            Parametro VARCHAR(50) NOT NULL PRIMARY KEY
        );
        
        INSERT INTO _parametro
			SELECT	IF(PR.Valutazione < 5, PID.Parametro, '0')
			FROM
					( -- parametri ideali e quantità
					SELECT	C.Parametro, C.Quantita
					FROM	prodottocaseario P
							INNER JOIN
							composta C ON C.Prodotto = P.Nome
					WHERE	P.Nome = _prodotto
					) AS PID -- par. ideali
					NATURAL JOIN
					( -- parametri qualita e valutazione sull'ultimo reso effettuato
						SELECT	C.ParametroQualita AS Parametro, C.Valutazione
						FROM	controllo C
								INNER JOIN
								reso R ON C.Reso = R.Codice
								INNER JOIN
								unitaprodotto U ON R.UnitaProdotto = U.Codice
								INNER JOIN
								prodottocaseario P ON U.ProdottoCaseario = P.Nome
						WHERE	P.Nome = _prodotto
								AND R.DataReso = dataUltimoReso
					) AS PR -- par. reso
			GROUP BY PID.Parametro;
            
            -- Variazione della quantita del parametro (da -10 a + 10)
            UPDATE 	composta C
					NATURAL JOIN
                    _parametro PP
			SET		C.Quantita = C.Quantita + (FLOOR(RAND()*(-10) + RAND()*(10)))
            WHERE	C.Prodotto = _prodotto; 
        
    END IF;
    
    
    -- aumento costo prodotto se le vendite del mese corrente sono incrementate del 30% rispetto a quelle del mese precedente
	SELECT	SUM(S.Quantita)
    FROM	selezione S
			INNER JOIN
            ordine O ON S.Ordine = O.Codice
    WHERE	(
			IF(MONTH(CURRENT_DATE) = 1, 
					YEAR(CURRENT_DATE) - 1 = YEAR(O.Time)
                    AND MONTH(O.Time) = 12,
						YEAR(CURRENT_DATE) = YEAR(O.Time)
                    AND MONTH(O.Time) = MONTH(CURRENT_DATE)-1)
			)
            AND S.ProdottoCaseario = _prodotto
	INTO venditePastMonth;
    
    
    -- aumento del costo del prodotto del 5%
    IF (venditeCurrentMonth > venditePastMonth*1.3) AND countResi = 0  THEN
		UPDATE prodottoCaseario
        SET	costo = costo * 1.05 -- aumento del 5%
        WHERE Nome = _prodotto;
    -- diminuzione del costo del prodotto del 10%     
	ELSEIF (venditeCurrentMonth <= venditePastMonth*0.5) AND countResi > 0 THEN
		UPDATE prodottoCaseario
        SET	costo = costo - costo * 0.1 -- diminuzione del 10%
        WHERE Nome = _prodotto;
    END IF;
END $$