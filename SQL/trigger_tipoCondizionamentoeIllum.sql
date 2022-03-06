-- trigger per la tipologia di condizionamentoilluminazione
DROP TRIGGER IF EXISTS check_typeCondizIllum;
DELIMITER $$
CREATE TRIGGER check_typeCondizIllum BEFORE INSERT ON condizionamentoilluminazione
FOR EACH ROW 
BEGIN
	
    IF NEW.Tipo <> 'I' AND NEW.Tipo <> 'C' THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Tipologia non valida!";
    END IF;
    
END $$