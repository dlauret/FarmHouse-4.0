-- Controllo sui servizi aggiuntivi se il cliente aveva prenotato una suite
DROP TRIGGER IF EXISTS triggerServizioAggiuntivo;
DELIMITER $$
CREATE TRIGGER triggerServizioAggiuntivo BEFORE INSERT ON servizioaggiuntivo
FOR EACH ROW 
BEGIN
    DECLARE isSuite INT DEFAULT 0;

	-- conta il numero di suite prenotate, se > 0 allora va bene
    SELECT	COUNT(*)
    FROM	riferimento R
			INNER JOIN
            stanza S ON R.Stanza = S.NumStanza
    WHERE	R.Prenotazione = NEW.Prenotazione
			AND S.Tipo = 'Suite'			
    INTO isSuite;
    
    IF isSuite = 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non è possibile aggiungere servizi aggiuntivi!';
    END IF;
    
END $$