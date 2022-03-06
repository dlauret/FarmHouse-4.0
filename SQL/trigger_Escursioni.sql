DROP TRIGGER IF EXISTS trigger_Escursioni;
DELIMITER $$
CREATE TRIGGER trigger_Escursioni BEFORE INSERT ON associare
FOR EACH ROW 
BEGIN
	IF NEW.DataPrenotazione < CURRENT_DATE + INTERVAL 2 DAY THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = "L'escursione deve essere prenotata con 48 ore di anticipo";
    END IF; 
END $$