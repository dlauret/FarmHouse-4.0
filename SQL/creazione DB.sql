SET NAMES latin1;
SET FOREIGN_KEY_CHECKS = 0;

BEGIN;
CREATE DATABASE IF NOT EXISTS `Agriturismo`;
COMMIT;

USE `Agriturismo`;
-- ==========================================================================================================================================================
 
 -- AREA ALLEVAMENTO
 
DROP TABLE IF EXISTS `Animale`;
CREATE TABLE `Animale` (
	`Codice` int auto_increment not null,
	`Famiglia` varchar(50) NOT NULL,
	`DataNascita` date NOT NULL,
	`Sesso` char(1) DEFAULT 'M' NOT NULL,
    `Specie` varchar(50) NOT NULL,
	`Razza` varchar(50) NOT NULL,
	`Altezza` float NOT NULL,
	`Peso` float NOT NULL,
	`DataArrivo` date DEFAULT NULL,
	`DataAcquisto` date DEFAULT NULL,
	`CodiceLocale` int NOT NULL,
	`Fornitore` int(11) DEFAULT NULL,
	`GPS` int NOT NULL,
	PRIMARY KEY (`Codice`),
	foreign key(CodiceLocale) references Locale(Codice) ON DELETE NO ACTION,
	foreign key(Fornitore) references Fornitore(PartitaIVA) ON DELETE NO ACTION,
	foreign key(GPS) references GPS(ID) ON DELETE NO ACTION,
    foreign key(Specie) references Specie(Nome) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `Fornitore`;
CREATE TABLE `Fornitore` (
	`PartitaIVA` int(11) not null,
	`Nome` varchar(50) NOT NULL,
    `Indirizzo` varchar(50) NOT NULL,
    `RagioneSociale` varchar(50) NOT NULL,
	PRIMARY KEY (`PartitaIVA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `GPS`;
CREATE TABLE `GPS` (
	`ID` int auto_increment not null,
	`Longitudine` varchar(50) NOT NULL,
    `Latitudine` varchar(50) NOT NULL,
    `Time` timestamp NOT NULL,
	PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `Locale`;
CREATE TABLE `Locale` (
	`Codice` int auto_increment not null,
	`PtCardinaleFinestra` char(1) NOT NULL, -- N E S W
	`TipoPavimento` varchar(50) NOT NULL,
	`Altezza` float NOT NULL,
    `Larghezza` float NOT NULL,
	`Lunghezza` float NOT NULL,
	`CodiceStalla` int NOT NULL,
	`Specie` varchar(50) NOT NULL,
	`NumMassimo` int NOT NULL,
	`Allestimento` int NOT NULL,
	PRIMARY KEY (`Codice`),
	foreign key(CodiceStalla) references Stalla(Codice) ON DELETE NO ACTION,
	foreign key(Specie) references Specie(Nome) ON DELETE NO ACTION,
	foreign key(Allestimento) references Allestimento(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `Sensore`;
CREATE TABLE `Sensore` (
	`Codice` int auto_increment not null,
	`Temperatura` float NOT NULL, -- Celsius
	`Umidita` float NOT NULL,
	`LivAzoto` float NOT NULL,
    `LivMetano` float NOT NULL,
	`LivSporco` float NOT NULL,
	`Locale` int NOT NULL,
	PRIMARY KEY (`Codice`),
	foreign key(Locale) references Locale(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `Stalla`;
CREATE TABLE `Stalla` (
	`Codice` int auto_increment not null,
	`CodiceAgriturismo` int NOT NULL,
    primary key(`Codice`),
	foreign key(CodiceAgriturismo) references Agriturismo(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `Agriturismo`;
CREATE TABLE `Agriturismo` (
	`Codice` int auto_increment not null,
	`Nome` varchar(50) NOT NULL,
    `Citta` varchar(50) NOT NULL,
    `Indirizzo` varchar(50) NOT NULL,
    primary key(`Codice`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Dipendente`;
CREATE TABLE `Dipendente` (
	`Codice` int auto_increment not null,
	`Nome` varchar(50) NOT NULL,
    `Cognome` varchar(50) NOT NULL,
    `DataNascita` date NOT NULL,
    `Tipologia` char(1) NOT NULL, -- L --> Lotto, G --> Guida, P --> Pulizia
	`Gruppo` int,
	`CodiceAgriturismo` int NOT NULL,
    primary key(`Codice`),
    foreign key(Gruppo) references Gruppo(Codice) ON DELETE NO ACTION,
    foreign key(CodiceAgriturismo) references Agriturismo(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `Gruppo`;
CREATE TABLE `Gruppo` (
	`Codice` int auto_increment not null,
    primary key(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `Specie`;
CREATE TABLE `Specie` (
	`Nome` varchar(50) not null,
    primary key(Nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `Zona`;
CREATE TABLE `Zona` (
	`CodiceAgriturismo` int not null,
    `Nome` varchar(50) NOT NULL,
	PRIMARY KEY (`CodiceAgriturismo`,`Nome`),
    unique(Nome),
    foreign key(`CodiceAgriturismo`) references Agriturismo(`Codice`)  ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Pascolo`;
CREATE TABLE `Pascolo` (
	`Codice` int auto_increment not null,
    `TimeInizio` timestamp NOT NULL,
    `TimeFine` timestamp NOT NULL,
	`NomeZona` varchar(50) NOT NULL,
    `CodiceAgriturismo` int NOT NULL,
	PRIMARY KEY (`Codice`),
    foreign key(`NomeZona`) references Zona(`Nome`) ON DELETE NO ACTION,
    foreign key(`CodiceAgriturismo`) references Zona(`CodiceAgriturismo`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Foraggio`;
CREATE TABLE `Foraggio` (
	`Codice` int auto_increment not null,
	`Peso` float NOT NULL, -- Celsius
	`KCal` float NOT NULL,
	`Frutta` float NOT NULL,
    `Cereali` float NOT NULL,
	`Piante` float NOT NULL,
    `Proteine` float NOT NULL,
    `Glucidi` float NOT NULL,
	`Fibre` float NOT NULL,
	`Tipo` char(1) NOT NULL, -- F --> fresco, C --> Conservato
	PRIMARY KEY (`Codice`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Mangiatoia`;
CREATE TABLE `Mangiatoia` (
	`Codice` int auto_increment not null,
    `Allestimento` int not null,
	PRIMARY KEY (`Codice`),
    foreign key(Allestimento) references Allestimento(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Abbeveratoio`;
CREATE TABLE `Abbeveratoio` (
	`Codice` int auto_increment not null,
    `Allestimento` int not null,
	PRIMARY KEY (`Codice`),
    foreign key(Allestimento) references Allestimento(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `CondizionamentoIlluminazione`;
CREATE TABLE `CondizionamentoIlluminazione` (
	`Codice` int auto_increment not null,
    `Tipo` char(1) not null, -- C --> Condizionamento, I --> Illuminazione
    `Allestimento` int not null,
	PRIMARY KEY (`Codice`),
    foreign key(Allestimento) references Allestimento(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Allestimento`;
CREATE TABLE `Allestimento` (
	`Codice` int auto_increment not null,
	PRIMARY KEY (`Codice`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Riproduzione`;
CREATE TABLE `Riproduzione` (
	`Codice` int auto_increment not null,
    `Time` timestamp NOT NULL,
	`Stato` varchar(50) NOT NULL,
    `Veterinario` int not null,
	PRIMARY KEY (`Codice`),
    foreign key(Veterinario) references Veterinario(Matricola) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Veterinario`;
CREATE TABLE `Veterinario` (
	`Matricola` int auto_increment not null,
    `Nome` varchar(50) NOT NULL,
    `Cognome` varchar(50) NOT NULL,
    `Parcella` float NOT NULL,
	PRIMARY KEY (`Matricola`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `InterventoDiControllo`;
CREATE TABLE `InterventoDiControllo` (
	`Codice` int auto_increment not null,
    `DataProgrammata` date NOT NULL,
    `DataControllo` date,
    `Stato` varchar(50) NOT NULL,
    `Esito` varchar(50),
    `Veterinario` int not null,
    `CodiceRiproduzione` int not null,
    `Terapia` int,
	PRIMARY KEY (`Codice`),
    foreign key(Veterinario) references Veterinario(Matricola) ON DELETE NO ACTION,
    foreign key(CodiceRiproduzione) references Riproduzione(Codice) ON DELETE NO ACTION,
    foreign key(Terapia) references Terapia(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Esame`;
CREATE TABLE `Esame` (
	`Codice` int auto_increment not null,
    `Time` timestamp NOT NULL,
    `DescrizioneProcedimento` varchar(256) not null,
    `Nome` varchar(50) NOT NULL,
    `Macchinario` int,
    `InterventoDiControllo` int not null,
	PRIMARY KEY (`Codice`),
    foreign key(Macchinario) references Macchinario(Codice) ON DELETE NO ACTION,
    foreign key(InterventoDiControllo) references InterventoDiControllo(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Macchinario`;
CREATE TABLE `Macchinario` (
	`Codice` int auto_increment not null,
	PRIMARY KEY (`Codice`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
DROP TABLE IF EXISTS `Recinzione`;
CREATE TABLE `Recinzione` (
	`ID` int auto_increment not null,
    `X1` int not null,
    `Y1` int not null,
    `X2` int not null,
    `Y2` int not null,
    `NomeZona` varchar(50) not null,
    `CodiceAgriturismo` int not null,
	PRIMARY KEY (`ID`),
    foreign key(NomeZona) references Zona(Nome) ON DELETE NO ACTION,
    foreign key(CodiceAgriturismo) references Zona(CodiceAgriturismo) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!




DROP TABLE IF EXISTS `SchedaDiGestazione`;
CREATE TABLE `SchedaDiGestazione` (
	`CodiceRiproduzione` int auto_increment not null,
    `Veterinario` int not null,
	PRIMARY KEY (`CodiceRiproduzione`),
    foreign key(Veterinario) references Veterinario(Matricola) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `StatoSensore`;
CREATE TABLE `StatoSensore` (
	`Time` timestamp not null,
    `Sensore` int not null,
    `Stato` varchar(50) not null,
	PRIMARY KEY (`Time`, `Sensore`),
    foreign key(Sensore) references Sensore(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `StatoMangiatoia`;
CREATE TABLE `StatoMangiatoia` (
	`Mangiatoia` int not null,
    `Istante` timestamp not null,
    `Quantita` float not null,
	`Foraggio` int not null,
	PRIMARY KEY (`Mangiatoia`, `Istante`),
    foreign key(Mangiatoia) references Mangiatoia(Codice) ON DELETE NO ACTION,
    foreign key(Foraggio) references Foraggio(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `StatoAbbeveratoio`;
CREATE TABLE `StatoAbbeveratoio` (
	`Abbeveratoio` int not null,
    `Istante` timestamp not null,
    `SaliMinaerali` float not null,
    `Vitamine` float not null,
    `Quantita` float not null,
	PRIMARY KEY (`Abbeveratoio`, `Istante`),
    foreign key(Abbeveratoio) references Abbeveratoio(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;





DROP TABLE IF EXISTS `Andare`;
CREATE TABLE `Andare` (
	`Animale` int not null,
    `Pascolo` int not null,
	PRIMARY KEY (`Animale`, `Pascolo`),
    foreign key(Animale) references Animale(Codice) ON DELETE NO ACTION,
    foreign key(Pascolo) references Pascolo(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Effettua`;
CREATE TABLE `Effettua` (
	`Animale` int not null,
    `Riproduzione` int not null,
	PRIMARY KEY (`Animale`, `Riproduzione`),
    foreign key(Animale) references Animale(Codice) ON DELETE NO ACTION,
    foreign key(Riproduzione) references Riproduzione(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Parentela`;
CREATE TABLE `Parentela` (
	`Genitore` int not null,
    `Figlio` int not null,
	PRIMARY KEY (`Genitore`, `Figlio`),
    foreign key(Genitore) references Animale(Codice) ON DELETE NO ACTION,
    foreign key(Figlio) references Animale(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- =============== AREA HEALTHCARE ======================


DROP TABLE IF EXISTS `Terapia`;
CREATE TABLE `Terapia` (
  `Codice` int auto_increment NOT NULL,
  `Veterinario` int NOT NULL,
  `Animale` int NOT NULL,
  `Data` DATE NOT NULL,
  `DataInizioTerapia` DATE NOT NULL,
  `Durata` int NOT NULL,
  `Posologia` int NOT NULL,
  `Patologia` varchar(50) NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(Patologia) references Patologia(NomePatologia) ON DELETE NO ACTION,
  foreign key(Veterinario) references Veterinario(Matricola) ON DELETE NO ACTION,
  foreign key(Veterinario) references Visita(Veterinario) ON DELETE NO ACTION,
  foreign key(Animale) references Visita(Animale) ON DELETE NO ACTION,
  foreign key(Data) references Visita(Data)  ON DELETE NO ACTION 
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
  foreign key(Animale) references Animale(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `SchedaMedica`;
CREATE TABLE `SchedaMedica` (
  `Time` timestamp NOT NULL,
  `Animale` int NOT NULL,
  PRIMARY KEY (`Time`, `Animale`),
  foreign key(Animale) references Animale(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Farmaco`;
CREATE TABLE `Farmaco` (
  `NomeCommerciale` varchar(50) NOT NULL,
  `Patologia` varchar(50) NOT NULL,
  `PrincipioAttivo` varchar(50) NOT NULL,
  PRIMARY KEY (`NomeCommerciale`, `Patologia`),
  foreign key(Patologia) references Patologia(NomePatologia) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `SchedaTerapia`;
CREATE TABLE `SchedaTerapia` (
  `Farmaco` varchar(50) NOT NULL,
  `Patologia` varchar(50) NOT NULL,
  `DataInizio` DATE NOT NULL,
  `Terapia` int NOT NULL,
  `DataFine` DATE NOT NULL,
  PRIMARY KEY (`Farmaco`, `Patologia`),
  foreign key(Farmaco) references Farmaco(NomeCommerciale) ON DELETE NO ACTION,
  foreign key(Patologia) references Farmaco(Patologia) ON DELETE NO ACTION,
  foreign key(Terapia) references Terapia(Codice) ON DELETE NO ACTION
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
  unique(Data),
  foreign key(Veterinario) references Veterinario(Matricola) ON DELETE NO ACTION,
  foreign key(Animale) references Animale(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Dosaggio`;
CREATE TABLE `Dosaggio` (
  `Farmaco` varchar(50) NOT NULL,
  `Patologia` varchar(50) NOT NULL,
  `DataInizio` DATE NOT NULL,
  `Terapia` int NOT NULL,
  `Ora` char(1) NOT NULL,
  `Dose` float NOT NULL,
  PRIMARY KEY (`Farmaco`, `Patologia`, `DataInizio`, `Terapia`, `Ora`),
  foreign key(Farmaco) references SchedaTerapia(Farmaco) ON DELETE NO ACTION,
  foreign key(Patologia) references SchedaTerapia(Patologia) ON DELETE NO ACTION,
  foreign key(Terapia) references SchedaTerapia(Terapia) ON DELETE NO ACTION,
  foreign key(Ora) references Orario(Ora) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Possibilita`;
CREATE TABLE `Possibilita` (
  `IndicatoreSoggettivo` int NOT NULL,
  `Time`  timestamp NOT NULL,
  `Animale` int NOT NULL,
  PRIMARY KEY (`IndicatoreSoggettivo`, `Time`, `Animale`),
  foreign key(IndicatoreSoggettivo) references IndicatoriSoggettivi(Codice) ON DELETE NO ACTION,
  foreign key(`Time`) references SchedaMedica(`Time`) ON DELETE NO ACTION,
  foreign key(Animale) references SchedaMedica(Animale) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Valutare`;
CREATE TABLE `Valutare` (
  `Indice` int NOT NULL,
  `Time`  timestamp NOT NULL,
  `Animale` int NOT NULL,
  PRIMARY KEY (`Indice`, `Time`, `Animale`),
  foreign key(Indice) references Indice(Codice) ON DELETE NO ACTION,
  foreign key(`Time`) references SchedaMedica(`Time`) ON DELETE NO ACTION,
  foreign key(Animale) references SchedaMedica(Animale) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ================ AREA PRODUZIONE =========================

DROP TABLE IF EXISTS `Silos`;
CREATE TABLE `Silos` (
  `Codice` int auto_increment NOT NULL,
  `Marca`  varchar(50) NOT NULL,
  PRIMARY KEY (`Codice`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `StatoSilos`;
CREATE TABLE `StatoSilos` (
  `Codice` int auto_increment NOT NULL,
  `Silos` int NOT NULL,
  `Capacita`  int NOT NULL,
  `LivRiempimento` float NOT NULL,
  `pH` int NOT NULL,
  `Densita` float NOT NULL,
  `Glucosio` float NOT NULL,
  `Caseina` float NOT NULL,
  `Lattoalbumina` float NOT NULL,
  `Temperatura` float NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(Silos) references Silos(Codice) ON DELETE NO ACTION
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
  foreign key(ScaffaleCantina) references ScaffaleCantina(Codice) ON DELETE NO ACTION,
  foreign key(ScaffaleMagazzino) references ScaffaleMagazzino(Codice) ON DELETE NO ACTION,
  foreign key(ProdottoCaseario) references ProdottoCaseario(Nome) ON DELETE NO ACTION,
  foreign key(Lotto) references Lotto(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `ScaffaleCantina`;
CREATE TABLE `ScaffaleCantina` (
  `Codice` int auto_increment NOT NULL,
  `CapienzaMax`int NOT NULL,
  `Cantina` int NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(Cantina) references Cantina(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `ScaffaleMagazzino`;
CREATE TABLE `ScaffaleMagazzino` (
  `Codice` int auto_increment NOT NULL,
  `CapienzaMax`int NOT NULL,
  `Magazzino` int NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(Magazzino) references Magazzino(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Cantina`;
CREATE TABLE `Cantina` (
  `Codice` int auto_increment NOT NULL,
  `Agriturismo` int NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(Agriturismo) references Agriturismo(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Magazzino`;
CREATE TABLE `Magazzino` (
  `Codice` int auto_increment NOT NULL,
  `Agriturismo` int NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(Agriturismo) references Agriturismo(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `StatoCantina`;
CREATE TABLE `StatoCantina` (
  `Time` timestamp NOT NULL,
  `Cantina` int NOT NULL,
  `Temperatura` float NOT NULL,
  `Umidiita` float NOT NULL,
  PRIMARY KEY (`Time`, `Cantina`),
  foreign key(Cantina) references Cantina(Codice) ON DELETE NO ACTION
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
  foreign key(Laboratorio) references Laboratorio(Codice) ON DELETE NO ACTION,
  foreign key(Dipendente) references Dipendente(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `FaseLotto`;
CREATE TABLE `FaseLotto` (
  `Lotto` int NOT NULL,
  `NumFase` int NOT NULL,
  `Durata` float NOT NULL,
  `Temperatura` float NOT NULL,
  PRIMARY KEY (`Lotto`, `NumFase`),
  unique(Lotto),
  unique(NumFase),
  foreign key(Lotto) references Lotto(Codice) ON DELETE NO ACTION
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
  foreign key(GPS) references GPS(ID) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Mungitura`;
CREATE TABLE `Mungitura` (
  `Mungitrice` int NOT NULL,
  `Time` timestamp NOT NULL,
  PRIMARY KEY (`Mungitrice`, `Time`),
  unique(Mungitrice),
  unique(Time),
  foreign key(Mungitrice) references Mungitrice(Codice) ON DELETE NO ACTION
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
  foreign key(Mungitrice) references Mungitura(Mungitrice) ON DELETE NO ACTION,
  foreign key(Time) references Mungitura(Time) ON DELETE NO ACTION,
  foreign key(StatoSilos) references StatoSilos(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Ricetta`;
CREATE TABLE `Ricetta` (
  `Prodotto` varchar(50) NOT NULL,
  `Descrizione` varchar(50) NOT NULL,
  `DataStagiontura` DATE NOT NULL,
  PRIMARY KEY (`Prodotto`),
  foreign key(Prodotto) references ProdottoCaseario(Nome) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Fase`;
CREATE TABLE `Fase` (
  `Prodotto` varchar(50) NOT NULL,
  `IDFase` int NOT NULL,
  `Durata` float NOT NULL,
  PRIMARY KEY (`Prodotto`, `IDFase`),
  unique(IDFase),
  foreign key(Prodotto) references Ricetta(Prodotto) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Laboratorio`;
CREATE TABLE `Laboratorio` (
  `Codice` int auto_increment NOT NULL,
  `Tipo` varchar(50) NOT NULL,
  `Agriturismo` int NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(Agriturismo) references Agriturismo(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Prelievo`;
CREATE TABLE `Prelievo` (
  `Lotto` int NOT NULL,
  `StatoSilos` int NOT NULL,
  `Quantita` float NOT NULL,
  PRIMARY KEY (`Lotto`, `StatoSilos`),
  foreign key(StatoSilos) references StatoSilos(Codice) ON DELETE NO ACTION,
  foreign key(Lotto) references Lotto(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Avere`;
CREATE TABLE `Avere` (
  `Lotto` int NOT NULL,
  `NumFase` int NOT NULL,
  `Parametro` varchar(50) NOT NULL,
  `Quantita` float NOT NULL,
  PRIMARY KEY (`Lotto`,`NumFase`,`Parametro`),
  foreign key(Parametro) references Parametro(Nome) ON DELETE NO ACTION,
  foreign key(NumFase) references FaseLotto(NumFase) ON DELETE NO ACTION,
  foreign key(Lotto) references FaseLotto(Lotto) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Composta`;
CREATE TABLE `Composta` (
  `Prodotto` varchar(50) NOT NULL,
  `IDFase` int NOT NULL,
  `Parametro` varchar(50) NOT NULL,
  `Quantita` float NOT NULL,
  PRIMARY KEY (`Prodotto`, `IDFase`, `Parametro`),
  foreign key(Parametro) references ParametroIdeale(Nome) ON DELETE NO ACTION,
  foreign key(IDFase) references Fase(IDFase) ON DELETE NO ACTION,
  foreign key(Prodotto) references Fase(Prodotto) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;





DROP TABLE IF EXISTS `Impiegato`;
CREATE TABLE `Impiegato` (
  `Lotto` int NOT NULL,
  `Dipendente` int NOT NULL,
  PRIMARY KEY (`Lotto`, `Dipendente`),
  foreign key(Lotto) references Lotto(Codice) ON DELETE NO ACTION,
  foreign key(Dipendente) references Dipendente(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ============ AREA SOGGIORNO ===============

DROP TABLE IF EXISTS `Prenotazione`;
CREATE TABLE `Prenotazione` (
  `ID` int auto_increment NOT NULL,
  `DataArrivo` DATE NOT NULL,
  `DataPartenza` DATE NOT NULL,
  `Anticipo` float default 0,
  `UtenteRegistrato` int,
  `UtenteNonRegistrato` int,
  PRIMARY KEY (`ID`),
  foreign key(UtenteRegistrato) references Registrato(Codice) ON DELETE NO ACTION,
  foreign key(UtenteNonRegistrato) references NonRegistrato(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Escursione`;
CREATE TABLE `Escursione` (
  `Nome` varchar(50) NOT NULL,
  `Costo` float NOT NULL,
  `Itinerario` int NOT NULL,
  `OraFine` time,
  `OraInizio` time,
  `GiornoSettimana` char(2),		-- LU, MA, ME, GI, VE, SA, DO
  `Guida` int not null,
  PRIMARY KEY (`Nome`),
  foreign key(Guida) references Dipendente(Codice) ON DELETE NO ACTION,
  foreign key(Itinerario) references Itinerario(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Servizio`;
CREATE TABLE `Servizio` (
  `Nome` varchar(50) NOT NULL,
  `CostoUnitario` float NOT NULL,
  PRIMARY KEY (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Itinerario`;
CREATE TABLE `Itinerario` (
    `Codice` INT AUTO_INCREMENT NOT NULL,
    PRIMARY KEY (`Codice`)
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;




DROP TABLE IF EXISTS `Area`;
CREATE TABLE `Area` (
  `Itinerario` int NOT NULL,
  `Ora` time NOT NULL,
  `Nome` varchar(50) NOT NULL,
  `DurataSosta` float default 0,
  `Agriturismo` int not null,
  PRIMARY KEY (`Itinerario`, `Ora`, `Nome`),
  foreign key(Itinerario) references Itinerario(Codice) ON DELETE NO ACTION,
  foreign key(Agriturismo) references Agriturismo(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `ServizioAggiuntivo`;
CREATE TABLE `ServizioAggiuntivo` (
  `Servizio` varchar(50) NOT NULL,
  `TimeInizio` time NOT NULL,
  `TimeFine` time NOT NULL,
  `Prenotazione` int NOT NULL, 
  PRIMARY KEY (`Servizio`, `TimeInizio`, `TimeFine`, `Prenotazione`),
  foreign key(Servizio) references Servizio(Nome) ON DELETE NO ACTION,
  foreign key(Prenotazione) references Prenotazione(ID) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Stanza`;
CREATE TABLE `Stanza` (
  `NumStanza` int auto_increment NOT NULL,
  `CostoStanza` float NOT NULL,
  `Tipo` varchar(8) NOT NULL,			-- Semplice o suite
  PRIMARY KEY (`NumStanza`, `CostoStanza`, `Tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Letto`;
CREATE TABLE `Letto` (
  `CodLetto` int auto_increment NOT NULL,
  `TipoLetto` char(1) NOT NULL,			-- S = singolo, M = Matrimoniale
  `Stanza` int NOT NULL,			
  PRIMARY KEY (`CodLetto`),
  foreign key(Stanza) references Stanza(NumStanza) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Pagamento`;
CREATE TABLE `Pagamento` (
  `Prenotazione` int NOT NULL,
  `Time` time NOT NULL,			
  `Importo` float NOT NULL,			
  PRIMARY KEY (`Prenotazione`, `Time`),
  foreign key(Prenotazione) references Prenotazione(ID) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Registrato`;
CREATE TABLE `Registrato` (
  `Codice` int auto_increment NOT NULL,
  `Telefono` varchar(50) NOT NULL,			
  `Nome` varchar(50) NOT NULL,			
  `Cognome` varchar(50) NOT NULL,			
  `CodCarta` int NOT NULL,			
  `Tipologia` char(2) NOT NULL,		-- CC = Carta di credito, PP = PayPal
  `NumDocumento` varchar(50) NOT NULL,	
  `Scadenza` date NOT NULL,	
  `Ente` varchar(50) NOT NULL,			
  PRIMARY KEY (`Codice`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `NonRegistrato`;
CREATE TABLE `NonRegistrato` (
  `Codice` int auto_increment NOT NULL,
  `CodiceCarta` int NOT NULL,			
  PRIMARY KEY (`Codice`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Riferimento`;
CREATE TABLE `Riferimento` (
  `Prenotazione` int NOT NULL,
  `Stanza` int NOT NULL,			
  PRIMARY KEY (`Prenotazione`, `Stanza`),
  foreign key(Prenotazione) references Prenotazione(ID) ON DELETE NO ACTION,
  foreign key(Stanza) references Stanza(NumStanza) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;





DROP TABLE IF EXISTS `Associare`;
CREATE TABLE `Associare` (
  `Prenotazione` int NOT NULL,
  `Escursione` varchar(50) NOT NULL,			
  PRIMARY KEY (`Prenotazione`, `Escursione`),
  foreign key(Prenotazione) references Prenotazione(ID) ON DELETE NO ACTION,
  foreign key(Escursione) references Escursione(Nome) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


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
  foreign key(Account) references Account(NomeUtente) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Reso`;
CREATE TABLE `Reso` (
  `Codice` int auto_increment NOT NULL,
  `DataReso` date NOT NULL,			
  `UnitaProdotto` int NOT NULL,
  PRIMARY KEY (`Codice`),
  foreign key(UnitaProdotto) references UnitaProdotto(Codice) ON DELETE NO ACTION
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
  foreign key(UnitaProdotto) references UnitaProdotto(Codice) ON DELETE NO ACTION
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
  foreign key(UnitaProdotto) references UnitaProdotto(Codice) ON DELETE NO ACTION,
  foreign key(Spedizione) references Spedizione(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;





DROP TABLE IF EXISTS `Controllo`;
CREATE TABLE `Controllo` (
  `Reso` int NOT NULL,
  `ParametroQualita` varchar(50) NOT NULL,			
  `Valutazione` int NOT NULL,		
  PRIMARY KEY (`Reso`, `ParametroQualita`),
  foreign key(Reso) references Reso(Codice) ON DELETE NO ACTION,
  foreign key(ParametroQualita) references ParametroQualita(Nome) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Prevedere`;
CREATE TABLE `Prevedere` (
  `Spedizione` int NOT NULL,
  `Hub` int NOT NULL,			
  `Time` timestamp NOT NULL,		
  PRIMARY KEY (`Spedizione`, `Hub`),
  foreign key(Spedizione) references Spedizione(Codice) ON DELETE NO ACTION,
  foreign key(Hub) references Hub(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Selezione`;
CREATE TABLE `Selezione` (
  `ProdottoCaseario` varchar(50) NOT NULL,
  `Ordine` int NOT NULL,			
  `Quantita` int NOT NULL,		
  PRIMARY KEY (`ProdottoCaseario`, `Ordine`),
  foreign key(ProdottoCaseario) references ProdottoCaseario(Nome) ON DELETE NO ACTION,
  foreign key(Ordine) references Ordine(Codice) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


