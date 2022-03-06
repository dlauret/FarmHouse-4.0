DROP TRIGGER IF EXISTS trigger_Acquisti;
DELIMITER $$
CREATE TRIGGER trigger_Acquisti BEFORE INSERT ON selezione
FOR EACH ROW 
BEGIN
	DECLARE quantiDisponibili INTEGER DEFAULT 0;
    DECLARE stato VARCHAR(50) DEFAULT "";
    DECLARE quantita INT DEFAULT 0;
    DECLARE acquistato INT DEFAULT 0;
    DECLARE codAccount INT DEFAULT 0;
    DECLARE countPendeze INT DEFAULT 0;
    
    SET quantita = NEW.Quantita;


	-- conta quante unità sono disponibili
	SELECT COUNT(*) INTO quantiDisponibili
    FROM UnitaProdotto
    WHERE ProdottoCaseario = NEW.ProdottoCaseario
			AND Ordine IS NULL;
    
    -- seleziona l'acoount che ha effettuato l'ordine
    SELECT O.Account 
    FROM Ordine O
	WHERE O.Codice = NEW.Ordine
    INTO codAccount;
    
    -- se la quantità voluta è maggiore di quella disponibile,
	-- lo stato sarà in 'pendente'
    IF quantita > quantiDisponibili THEN
		SELECT COUNT(*) INTO countPendenze
        FROM Ordine O
        WHERE O.Account = codAccount
				AND
			 O.stato = "Pendente";
          
		IF countPendenze = 0 THEN 
			SET stato = "Pendente";
		ELSE
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = "Attenzione, non puoi avere più di un ordine nello stato pendente!";
        END IF;
	ELSE 
		SET stato = "Processazione";
        
        
        WHILE quantita <> 0 DO
        
			-- Selezioniamo il prodotto da vendere
			SELECT Codice INTO Acquistato
            FROM UnitaProdotto
            WHERE ProdottoCaseario = NEW.ProdottoCaseario
					AND Ordine IS NULL
            LIMIT 1;
            
            -- immettimamo nel campo Ordine del prodotto venduto il codice dell'ordine
            UPDATE unitaprodotto
            SET Ordine = NEW.Ordine
            WHERE Codice = Acquistato;
            
			SET quantita = quantita - 1;
        END WHILE;        
        
	END IF;
           	
	UPDATE Ordine O
    SET O.Stato = stato
    WHERE O.Account = codAccount
		AND O.Stato = "Pendente";   
        
END $$