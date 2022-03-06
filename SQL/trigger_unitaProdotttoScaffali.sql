-- trigger inserimento unita prodotti negli scaffali
DROP TRIGGER IF EXISTS InserimentoScaffali_Cantina_Magazzino;
DELIMITER $$
CREATE TRIGGER InserimentoScaffali_Cantina_Magazzino
BEFORE INSERT ON unitaprodotto
FOR EACH ROW 
BEGIN
	DECLARE isStagionatura VARCHAR(1) DEFAULT '';
    
    SET isStagionatura = ( -- se vale M --> Magazzino, C --> Cantina
		SELECT	IF(R.DataStagionatura = null, M, C)
        FROM	ricetta R
        WHERE	R.Prodotto = NEW.ProdottoCaseario
		);
        
	
    IF isStagionatura = 'M' THEN
		SET NEW.ScaffaleMagazzino = (
				SELECT	S.Codice
                FROM 	unitaprodotto U
						RIGHT OUTER JOIN
                        scaffalemagazzino S ON U.ScaffaleMagazzino = S.Codice
				WHERE	( -- se il lotto è uguale o non ci sono prodotti
							U.Lotto = NEW.Lotto
							OR
							(
								SELECT	COUNT(*) 
								FROM 	scaffalemagazzino S2
										INNER JOIN
										unitaprodotto U2 ON U2.ScaffaleMagazzino = S2.Codice 
								WHERE	S2.Codice = S.Codice
							) = 0
						) 
                        AND -- e se il numero prodotti nello scaffale è < di CapienzaMax
                        (
								SELECT	IF(COUNT(*) < S3.CapienzaMax,1,0)
								FROM 	scaffalemagazzino S3
										INNER JOIN
										unitaprodotto U3 ON U3.ScaffaleMagazzino = S3.Codice 
								WHERE	S3.Codice = S.Codice
						)
					LIMIT 1
            );
	ELSE -- altrimenti sarà da inserire nella cantina
		SET NEW.ScaffaleCantina = (
				SELECT	U.ScaffaleCantina
                FROM 	unitaprodotto U 
						RIGHT OUTER JOIN
                        ScaffaleCantina S ON U.ScaffaleCantina = S.Codice
				WHERE	( -- se il lotto è uguale o non ci sono prodotti
							U.Lotto = NEW.Lotto
							OR
							(
								SELECT	COUNT(*) 
								FROM 	ScaffaleCantina S2
										INNER JOIN
										unitaprodotto U2 ON U2.ScaffaleCantina = S2.Codice 
								WHERE	S2.Codice = S.Codice
							) = 0
						) 
                        AND -- e se il numero prodotti nello scaffale è < di CapienzaMax
                        (
								SELECT	IF(COUNT(*) < S3.CapienzaMax,1,0)
								FROM 	ScaffaleCantina S3
										INNER JOIN
										unitaprodotto U3 ON U3.ScaffaleCantina = S3.Codice 
								WHERE	S3.Codice = S.Codice
						)
				LIMIT 1

            );
            
            -- settiamo la datainizio della stagionatura
            SET NEW.DataInizio = current_date();
	
	END IF;
END $$
