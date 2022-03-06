-- trigger per orari escursioni
DROP TRIGGER IF EXISTS check_recensione;
DELIMITER $$
CREATE TRIGGER check_recensione BEFORE INSERT ON recensione
FOR EACH ROW 
BEGIN

   IF NEW.Gradimento < 1 OR NEW.Gradimento > 10 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Inserimento Gradimento non valido!";
    END IF;
    
	 IF NEW.Qualita < 1 OR NEW.Qualita > 10 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Inserimento Qualita non valido!";
    END IF;
    
    IF NEW.Gusto < 1 OR NEW.Gusto > 10 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Inserimento Gusto non valido!";
    END IF;
    
END $$