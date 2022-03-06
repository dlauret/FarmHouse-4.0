-- trigger sull'inserimento nella tabella pascolo
DROP TRIGGER IF EXISTS trigger_pascolo;
DELIMITER $$
CREATE TRIGGER trigger_pascolo AFTER INSERT ON pascolo
FOR EACH ROW 
BEGIN
	
    DECLARE MediaLongitudiniRecintiZona FLOAT DEFAULT 0; -- X
    DECLARE MediaLatitudiniRecintiZona FLOAT DEFAULT 0; -- Y

	-- inserimento dentro la tabella 'andare' la coppia:
    -- codice pascolo appena aggiunto e animali appartenenti a quel locale
	INSERT INTO andare
		SELECT A.Codice, NEW.Codice
        FROM animale A
        WHERE A.CodiceLocale = NEW.Locale;
        

   -- solo di un punto perchè tanto l'altro punto è ridondante nella somma
    SELECT	AVG(X1), AVG(Y1)
    FROM	recinzione R
    WHERE	R.NomeZona = NEW.NomeZona
    INTO	MediaLongitudiniRecintiZona, MediaLatitudiniRecintiZona;
    
     
    INSERT INTO gps(Longitudine, Latitudine, Time, Animale)
		SELECT	(MediaLongitudiniRecintiZona + RAND() * (-2) + RAND() * (2)), -- con una variazione di +- 2
				(MediaLatitudiniRecintiZona + RAND() * (-2) + RAND() * (2)), -- con una variazione di +- 2
                current_timestamp(),
				A.Codice
        FROM 	animale A
        WHERE 	A.CodiceLocale = NEW.Locale;

END $$