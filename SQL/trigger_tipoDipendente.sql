-- trigger per la tipologia di dipendente
DROP TRIGGER IF EXISTS check_typeDipendente;
DELIMITER $$
CREATE TRIGGER check_typeDipendente BEFORE INSERT ON dipendente
FOR EACH ROW 
BEGIN
	
    IF NEW.Tipologia <> 'L' AND NEW.Tipologia <> 'G' AND NEW.Tipologia <> 'P' THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Tipologia dipendente non valida!";
    END IF;
    
    
END $$