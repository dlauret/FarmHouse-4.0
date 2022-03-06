DROP EVENT IF EXISTS trigger_parametriLocale;
DELIMITER $$
CREATE EVENT trigger_parametriLocale
ON SCHEDULE EVERY 4 HOUR
STARTS '2020-01-13 12:00:00'
DO
BEGIN
	DECLARE locale INT DEFAULT 0;
    DECLARE temperatura INT DEFAULT 0;
    DECLARE umidita INT DEFAULT 0;
    DECLARE LivAzoto INT DEFAULT 0;
    DECLARE LivMetano INT DEFAULT 0;
    DECLARE LivSporco INT DEFAULT 0;
	DECLARE finito INT DEFAULT 0;
	DECLARE sensore INT DEFAULT 0;
    
    
	DECLARE cursore_locali CURSOR FOR
		SELECT Codice
        FROM locale;
	DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET finito = 1;
    
    OPEN cursore_locali;
    WHILE finito = 0 DO
		FETCH cursore_locali  INTO locale;
        
        SELECT ROUND(5 + RAND() * 30)
        INTO temperatura;
        SELECT ROUND(40 + RAND() * 100)
        INTO umidita;
        SELECT ROUND(RAND() * 10)
        INTO LivAzoto;
        SELECT ROUND(RAND() * 10)
        INTO LivMetano;
        SELECT ROUND(RAND() * 10)
        INTO LivSporco;
        
        INSERT INTO sensore (Temperatura, Umidita, LivAzoto, LivMetano, LivSporco, Locale)
		VALUES(temperatura, umidita, LivAzoto, LivMetano, LivSporco, locale);
        
        SELECT codice INTO sensore
        FROM sensore S
        WHERE S.temperatura = temperatura
			and S.Umidita = umidita
            and S.LivAzoto = LivAzoto
            and S.LivSporco = LivSporco
            and S.Locale = locale;
		
        INSERT INTO statosensore 
        VALUES (current_timestamp, sensore ,null);
    END WHILE;
    CLOSE cursore_locali;
END $$