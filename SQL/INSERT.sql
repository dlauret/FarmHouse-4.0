/*
INSERT INTO fornitore
VALUES
		("987654321", "Cow Shop", "Via Roma 32", "Cow Shop SRL");

INSERT INTO agriturismo (Nome, Citta, Indirizzo)
VALUES("FarmHouse", "Catania", "Largo Lucio Lazzarino 1"), ("Agriturismo Toscana", "Pisa", "Via XXIV Maggio 24");


INSERT INTO gps (Longitudine, Latitudine, Time)		# Inserirne più di uno
VALUE("0","0", current_timestamp()); 

INSERT INTO specie
VALUES("Bovini"), ("Ovini"), ("Caprini");

INSERT INTO stalla (CodiceAgriturismo)
VALUES(1), (1), (2);

INSERT INTO allestimento
VALUES (), (), ();

INSERT INTO locale (PtCardinaleFinestra, TipoPavimento, Altezza, Larghezza, Lunghezza, CodiceStalla, Specie, NumMassimo, Allestimento)
VALUES ("N", "Forato", 3, 8, 15, 1, "Bovini",0, 1),("E", "Pieno", 3, 5, 12, 1, "Caprini", 0,2), ("S", "Pieno", 3, 8, 12, 1, "Ovini",0, 3);

INSERT INTO locale (PtCardinaleFinestra, TipoPavimento, Altezza, Larghezza, Lunghezza, CodiceStalla, Specie, NumMassimo, Allestimento)
VALUES ("O", "Pieno", 3, 7, 16, 2, "Bovini", 0, 4), ("S", "Forato", 3, 5, 14, 2, "Caprini",0, 5), ("N", "Pieno", 3, 8, 15, 2, "Ovini",0, 6);

INSERT INTO locale (PtCardinaleFinestra, TipoPavimento, Altezza, Larghezza, Lunghezza, CodiceStalla, Specie, NumMassimo, Allestimento)
VALUES ("S", "Forato", 3, 8, 16, 3, "Bovini", 0,7), ("E", "Pieno", 3, 9, 12, 3, "Caprini", 0,8), ("O", "Pieno", 3, 9, 11, 3, "Ovini",0, 9);

INSERT INTO veterinario (Nome, Cognome, Parcella)
VALUES ("Mario", "Rossi", 100), ("Pippo", "Verdi", 90), ("Pluto", "Celesti", 95);

INSERT INTO patologia
VALUES ("Respirazione"), ("Infezione"), ("Riproduzione");

INSERT INTO farmaco	
VALUES ("Curofen", "Respirazione", "Fenbendazolo"), ("Melovine", "Riproduzione","Melatonina"), ("Tylosine Ceva", "Infezione", "tilosina");

INSERT INTO animale (Famiglia, DataNascita, Sesso, Specie, Razza, Altezza, Peso, DataArrivo, DataAcquisto, CodiceLocale, Fornitore, GPS)
VALUES ("Bovinae", '2015-08-10', 'F', "Bovini", "Mezzalina", 1.50, 900, '2018-11-01', null, 1, null, 1), ("Bovinae", '2003-10-10', 'F', "Bovini", "Mezzalina", 1.40, 700, '2018-03-01',NULL, 1,null, 2), 
		("Caprinae", '2016-01-03', 'F', "Caprini", "Capra Maltese", 0.90, 90, NULL, '2019-01-01', 2, 123456789, 3), ("Caprinae", '2020-01-03', 'M', "Caprini", "Girgentana", 1.00, 95, '2019-05-01',null,  2, null, 4),
        ("Bovinae", '2019-01-07', 'M', "Ovini", "Comisana", 0.80, 80, NULL, '2019-01-01', 3, 987654321, 5), ("Bovinae", '2019-01-07', 'F', "Ovini", "Cominsana", 0.75, 75, '2020-01-08', null, 3, null, 6);

INSERT into abbeveratoio (Allestimento)
VALUES (1), (1), (2), (2), (3), (3), (4), (4), (5), (5), (6), (6), (7), (7), (8), (8), (9), (9);

INSERT INTO zona
VALUES (1,"Ovini1"), (1,"Ovini2"), (1,"Bovini1"), (1,"Bovini2"), (1,"Caprini1"), (1,"Caprini2");

INSERT INTO itinerario
VALUES (), (), (), (), ();

INSERT INTO area
VALUES (1, '10:00:00', "Laboratori", 1, 1), (2, '12:00:00', "Laboratori", 1, 1), (3, '10:30:00', "Cantine", 2, 1), (4, '15:00:00', "Cantine", 2, 1),
		(2, '13:00:00', "Pascolo", 1, 1), (3, '13:00:00', "Laboratori", 1, 1);

INSERT INTO cantina (agriturismo)
VALUES (1), (1), (1);

INSERT INTO magazzino (agriturismo)
VALUES (1), (1), (1);

INSERT INTO condizionamentoilluminazione (tipo, allestimento)
VALUES ('C', 1), ('I',1), ('C', 2), ('I',2), ('C', 3), ('I',3), ('C', 4), ('I',4), ('C', 5), ('I',5), ('C', 6), ('I',6), ('C', 7), ('I',7), ('C', 8), ('I',8), ('C', 9), ('I',9); 

INSERT INTO gruppo
VALUES (), (), ();

INSERT INTO dipendente (Nome, Cognome, DataNascita, Tipologia, Gruppo, CodiceAgriturismo)
VALUES ("Carmelo", "TuttoFare", "1990-10-10", 'P', 1, 1), ("Vincenzo", "Rossi", "1980-07-02", 'L', null, 1),
		("Paolo", "Grigi", "2000-12-1",'P', 1, 1), ("Mario", "Gialli", "1992-03-11", 'L', null, 1),
        ("Marco", "Polo", "1994-02-16", 'G', null, 1), ("Giulia", "Pippo", "1998-02-18", 'G', null, 1),
        ("Francesco", "Pluto", "2001-08-12", 'P', NULL, 1);

INSERT INTO escursione
VALUES ("Escursione1", 30, 1, '11:00:00', '10:00:00', 'LU', 5), ("Escursione2", 50, 2, '14:00:00', '11:00:00', 'MA', 6),
		("Escursione3", 50, 3, '13:00:00', '9:00:00', 'SA', 5);

INSERT INTO foraggio (Peso, KCal, Frutta, Cereali, Piante, Proteine, Glucidi, Fibre, Tipo)
VALUES (52, 0, 15, 15, 70, 0, 0, 0, 'F'), (45, 0, 32, 28, 40, 0, 0, 0, 'F'), (55, 0, 5, 75, 20, 0, 0, 0, 'C');

INSERT INTO hub (Citta, Indirizzo)
VALUES ("Roma", "Largo Venturini 1"), ("Milano", "Viale Vitorio Veneto 12"), ("Pisa", "Via Ugo Rindi 32"), ("Napoli", "Via Lucchese 65"), ("Messina", "Via Sicilia 34"),
		("Firenze", "Piazza Duomo 78"), ("Verona", "Via dei Mille 1000"), ("Venezia", "Via Martiri 66"), ("Palermo", "Via della Sapienza 45");

INSERT INTO macchinario
VALUES (), (), (), ();

INSERT INTO mangiatoia (allestimento)
VALUES (1), (1), (2), (2), (3), (3), (4), (4), (5), (5), (6), (6),(7), (7), (8), (8), (9), (9); 

INSERT INTO mungitrice (Modello, Marca, GPS)
VALUES ("ABC123", "Philips", 7), ("DEF432", "Nec", 8), ("XYZ879", "Philips", 9);

INSERT INTO orario
VALUES ('M'), ('P'), ('S');

INSERT INTO parentela
VALUES (7,8);
*/
INSERT INTO prodottocaseario
VALUES ("Scamorza", "Ragusa", "Pasta molle", 6.2, 4), ("Grana Padano", "Bologna", "Pasta dura", 7, 10), ("Mozzarella", "Napoli", "Pasta molle", 5.1, 3.5),
		("Pecorino", "Roma", "Pasta dura", 6.8, 4.2);

INSERT INTO ricetta
VALUES ("Scamorza", "La scamorza è un formaggio di origine meridionale, preparato con latte vaccino e di capra.", '2019-01-01'),
	   ("Grana Padano", "Il Grana Padano DOP è un formaggio vaccino, semigrasso, a pasta dura, sia da tavola che da grattugia.", "2020-01-02"),
       ("Mozzarella", "Latticinio fresco, tipico della Campania (doc o igp quello di alcune zone), prodotto con latte di bufala in piccole forme rotondeggianti oppure in trecce; ", "2019-12-04"),
       ("Pecorino", "Il Pecorino Romano è un formaggio a pasta dura, cotta, prodotto con latte fresco di pecora.", '2020-01-11');

INSERT INTO scaffalecantina (CapienzaMax, Cantina)
VALUES (20, 1), (20,1), (15,2), (15,2), (30,1), (30,1);

INSERT INTO scaffalemagazzino (CapienzaMax, Magazzino)
VALUES (50, 1), (50,1), (30,2), (30,2), (60,1), (60,1);

INSERT INTO sensore (Temperatura, Umidita, LivAzoto, LivMetano, LivSporco, Locale)
VALUES (18.5, 2.3, 3.5, 1.4, 6.8, 1), (19, 1.9, 2.3, 3.4, 4.5, 2), (17.5, 3.1, 1.9, 2.2, 3.2, 3);

INSERT INTO servizio 
VALUES ("Piscina", 10), ("Idromassaggio", 15), ("Centro Benessere", 18);

INSERT INTO silos (Marca)
VALUES ("FIAC"), ("CEPI"), ("CO.ME.I");

INSERT INTO stanza (CostoStanza, Tipo)
VALUES (80, "Suite"), (60, "Suite"), ("60", "Suite"), ("35", "Semplice"), ("40", "Semplice"), ("40", "Semplice"), ("40", "Semplice");

INSERT INTO letto (TipoLetto, Stanza)
VALUES ('M', 1), ('S', 1), ('M', 2), ('S',2), ('S',2),  ('S', 3),  ('S', 4),  ('S', 5),  ('S', 6);


