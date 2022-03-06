-- =============== AREA HEALTHCARE ======================


DROP TABLE IF EXISTS `Terapia`;
CREATE TABLE `Terapia` (
  `Codice` int auto_increment NOT NULL,
  `Veterinario` varchar(50) NOT NULL,
  `Animale` int NOT NULL,
  `Data` DATE NOT NULL,
  `DataInizioTerapia` DATE NOT NULL,
  `Durata` int NOT NULL,
  `Posologia` int NOT NULL,
  `Patologia` varchar(50) NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(Patologia) references Patologia(NomePatologia),
  foreign key(Veterinario) references Veterinario(Matricola),
  foreign key(Veterinario) references Visita(Veterinario),
  foreign key(Animale) references Visita(Animale),
  foreign key(Data) references Visita(Data)  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Patologia`;
CREATE TABLE `Patologia` (
  `NomePatologia` varchar(50) NOT NULL,
  PRIMARY KEY (`NomePatologia`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `IndicatoriSoggettivi`;
CREATE TABLE `IndicatoriSoggettivi` (
  `Codice` int auto_increment NOT NULL,
  `Entita` varchar(50) NOT NULL,
  `Tipo` varchar(50) NOT NULL,
  `PtCorpo` varchar(50) NOT NULL,
  `NomeDistrubo` varchar(50) NOT NULL,
  PRIMARY KEY (`Codice`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Orario`;
CREATE TABLE `Orario` (
  `Ora` char(1) DEFAULT 'M' NOT NULL,	-- M = Mattina, P = Pomeriggio, S = Sera
  PRIMARY KEY (`Ora`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Quarantena`;
CREATE TABLE `Quarantena` (
  `Time` timestamp NOT NULL,
  `Animale` int NOT NULL,
  PRIMARY KEY (`Time`, `Animale`),
  foreign key(Animale) references Animale(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `SchedaMedica`;
CREATE TABLE `SchedaMedica` (
  `Time` timestamp NOT NULL,
  `Animale` int NOT NULL,
  PRIMARY KEY (`Time`, `Animale`),
  foreign key(Animale) references Animale(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Farmaco`;
CREATE TABLE `Farmaco` (
  `NomeCommerciale` varchar(50) NOT NULL,
  `Patologia` varchar(50) NOT NULL,
  `PrincipioAttivo` varchar(50) NOT NULL,
  PRIMARY KEY (`NomeCommerciale`, `Patologia`),
  foreign key(Patologia) references Patologia(NomePatologia)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `SchedaTerapia`;
CREATE TABLE `SchedaTerapia` (
  `Farmaco` varchar(50) NOT NULL,
  `Patologia` varchar(50) NOT NULL,
  `DataInizio` DATE NOT NULL,
  `Terapia` int NOT NULL,
  `DataFine` DATE NOT NULL,
  PRIMARY KEY (`NomeCommerciale`, `Patologia`),
  foreign key(Farmaco) references Farmaco(NomeCommerciale),
  foreign key(Patologia) references Farmaco(Patologia),
  foreign key(Terapia) references Terapia(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Indice`;
CREATE TABLE `Indice` (
  `Codice` int auto_increment NOT NULL,
  `Nome` varchar(50) NOT NULL,
  `Valore` float NULL,
  PRIMARY KEY (`Codice`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Visita`;
CREATE TABLE `Visita` (
  `Veterinario` int NOT NULL,
  `Animale` int NOT NULL,
  `Data` DATE NOT NULL,
  PRIMARY KEY (`Veterinario`, `Animale`, `Data`),
  foreign key(Veterinario) references Veterinario(Matricola),
  foreign key(Animale) references Animale(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Dosaggio`;
CREATE TABLE `Dosaggio` (
  `Farmaco` varchar(50) NOT NULL,
  `Patologia` varchar(50) NOT NULL,
  `DataInizio` DATE NOT NULL,
  `Terapia` int NOT NULL,
  `Ora` timestamp NOT NULL,
  `Dose` float NOT NULL,
  PRIMARY KEY (`Farmaco`, `Patologia`, `DataInizio`, `Terapia`, `Ora`),
  foreign key(Farmaco) references SchedaTerapia(Farmaco),
  foreign key(Patologia) references SchedaTerapia(Patologia),
  foreign key(Terapia) references SchedaTerapia(Terapia),
  foreign key(Ora) references Orario(Ora)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Possibilita`;
CREATE TABLE `Possibilita` (
  `IndicatoreSoggettivo` int NOT NULL,
  `Time`  timestamp NOT NULL,
  `Animale` int NOT NULL,
  PRIMARY KEY (`IndicatoreSoggettivo`, `Time`, `Animale`),
  foreign key(IndicatoreSoggettivo) references IndicatoriSoggettivi(Codice),
  foreign key(`Time`) references SchedaMedica(`Time`),
  foreign key(Animale) references SchedaMedica(Animale)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Valutare`;
CREATE TABLE `Valutare` (
  `Indice` int NOT NULL,
  `Time`  timestamp NOT NULL,
  `Animale` int NOT NULL,
  PRIMARY KEY (`Indice`, `Time`, `Animale`),
  foreign key(Indice) references Indice(Codice),
  foreign key(`Time`) references SchedaMedica(`Time`),
  foreign key(Animale) references SchedaMedica(Animale)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


