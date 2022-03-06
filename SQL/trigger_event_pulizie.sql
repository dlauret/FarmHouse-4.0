DROP TRIGGER IF EXISTS trigger_pulizie;
DELIMITER $$
CREATE TRIGGER trigger_pulizie AFTER INSERT ON statosensore
FOR EACH ROW 
BEGIN
    DECLARE sogliaSporcizia INTEGER DEFAULT 5;
    DECLARE sogliaAzoto INTEGER DEFAULT 5;
    DECLARE sogliaMetano INTEGER DEFAULT 5;
    DECLARE flag BOOLEAN DEFAULT FALSE;
    DECLARE LivSporco INTEGER DEFAULT 0;
    DECLARE LivAzoto INTEGER DEFAULT 0;
    DECLARE LivMetano INTEGER DEFAULT 0;
    
    DECLARE sensore INTEGER DEFAULT 0;
    
    SELECT S.LivAzoto, S.LivMetano, S.LivSporco INTO LivAzoto, LivMetano, LivSporco
    FROM Sensore S
    WHERE S.Codice = NEW.Sensore;
    
    IF LivSporco > sogliaSporcizia THEN
		SET flag = TRUE;
	ELSEIF LivAzoto > sogliaAzoto THEN
		SET flag = TRUE;
	ELSEIF LivMetano > sogliaMetano THEN
		SET flag = TRUE;
	END IF;
    
    IF flag = TRUE THEN
		UPDATE statosensore
        SET stato = "Richiesto";
    END IF;
END $$



DROP EVENT IF EXISTS pulizia_effettuata;
DELIMITER $$
CREATE EVENT pulizia_effettuata
ON SCHEDULE EVERY 6 HOUR
STARTS '2020-01-13 12:00:00'
DO
BEGIN
	
    DECLARE time TIMESTAMP;
    DECLARE sensore INTEGER;	
    DECLARE finito INTEGER DEFAULT 0;
	   
    DECLARE cursore CURSOR FOR
		SELECT SS.Time, SS.Sensore
		FROM statosensore SS
		WHERE Stato = "Richiesto";
        
	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET finito = 1;
    
    OPEN cursore;
    
    WHILE finito = 0 DO
		FETCH cursore  INTO time, sensore;
                
        UPDATE statosensore SS
        SET Stato = "Effettuato"
        WHERE SS.Time = time
			and SS.sensore = sensore;
            
    END WHILE;    
END $$
