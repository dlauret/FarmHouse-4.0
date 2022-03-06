-- trigger per verificare il tipo di letto
DROP TRIGGER IF EXISTS check_typeLetto;
DELIMITER $$
CREATE TRIGGER check_typeLetto BEFORE INSERT ON letto
FOR EACH ROW 
BEGIN
	
   IF NEW.TipoLetto <> 'S' AND NEW.TipoLetto <> 'M' THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Tipologia letto non valida!";
    END IF;
    
END $$