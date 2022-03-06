-- trigger per lo stato di riproduzione
DROP TRIGGER IF EXISTS check_statoRiproduzione;
DELIMITER $$
CREATE TRIGGER check_statoRiproduzione BEFORE INSERT ON riproduzione
FOR EACH ROW 
BEGIN
	
    IF NEW.Stato <> 'Successo' AND NEW.Stato <> 'Insuccesso' THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Stato non valido!";
    END IF;
    
END $$