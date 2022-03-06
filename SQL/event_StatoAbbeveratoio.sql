-- Event per cambiare ogni giorno la quantità di vitamine e sali minerali presenti nell'acqua

DROP EVENT IF EXISTS CheckWater;
DELIMITER $$
CREATE EVENT CheckWater
ON SCHEDULE EVERY 1 hour
DO
BEGIN
	DECLARE abbeveratoio INT DEFAULT 0;
	DECLARE finito INT DEFAULT 0;
    DECLARE quantitaSali INT DEFAULT 0;
    DECLARE quantitaVitamine INT DEFAULT 0;
    
    
	DECLARE cursore_abbeveratoio CURSOR FOR
		SELECT Codice
        FROM abbeveratoio;
	DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET finito = 1;
    
    OPEN cursore_abbeveratoio;
    WHILE finito = 0 DO
		FETCH cursore_abbeveratoio  INTO abbeveratoio;
                
        SET quantitaSali = (
			SELECT ROUND(RAND() * 10)
        );
        
        SET quantitaVitamine = (
			SELECT ROUND(RAND() * 10)
        );
        
        INSERT INTO statoabbeveratoio
		VALUES(abbeveratoio, current_timestamp, quantitaSali, quantitaVitamine, 100);
		
    END WHILE;
    CLOSE cursore_abbeveratoio;
    
END $$



-- Event per decrementare la quantità di acqua e per reinserirla quando scende sotto una soglia limite
DROP EVENT IF EXISTS updateWater$$
DELIMITER $$
CREATE EVENT updateWater
ON SCHEDULE EVERY 10 hour
DO
BEGIN
	DECLARE abbeveratoio INT DEFAULT 0;
	DECLARE finito INT DEFAULT 0;
	DECLARE lastSali INT DEFAULT 0;
	DECLARE lastVitamine INT DEFAULT 0;
    DECLARE lastQuantita FLOAT DEFAULT 0;
    DECLARE quantitaDaInserire FLOAT DEFAULT 0;
    
	DECLARE cursore_abbeveratoio CURSOR FOR
		SELECT Codice
        FROM abbeveratoio;
	DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET finito = 1;
    
    OPEN cursore_abbeveratoio;
    WHILE finito = 0 DO
		FETCH cursore_abbeveratoio  INTO abbeveratoio;
        
        -- query per trovare i sali minerali, vitamine e quantità usati precedentemente
        SELECT SA.SaliMinaerali, SA.Vitamine, SA.Quantita
        FROM statoabbeveratoio SA
        WHERE SA.Istante = ( 
				SELECT	MAX(SA2.Istante)
                FROM	statoabbeveratoio SA2
                WHERE	SA2.Abbeveratoio = abbeveratoio
				)
                AND SA.Abbeveratoio = abbeveratoio
        INTO lastSali, lastVitamine, lastQuantita;
        
        
			IF lastQuantita <= 15 then
				SET quantitaDaInserire = 100;
			ELSE
				SET quantitaDaInserire = lastQuantita - lastQuantita*0.2;
			END IF;
        
        INSERT INTO statoabbeveratoio
		VALUES(abbeveratoio, current_timestamp, lastSali, lastVitamine, quantitaDaInserire);
		
    END WHILE;
    CLOSE cursore_abbeveratoio;

END $$











