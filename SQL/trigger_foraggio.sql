DROP TRIGGER IF EXISTS triggerProteine_Glucidi_Fibre_KCal;
DELIMITER $$
CREATE TRIGGER triggerProteine_Glucidi_Fibre_KCal BEFORE INSERT ON foraggio
FOR EACH ROW 
BEGIN
    DECLARE pesoGrammi float default 0;
    DECLARE pesoPiante float default 0;
    DECLARE pesoCereali float default 0;
    DECLARE pesoFrutta float default 0;
    DECLARE proteine float default 0;
    DECLARE glucidi float default 0;
    DECLARE fibre float default 0;

	-- portiamo il peso da kili in grammi
	SET pesoGrammi = NEW.Peso * 1000;
    
    -- calcolo peso dei singoli componenti
    SET pesoPiante = pesoGrammi * NEW.Piante / 100;
    SET pesoCereali = pesoGrammi * NEW.Cereali / 100;
    SET pesoFrutta = pesoGrammi * NEW.Frutta / 100;
    
    -- calcola e inserisce nel record la quantità di proteine, glucidi e fibre presenti
    SET proteine = (pesoCereali * 11.5 ) + (pesoPiante * 2.7 ) + (pesoFrutta * 1.2 );
	SET glucidi = (pesoCereali * 75 ) + (pesoPiante * 3.2 ) + (pesoFrutta * 16 );
	SET fibre = (pesoCereali * 2.5 ) + (pesoPiante * 3 ) + (pesoFrutta * 2.8 );
	
    SET NEW.Proteine = proteine;
    SET NEW.Glucidi = glucidi;
    SET NEW.Fibre = fibre;
    
    -- calcolo delle KCal totali
    SET NEW.KCal = ((proteine * 4.0) + (glucidi * 3.8) + (fibre * 2.0))/ 1000;

END $$