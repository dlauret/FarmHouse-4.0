-- trigger per orari escursioni
DROP TRIGGER IF EXISTS check_orariEscursione;
DELIMITER $$
CREATE TRIGGER check_orariEscursione BEFORE INSERT ON escursione
FOR EACH ROW 
BEGIN

   IF NEW.OraFine < NEW.OraInizio THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Inserimento orari non valido!";
    END IF;
    
    
    IF NEW.GiornoSettimana <> 'LU' AND NEW.GiornoSettimana <> 'MA' AND NEW.GiornoSettimana <> 'ME' 
	   AND NEW.GiornoSettimana <> 'GI' AND NEW.GiornoSettimana <> 'VE' 
       AND NEW.GiornoSettimana <> 'SA' AND NEW.GiornoSettimana <> 'DO' THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Giorno settimana non valido!";
    END IF;
END $$