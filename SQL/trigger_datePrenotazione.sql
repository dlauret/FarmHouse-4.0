-- trigger per verificare le date
DROP TRIGGER IF EXISTS check_datePrenotazione;
DELIMITER $$
CREATE TRIGGER check_datePrenotazione BEFORE INSERT ON prenotazione
FOR EACH ROW 
BEGIN
	
   IF NEW.DataPartenza < NEW.DataArrivo THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Inserimento date non valido!";
    END IF;
    
END $$