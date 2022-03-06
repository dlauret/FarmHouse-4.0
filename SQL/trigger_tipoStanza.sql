-- trigger per verificare il tipo di stanza
DROP TRIGGER IF EXISTS check_typeStanza;
DELIMITER $$
CREATE TRIGGER check_typeStanza BEFORE INSERT ON stanza
FOR EACH ROW 
BEGIN
	
   IF NEW.Tipo <> 'Semplice' AND NEW.Tipo <> 'Suite' THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Tipologia stanza non valida!";
    END IF;
    
END $$