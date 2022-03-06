DROP TRIGGER IF EXISTS triggerDecrementoSulSilos;
DELIMITER $$
CREATE TRIGGER triggerDescrementoSulSilos AFTER INSERT ON prelievo
FOR EACH ROW 
BEGIN

	-- Aggiorna la variabile LivRiempimento del silos target
	UPDATE statosilos
	SET LivRiempimento = IF(LivRiempimento - NEW.Quantita < 0, 0, LivRiempimento - NEW.Quantita)
	WHERE NEW.StatoSilos = Codice;
        
END $$