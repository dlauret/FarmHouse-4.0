-- trigger per verificare l'ora
DROP TRIGGER IF EXISTS check_orario;
DELIMITER $$
CREATE TRIGGER check_orario BEFORE INSERT ON orario
FOR EACH ROW 
BEGIN
	
   IF NEW.Ora <> 'M' AND NEW.Ora <> 'P' AND NEW.Ora <> 'S' THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Ora non valida!";
    END IF;
    
END $$