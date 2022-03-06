DROP TRIGGER IF EXISTS trigger_Account;
DELIMITER $$
CREATE TRIGGER trigger_Account AFTER INSERT ON registrato
FOR EACH ROW 
BEGIN
	DECLARE password INTEGER;
    
	SELECT ROUND(RAND() * 1000)
        INTO password;

	INSERT INTO account
    VALUES (CONCAT(NEW.nome,NEW.cognome), password, current_date, null, null);
    
END $$