DROP TRIGGER IF EXISTS trigger_Reso;
DELIMITER $$
CREATE TRIGGER trigger_Reso BEFORE INSERT ON Reso
FOR EACH ROW 
BEGIN
	DECLARE dataConsegna date;
   
    SELECT DataEffettiva INTO dataConsegna
    FROM trasporto
    WHERE UnitaProdotto = NEW.UnitaProdotto;
       
    IF dataConsegna + INTERVAL 2 DAY < NEW.DataReso THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = "Attenzione, il reso deve essere effettuato entro 48 ore dalla consegna!";        
	END IF;
END $$