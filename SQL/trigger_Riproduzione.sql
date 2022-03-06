DROP TRIGGER IF EXISTS trigger_Riproduzione;
DELIMITER $$
CREATE TRIGGER trigger_Riproduzione AFTER INSERT ON riproduzione
FOR EACH ROW 
BEGIN
    DECLARE randVeterinario int default 0;    
    
    IF NEW.Stato = "Successo" THEN
			-- Scelta casuale del veterinario
			SELECT ROUND(RAND() * (SELECT COUNT(*) FROM veterinario))
			INTO randVeterinario;    
			
            -- creazione scheda gestazione animale
			INSERT INTO schedadigestazione
            VALUES (NEW.Codice, randVeterinario);
            
            -- Aggiunta di un intervento di controllo programmato
            INSERT INTO interventodicontrollo (DataProgrammata, DataControllo, Stato, Esito, Veterinario, CodiceRiproduzione, Terapia)
            VALUES (CURRENT_DATE + INTERVAL 3 MONTH, null, "Programmato", null, null, NEW.Codice, null);
    END IF;
END $$