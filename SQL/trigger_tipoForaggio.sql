-- trigger per la tipologia di foraggio
DROP TRIGGER IF EXISTS check_typeForaggio;
DELIMITER $$
CREATE TRIGGER check_typeForaggio BEFORE INSERT ON foraggio
FOR EACH ROW 
BEGIN
	
    IF NEW.Tipo <> 'F' AND NEW.Tipo <> 'C' THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Tipologia foraggio non valida!";
    END IF;
    
END $$