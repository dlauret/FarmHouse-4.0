DROP EVENT IF EXISTS event_Acquisti;
DELIMITER $$
CREATE EVENT event_Acquisti
ON SCHEDULE EVERY 4 HOUR
STARTS '2020-01-13 12:00:00'
DO
BEGIN
    DECLARE finito INTEGER DEFAULT 0;
    DECLARE statoCorrente VARCHAR(50) DEFAULT "";
    DECLARE statoSuccessivo VARCHAR(50) DEFAULT "";
    DECLARE Ordine INTEGER DEFAULT 0;
    
    DECLARE cursoreOrdini CURSOR FOR
		SELECT O.Stato, O.Ordine
		FROM ordine O
        WHERE O.Stato <> "Evaso";	
        
	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET finito = 1;
    
    OPEN cursoreOrdini;
    
    WHILE finito = 0 DO
		FETCH cursoreOrdini  INTO statoCorrente, Ordine;
        
		CASE
			WHEN statoCorrente = "Processazione" THEN
				SET statoSuccessivo = "In Preparazione";
			WHEN statoCorrente = "In Preparazione" THEN
				SET statoSuccessivo = "Spedito";
			WHEN statoCorrente = "Spedito" THEN
				SET statoSuccessivo = "Evaso";
		END CASE; 
                
        UPDATE Ordine O
        SET Stato = statoSuccessivo
        WHERE O.Codice = Ordine;
        
    END WHILE;   
    CLOSE cursoreOrdini;
END $$
