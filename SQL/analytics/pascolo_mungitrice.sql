/*
1)	Avendo un pascolo target,
		inserimento di una mangiatoia nella parte di zona dove gli animali preferiscono pascolare (come descritto nelle specifiche)
*/

DROP PROCEDURE IF EXISTS analisi_pascolo;
DELIMITER $$
-- passiamo come parametro il prodotto
CREATE PROCEDURE analisi_pascolo (IN _codicePascolo VARCHAR(50))
BEGIN
	
    DECLARE timeInizio_pascolo_target TIMESTAMP DEFAULT NULL;
    DECLARE timeFine_pascolo_target TIMESTAMP DEFAULT NULL;
    DECLARE locale_target INT DEFAULT 0;
    
    DECLARE mungitrice_target INT DEFAULT 0;
    DECLARE long_mungitrice FLOAT DEFAULT 0;
    DECLARE lat_mungitrice FLOAT DEFAULT 0;
    
    -- inseriamo nelle rispettive variabili i dati del pascolo fornito in input
	SELECT	P.TimeInizio, P.TimeFine, Locale
	FROM	pascolo P
    WHERE	P.Codice = _codicePascolo
    INTO 	timeInizio_pascolo_target, timeFine_pascolo_target, locale_target;
		
        
	/*
		raggruppiamo per l'intero (arrotondato) di longitudine e latitudine
		e ne contiamo il numero di ognuno;
        dopo di che prendiamo quelle più numerose
    */

    -- tab. per le longitudini
    DROP TABLE IF EXISTS _gpsTarget_long;
    CREATE TABLE _gpsTarget_long(
		Longitudine INT NOT NULL PRIMARY KEY,
        Numero INT
    );
    
    INSERT INTO _gpsTarget_long
		SELECT	ROUND(G.Longitudine),
				COUNT(*)
        FROM	gps G
				INNER JOIN
                animale A ON G.Animale = A.Codice
        WHERE	G.Time BETWEEN timeInizio_pascolo_target AND timeFine_pascolo_target
				AND
                A.CodiceLocale = locale_target
        GROUP BY ROUND(G.Longitudine);
        
	
	-- tab. per le latitudini
    DROP  TABLE IF EXISTS _gpsTarget_lat;
    CREATE  TABLE _gpsTarget_lat (
		Latitudine INT NOT NULL PRIMARY KEY,
        Numero INT
    );
    
    INSERT INTO _gpsTarget_lat
		SELECT	ROUND(G.Latitudine),
				COUNT(*)
        FROM	gps G
				INNER JOIN
                animale A ON G.Animale = A.Codice
        WHERE	G.Time BETWEEN timeInizio_pascolo_target AND timeFine_pascolo_target
				AND
                A.CodiceLocale = locale_target
        GROUP BY ROUND(G.Latitudine);
        
        
        -- prendiamo come longitudine quella più 'numerosa'
        SET long_mungitrice = (
			SELECT	L.Longitudine
            FROM	_gpsTarget_long L
            WHERE	L.Numero >= ALL (
					SELECT	L2.Numero
                    FROM	_gpsTarget_long L2
                    )
			LIMIT 1
        );
        
        -- prendiamo come latitudine quella più 'numerosa'
        SET lat_mungitrice = (
			SELECT	L.Latitudine
            FROM	_gpsTarget_lat L
            WHERE	L.Numero >= ALL (
					SELECT	L2.Numero
                    FROM	_gpsTarget_lat L2
                    )
			LIMIT 1
        );

        -- prendiamo come mungitrice quella più recentemente immessa nella tabella
        SET mungitrice_target = (
			SELECT	G.Mungitrice
            FROM	gps G
            WHERE	G.Time >= ALL ( -- andiamo a vedere l'ultima sua posizione
					SELECT	G2.Time
                    FROM	gps G2
                    WHERE	G2.Mungitrice = G.Mungitrice
					)
                    AND G.Mungitrice IS NOT NULL
			LIMIT 1
        );
        
        INSERT INTO gps(Longitudine, Latitudine, Time, Animale, Mungitrice)
			VALUES(long_mungitrice, lat_mungitrice, current_timestamp(), null ,mungitrice_target);


		DROP TABLE IF EXISTS _gpsTarget_long;
		DROP TABLE IF EXISTS _gpsTarget_lat;
END $$

 CALL analisi_pascolo(1);
