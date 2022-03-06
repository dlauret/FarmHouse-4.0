DROP EVENT IF EXISTS event_Spedizione;
DELIMITER $$
CREATE EVENT event_Spedizione
ON SCHEDULE EVERY 1 DAY
STARTS '2020-01-15 12:00:00'
DO
BEGIN
    DECLARE finito INTEGER DEFAULT 0;
    DECLARE statoCorrente VARCHAR(50) DEFAULT "";
    DECLARE statoSuccessivo VARCHAR(50) DEFAULT "";
    DECLARE Spedizione INTEGER DEFAULT 0;
    
    DECLARE cursoreSpedizioni CURSOR FOR
		SELECT S.Codice, S.Stato
		FROM Spedizione S
        WHERE S.Stato <> "Consegnato";	
        
	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET finito = 1;
    
    OPEN cursoreSpedizioni;
    
    WHILE finito = 0 DO
		FETCH cursoreSpedizioni  INTO Spedizione, statoCorrente;
        
		CASE
			WHEN statoCorrente = "Spedita" THEN
				SET statoSuccessivo = "In transito";
			WHEN statoCorrente = "In transito" THEN
				SET statoSuccessivo = "In consegna";
			WHEN statoCorrente = "In consegna" THEN
				SET statoSuccessivo = "Consegnato";
		END CASE; 
                
        UPDATE Spedizione S
        SET Stato = statoSuccessivo
        WHERE S.Codice = Spedizione;
        
    END WHILE;    
    
    CLOSE cursoreSpedizioni;
END $$
