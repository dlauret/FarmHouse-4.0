/*
INSERT INTO agriturismo (Nome, Citta, Indirizzo)
VALUES	('A1', 'CT', 'Via1'),
		('A2', 'SR', 'Via2'); 


INSERT INTO gps (Longitudine, Latitudine, Time)
VALUES	(0, 0, current_date()),
		(0, 0, '2019-01-01');


INSERT INTO specie (Nome)
VALUES 	('Bovina'),
		('Ovina'),
        ('Caprina');
        


INSERT INTO fornitore (PartitaIVA, Nome, Indirizzo, RagioneSociale)
VALUES	(01234567891, 'Alfio', 'via ciao 13', 'AMNK3SO22SA'),
		(01234567892, 'Felice', 'via ekso 23', 'OIANED0A2SK');



INSERT INTO stalla (CodiceAgriturismo)
VALUES 	(1),
		(1);
        
*/

INSERT INTO allestimento values(); -- FUNZIONA

-- FARE TRIGGER ATTRIBUTO NUMMASSIMO, creare trigger per allestimento (before insert --> insert into allestimento values())
INSERT INTO locale (PtCardinaleFinestra, TipoPavimento, Altezza, Larghezza, Lunghezza, CodiceStalla, Specie, Allestimento)
VALUES ('N','aaaa', 3.5, 20, 17, 1, 'Bovino', 1)






