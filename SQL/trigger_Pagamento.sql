DROP TRIGGER IF EXISTS trigger_Pagamento;
DELIMITER $$
CREATE TRIGGER trigger_Pagamento
BEFORE INSERT ON pagamento
FOR EACH ROW 
BEGIN
    DECLARE CostoStanze FLOAT DEFAULT 0;
    DECLARE DataPartenza DATE;
    DECLARE DataArrivo DATE;
    DECLARE Anticipo FLOAT DEFAULT 0;
    
    DECLARE CostoEsc FLOAT DEFAULT 0;
    
    DECLARE CostoServizi FLOAT DEFAULT 0;
    
    -- PARTE STANZE
    SET DataPartenza = (
		SELECT DataPartenza
		FROM prenotazione
        WHERE ID = NEW.Prenotazione
	);
    
    SET DataArrivo =(
		SELECT DataArrivo
		FROM prenotazione
        WHERE ID = NEW.Prenotazione
	);
    
    SET Anticipo = (
		SELECT Anticipo
		FROM prenotazione
        WHERE ID = NEW.Prenotazione
	);
    
	-- ricavo il costo totale delle stanze
    SELECT SUM(S.CostoStanza)
    FROM Riferimento R
		 INNER JOIN
         Stanza S ON NumStanza = Stanza
	WHERE R.Prenotazione = NEW.Prenotazione
	INTO CostoStanze;
    
    
    -- PARTE ESCURSIONI    
	SELECT SUM(E.Costo)
    FROM associare A
		 INNER JOIN
         escursione E ON E.Nome = A.Escursione
	WHERE A.Prenotazione = NEW.Prenotazione
    INTO CostoEsc;
    
    
    -- PARTE SERVIZI AGGIUNTIVI

    SELECT SUM(S.CostoUnitario*(hour(TIMEDIFF(SA.TimeFine, SA.TimeInizio))))
    FROM servizioaggiuntivo SA
		 INNER JOIN
         servizio S ON S.Nome = SA.Servizio
	WHERE SA.Prenotazione = NEW.Prenotazione
    INTO CostoServizi;
    
    
    
    -- inserimento dell'importo del pagamento
    SET NEW.Importo = CostoStanze * (DATEDIFF(DataPartenza, DataArrivo)) 
						+ CostoEsc + CostoServizi
                        - Anticipo;

    
END $$





