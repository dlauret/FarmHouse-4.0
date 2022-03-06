
-- ================ AREA PRODUZIONE =========================

DROP TABLE IF EXISTS `Silos`;
CREATE TABLE `Silos` (
  `Codice` int auto_increment NOT NULL,
  `Marca`  varchar(50) NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(IndicatoreSoggettivo) references IndicatoriSoggettivi(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `StatoSilos`;
CREATE TABLE `StatoSilos` (
  `Codice` int auto_increment NOT NULL,
  `Silos` int NOT NULL,
  `Capacita`  int NOT NULL,
  `LivRiempimento` float NOT NULL,
  `pH` int NOT NULL,					-- ===========================================
  `Densita` float NOT NULL,
  `Glucosio` float NOT NULL,
  `Caseina` float NOT NULL,
  `Lattoalbumina` float NOT NULL,
  `Temperatura` float NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(IndicatoreSoggettivo) references IndicatoriSoggettivi(Codice),
  foreign key(Silos) references Silos(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `ParametroIdeale`;
CREATE TABLE `ParametroIdeale` (
  `Nome` varchar(50) NOT NULL,
  PRIMARY KEY (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `ProdottoCaseario`;
CREATE TABLE `ProdottoCaseario` (
  `Nome` varchar(50) NOT NULL,
  `ZonaOrigine` varchar(50) NOT NULL,
  `Tipo` varchar(50) NOT NULL,
  `GradoDeperibilita` float NOT NULL,
  `Costo` float NOT NULL,
  PRIMARY KEY (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `UnitaProdotto`;
CREATE TABLE `UnitaProdotto` (
  `Codice` int auto_increment NOT NULL,
  `Peso` float,
  `ScaffaleCantina` int,
  `ScaffaleMagazzino` int,
  `DataInizio` Date NOT NULL,
  `ProdottoCaseario` varchar(50) NOT NULL,
  `DataInizioStagionatura` date,
  `Lotto` int not null,
  `Ordine` int,
  PRIMARY KEY (`Codice`),
  foreign key(ScaffaleCantina) references ScaffaleCantina(Codice),
  foreign key(ScaffaleMagazzino) references ScaffaleMagazzino(Codice),
  foreign key(ProdottoCaseario) references ProdottoCaseario(Nome),
  foreign key(Lotto) references Lotto(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `ScaffaleCantina`;
CREATE TABLE `ScaffaleCantina` (
  `Codice` int auto_increment NOT NULL,
  `CapienzaMax`int NOT NULL,
  `Cantina` int NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(Cantina) references Cantina(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `ScaffaleMagazzino`;
CREATE TABLE `ScaffaleMagazzino` (
  `Codice` int auto_increment NOT NULL,
  `CapienzaMax`int NOT NULL,
  `Magazzino` int NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(Magazzino) references Magazzino(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Cantina`;
CREATE TABLE `Cantina` (
  `Codice` int auto_increment NOT NULL,
  `Agriturismo` int NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(Agriturismo) references Agriturismo(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Magazzino`;
CREATE TABLE `Magazzino` (
  `Codice` int auto_increment NOT NULL,
  `Agriturismo` int NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(Agriturismo) references Agriturismo(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `StatoCantina`;
CREATE TABLE `StatoCantina` (
  `Time` timestamp NOT NULL,
  `Cantina` int NOT NULL,
  `Temperatura` float NOT NULL,
  `Umidiita` float NOT NULL,
  PRIMARY KEY (`Time`, `Cantina`),
  foreign key(Cantina) references Cantina(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Lotto`;
CREATE TABLE `Lotto` (
  `Codice` int auto_increment NOT NULL,
  `Data` date NOT NULL,
  `Durata` float NOT NULL,
  `DataScadenza` date NOT NULL,
  `Laboratorio` int NOT NULL,
  `Dipendente` int NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(Laboratorio) references Laboratorio(Codice),
  foreign key(Dipendente) references Dipendente(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `FaseLotto`;
CREATE TABLE `FaseLotto` (
  `Lotto` int NOT NULL,
  `NumFase` int NOT NULL,
  `Durata` float NOT NULL,
  `Temperatura` float NOT NULL,
  PRIMARY KEY (`Lotto`, `NumFase`),
  foreign key(Lotto) references Lotto(Codice),
  foreign key(Dipendente) references Dipendente(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Parametro`;
CREATE TABLE `Parametro` (
  `Nome` varchar(50) NOT NULL,
  PRIMARY KEY (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Mungitrice`;
CREATE TABLE `Mungitrice` (
  `Codice` int auto_increment NOT NULL,
  `Modello` varchar(50) NOT NULL,
  `Marca` varchar(50) NOT NULL,
  `GPS` int NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(GPS) references GPS(ID),
  foreign key(NumFase) references FaseLotto(NumFase)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Mungitura`;
CREATE TABLE `Mungitura` (
  `Mungitrice` int NOT NULL,
  `Time` timestamp NOT NULL,
  PRIMARY KEY (`Mungitrice`, `Time`),
  foreign key(Mungitrice) references Mungitrice(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Latte`;
CREATE TABLE `Latte` (
  `Mungitrice` int NOT NULL,
  `Time` timestamp NOT NULL,
  `Animale` int NOT NULL,
  `pH` float NOT NULL,
  `Densita` float NOT NULL,
  `Glucosio` float NOT NULL,
  `Caseina` float NOT NULL,
  `Lattoalbumina` float NOT NULL,
  `Temperatura` float NOT NULL,
  `StatoSilos` int NOT NULL,
  PRIMARY KEY (`Mungitrice`, `Time`),
  foreign key(Mungitrice) references Mungitura(Mungitrice),
  foreign key(Time) references Mungitura(Codice),
  foreign key(StatoSilos) references StatoSilos(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Ricetta`;
CREATE TABLE `Ricetta` (
  `Prodotto` varchar(50) NOT NULL,
  `Descrizione` varchar(50) NOT NULL,
  `DataStagiontura` DATE NOT NULL,
  PRIMARY KEY (`Prodotto`),
  foreign key(Prodotto) references ProdottoCaseario(Nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Fase`;
CREATE TABLE `Fase` (
  `Prodotto` varchar(50) NOT NULL,
  `IDFase` int NOT NULL,
  `Durata` float NOT NULL,
  PRIMARY KEY (`Prodotto`, `IDFase`),
  foreign key(Prodotto) references Ricetta(Prodotto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Laboratorio`;
CREATE TABLE `Laboratorio` (
  `Codice` int auto_increment NOT NULL,
  `Tipo` varchar(50) NOT NULL,
  `Agriturismo` int NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(Agriturismo) references Agriturismo(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Prelievo`;
CREATE TABLE `Prelievo` (
  `Lotto` int NOT NULL,
  `StatoSilos` int NOT NULL,
  `Quantita` float NOT NULL,
  PRIMARY KEY (`Lotto`, `StatoSilos`),
  foreign key(StatoSilos) references StatoSilos(Codice),
  foreign key(Lotto) references Lotto(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Avere`;
CREATE TABLE `Avere` (
  `Lotto` int NOT NULL,
  `NumFase` int NOT NULL,
  `Parametro` float NOT NULL,
  `Quantita` float NOT NULL,
  PRIMARY KEY (`Lotto`, `StatoSilos`),
  foreign key(Parametro) references Parametro(Nome),
  foreign key(NumFase) references FaseLotto(NumFase),
  foreign key(Lotto) references FaseLotto(Lotto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Composta`;
CREATE TABLE `Composta` (
  `Prodotto` int NOT NULL,
  `IDFase` int NOT NULL,
  `Parametro` float NOT NULL,
  `Quantita` float NOT NULL,
  PRIMARY KEY (`Prodotto`, `IDFase`, `Parametro`),
  foreign key(Parametro) references ParametroIdeale(Nome),
  foreign key(IDFase) references Fase(IDFase),
  foreign key(Prodotto) references Fase(Prodotto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;





DROP TABLE IF EXISTS `Impiegato`;
CREATE TABLE `Impiegato` (
  `Lotto` int NOT NULL,
  `Dipendente` int NOT NULL,
  PRIMARY KEY (`Lotto`, `Dipendente`),
  foreign key(Lotto) references Lotto(Codice),
  foreign key(Dipendente) references Dipendente(Codice),
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

