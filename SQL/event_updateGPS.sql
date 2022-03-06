-- event update gps
DROP EVENT IF EXISTS event_updateGPS;
DELIMITER $$
CREATE EVENT event_updateGPS
ON SCHEDULE EVERY 30 SECOND
-- STARTS '2020-01-15 15:35:00'
DO
BEGIN
    -- inserimento animali con posizione aggiornata
    INSERT INTO gps(Longitudine, Latitudine, Time, Animale)
    SELECT	G.Longitudine + RAND() * (-1) + RAND() * (1),
            G.Latitudine + RAND() * (-1) + RAND() * (1),
            CURRENT_TIMESTAMP(),
            G.Animale
    FROM	gps G
    WHERE	G.Time >= ALL ( -- andiamo a vedere l'ultima sua posizione
					SELECT	G2.Time
                    FROM	gps G2
                    WHERE	G2.Animale = G.Animale
					)
			AND G.Animale IS NOT NULL
    GROUP BY 
			G.Animale;
END $$