DROP EVENT IF EXISTS event_statoCantina;
DELIMITER $$
CREATE EVENT event_statoCantina
ON SCHEDULE EVERY 1 DAY
STARTS '2020-01-14 12:00:00'
DO
BEGIN
	DECLARE cantina INT DEFAULT 0;
	DECLARE finito INT DEFAULT 0;
	DECLARE randTemp FLOAT DEFAULT 0;
    DECLARE randUmi FLOAT DEFAULT 0;
    
    
	DECLARE cursore_cantina CURSOR FOR
		SELECT Codice
        FROM cantina;
	DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET finito = 1;
    
    OPEN cursore_cantina;
    WHILE finito = 0 DO
		FETCH cursore_cantina  INTO cantina;
        
        SET randTemp = ROUND(5 + RAND() * 20);

        SET randUmi = ROUND(40 + RAND() * 100);
        
        INSERT INTO statocantina
		VALUES(current_timestamp, cantina, randTemp, randUmi);
		
    END WHILE;
    
    CLOSE cursore_cantina;
END $$