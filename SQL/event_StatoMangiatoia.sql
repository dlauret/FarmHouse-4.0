DROP EVENT IF EXISTS ImmettiPasto;
DELIMITER $$
CREATE EVENT ImmettiPasto
ON SCHEDULE EVERY 12 HOUR
STARTS '2020-01-16 12:00:00'
DO
BEGIN
	DECLARE mangiatoia INT DEFAULT 0;
	DECLARE finito INT DEFAULT 0;
	DECLARE randForaggio INT DEFAULT 0;
    
    
	DECLARE cursore_mangiatoie CURSOR FOR
		SELECT Codice
        FROM mangiatoia;
	DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET finito = 1;
    
    OPEN cursore_mangiatoie;
    WHILE finito = 0 DO
		FETCH cursore_mangiatoie  INTO mangiatoia;
        
        SELECT ROUND(RAND() * (SELECT MAX(Codice) FROM foraggio))
        INTO randForaggio;
        
        INSERT INTO statomangiatoia
		VALUES(mangiatoia, current_timestamp, 100, randForaggio);
		
    END WHILE;
    
    CLOSE cursore_mangiatoie;
END $$


DROP EVENT IF EXISTS ResetPastoPranzo;
DELIMITER $$
CREATE EVENT ResetPastoPranzo
ON SCHEDULE EVERY 1 DAY
STARTS '2020-01-16 18:00:00'
DO
BEGIN
	DECLARE mangiatoia INT DEFAULT 0;
	DECLARE finito INT DEFAULT 0;
    
    
	DECLARE cursore_mangiatoie CURSOR FOR
		SELECT Codice
        FROM mangiatoia;
	DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET finito = 1;
    
    OPEN cursore_mangiatoie;
    WHILE finito = 0 DO
		FETCH cursore_mangiatoie  INTO mangiatoia;
        
        INSERT INTO statomangiatoia
		VALUES(mangiatoia, current_timestamp, 0, null);
		
    END WHILE;
    CLOSE cursore_mangiatoie;
    
END $$


DROP EVENT IF EXISTS ResetPastoCena;
DELIMITER $$
CREATE EVENT ResetPastoCena
ON SCHEDULE EVERY 1 DAY
STARTS '2020-01-16 01:00:00'
DO
BEGIN
	DECLARE mangiatoia INT DEFAULT 0;
	DECLARE finito INT DEFAULT 0;
    
    
	DECLARE cursore_mangiatoie CURSOR FOR
		SELECT Codice
        FROM mangiatoia;
	DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET finito = 1;
    
    OPEN cursore_mangiatoie;
    WHILE finito = 0 DO
		FETCH cursore_mangiatoie  INTO mangiatoia;
        
        INSERT INTO statomangiatoia
		VALUES(mangiatoia, current_timestamp, 0, null);
		
    END WHILE;
    CLOSE cursore_mangiatoie;
END $$


DROP EVENT IF EXISTS CheckPasto;
DELIMITER $$
CREATE EVENT CheckPasto
ON SCHEDULE EVERY 30 MINUTE
STARTS '2020-01-16 12:30:00'
DO
BEGIN
	DECLARE mangiatoia INT DEFAULT 0;
	DECLARE finito INT DEFAULT 0;
	DECLARE lastForaggio INT DEFAULT 0;
    DECLARE lastQuantita INT DEFAULT 0;
    DECLARE quantitaDaInserire INT DEFAULT 0;

	DECLARE cursore_mangiatoie CURSOR FOR
		SELECT Codice
        FROM mangiatoia;
	DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET finito = 1;
    
    OPEN cursore_mangiatoie;
    WHILE finito = 0 DO
		FETCH cursore_mangiatoie  INTO mangiatoia;
        
        -- query per trovare il foraggio e la quantita usato nell'ulimo check
        SELECT SM.Foraggio, SM.Quantita
        FROM statomangiatoia SM
        WHERE SM.Istante = ( 
				SELECT	MAX(SM2.Istante)
                FROM	statomangiatoia SM2
                WHERE	SM2.Mangiatoia = mangiatoia
				)
                AND SM.Mangiatoia = mangiatoia
        INTO lastForaggio, lastQuantita;
        
        SET quantitaDaInserire = (
			IF(lastQuantita - lastQuantita*0.2 < 0, 0, lastQuantita - lastQuantita*0.2)
        );
        
        IF lastForaggio IS NOT NULL THEN
			INSERT INTO statomangiatoia
			VALUES(mangiatoia, current_timestamp, quantitaDaInserire, lastForaggio);
		END IF;
		
    END WHILE;
    CLOSE cursore_mangiatoie;

END $$
