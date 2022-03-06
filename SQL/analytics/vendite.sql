/*
1)	se le vendite del mese corrente sono incrementate del 30% o più rispetto a quelle del mese precedente e non ci sono stati resi
		aumento del costo del prodotto del 5%
2)  se le vendite del mese corrente sono diminuite del 50% o più rispetto a quelle del mese precedente
		diminuzione del costo del prodotto del 10%
*/

DROP PROCEDURE IF EXISTS analisi_vendite;
DELIMITER $$
-- passiamo come parametro il prodotto
CREATE PROCEDURE analisi_vendite (IN _prodotto VARCHAR(50))
BEGIN
	
	DECLARE venditeCurrentMonth INT DEFAULT 0;
    DECLARE venditePastMonth INT DEFAULT 0;
	DECLARE countResi INT DEFAULT 0;
        
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
    
        -- calcoliamo il numero di resi del prodotto
    SELECT	COUNT(*)
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
    INTO countResi;
    
    
    -- aumento costo prodotto se le vendite del mese corrente sono incrementate del 30% rispetto a quelle del mese precedente
    
    -- vendite del mese passato
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


CALL analisi_vendite('Grana Padano');