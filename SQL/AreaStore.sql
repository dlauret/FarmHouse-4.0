-- ================= AREA STORE ===================

DROP TABLE IF EXISTS `Account`;
CREATE TABLE `Account` (
  `NomeUtente` varchar(50) NOT NULL,
  `Password` varchar(50) NOT NULL,			
  `DataIscrizione` date NOT NULL,
  `Domanda` varchar(50) NOT NULL,
  `Risposta` varchar(50) NOT NULL,
  PRIMARY KEY (`NomeUtente`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Ordine`;
CREATE TABLE `Ordine` (
  `Codice` int auto_increment NOT NULL,
  `Stato` varchar(50) NOT NULL,			
  `Time` timestamp NOT NULL,
  `Account` varchar(50) NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(Account) references Account(NomeUtente)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Reso`;
CREATE TABLE `Reso` (
  `Codice` int auto_increment NOT NULL,
  `DataReso` date NOT NULL,			
  `UnitaProdotto` int NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(UnitaProdotto) references UnitaProdotto(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Recensione`;
CREATE TABLE `Recensione` (
  `Codice` int auto_increment NOT NULL,
  `Testo` varchar(100) NOT NULL,			
  `Conservazione` int NOT NULL,
  `Gradimento` int NOT NULL,
  `Qualita` int NOT NULL,
  `Gusto` varchar(50) NOT NULL,
  `UnitaProdotto` int NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(UnitaProdotto) references UnitaProdotto(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Spedizione`;
CREATE TABLE `Spedizione` (
  `Codice` int auto_increment NOT NULL,
  `Stato` varchar(50) NOT NULL,			
  PRIMARY KEY (`Codice`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `ParametriQualita`;
CREATE TABLE `ParametriQualita` (
  `Nome` varchar(50) NOT NULL,			
  PRIMARY KEY (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `Hub`;
CREATE TABLE `Hub` (
  `Codice` int auto_increment NOT NULL,
  `Citta` varchar(50) NOT NULL,			
  `Indirizzo` varchar(50) NOT NULL,			
  PRIMARY KEY (`Codice`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Trasporto`;
CREATE TABLE `Trasporto` (
  `UnitaProdotto` int NOT NULL,
  `Spedizione` int NOT NULL,			
  `DataPrevista` DATE NOT NULL,			
  `DataEffettiva` DATE NOT NULL,			
  PRIMARY KEY (`UnitaProdotto`, `Spedizione`),
  foreign key(UnitaProdotto) references UnitaProdotto(Codice),
  foreign key(Spedizione) references Spedizione(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;





DROP TABLE IF EXISTS `Controllo`;
CREATE TABLE `Controllo` (
  `Reso` int NOT NULL,
  `ParametroQualita` varchar(50) NOT NULL,			
  `Valutazione` int NOT NULL,		
  PRIMARY KEY (`Reso`, `ParametroQualita`),
  foreign key(Reso) references Reso(Codice),
  foreign key(ParametroQualita) references ParametroQualita(Nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Prevedere`;
CREATE TABLE `Prevedere` (
  `Spedizione` int NOT NULL,
  `Hub` int NOT NULL,			
  `Time` timestamp NOT NULL,		
  PRIMARY KEY (`Spedizione`, `Hub`),
  foreign key(Spedizione) references Spedizione(Codice),
  foreign key(Hub) references Hub(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Selezione`;
CREATE TABLE `Selezione` (
  `ProdottoCaseario` int NOT NULL,
  `Ordine` int NOT NULL,			
  `Quantita` int NOT NULL,		
  PRIMARY KEY (`ProdottoCaseario`, `Ordine`),
  foreign key(ProdottoCaseario) references ProdottoCaseario(Nome),
  foreign key(Ordine) references Ordine(COdice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;












