-- trigger per verificare il tipo di stanza
DROP TRIGGER IF EXISTS check_statoOrdine;
DELIMITER $$
CREATE TRIGGER check_statoOrdine BEFORE INSERT ON ordine
FOR EACH ROW 
BEGIN
	
   IF NEW.Stato <> 'Pendente' AND NEW.Stato <> 'Processazione' AND NEW.Stato <> 'Evaso'
      AND NEW.Stato <> 'In Preparazione' AND NEW.Stato <> 'Spedito' THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Stato ordine non valido!";
    END IF;
    
END $$