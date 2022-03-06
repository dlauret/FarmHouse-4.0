DROP TRIGGER IF EXISTS triggerInserimentoSulSilos;
DELIMITER $$
CREATE TRIGGER triggerInserimentoSulSilos BEFORE INSERT ON latte
FOR EACH ROW 
BEGIN
    DECLARE silosSimile int default 0;
    
    -- Ricerca del silos target
    SET silosSimile = (
		SELECT	SS.Codice
        FROM	statosilos SS
        WHERE	(SS.LivRiempimento + NEW.Quantita < SS.Capacita)
				AND
                (
					(NEW.pH BETWEEN (SS.pH - SS.pH * 0.2) AND (SS.pH + SS.pH * 0.2))
					AND
					(NEW.Densita BETWEEN (SS.Densita - SS.Densita * 0.2) AND (SS.Densita + SS.Densita * 0.2))
					AND
					(NEW.Glucosio BETWEEN (SS.Glucosio - SS.Glucosio * 0.2) AND (SS.Glucosio + SS.Glucosio * 0.2))
					AND
					(NEW.Caseina BETWEEN (SS.Caseina - SS.Caseina * 0.2) AND (SS.Caseina + SS.Caseina * 0.2))
					AND
					(NEW.Lattoalbumina BETWEEN (SS.Lattoalbumina - SS.Lattoalbumina * 0.2) AND (SS.Lattoalbumina + SS.Lattoalbumina * 0.2))
					AND
					(NEW.Temperatura BETWEEN (SS.Temperatura - SS.Temperatura * 0.2) AND (SS.Temperatura + SS.Temperatura * 0.2))
					OR 
					SS.LivRiempimento = 0
				)
                LIMIT 1
			);
		
	IF silosSimile = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = "Non c'è spazio disponibile nei silos per inserire il latte";
	END IF;
	
	-- Aggiorna la variabile LivRiempimento del silos target
	UPDATE statosilos
	SET LivRiempimento = LivRiempimento + NEW.Quantita
	WHERE Codice = silosSimile;
	
	-- Settaggio dell'attributo StatoSilos, cioè il silos dove il latte è stato inserito
	SET NEW.StatoSilos = silosSimile;
        
END $$