-- trigger per verificare il tipo di carta
DROP TRIGGER IF EXISTS check_typeCarta;
DELIMITER $$
CREATE TRIGGER check_typeCarta BEFORE INSERT ON registrato
FOR EACH ROW 
BEGIN
	
   IF NEW.Tipologia <> 'CC' AND NEW.Tipologia <> 'PP' THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Tipologia carta non valida!";
    END IF;
    
END $$