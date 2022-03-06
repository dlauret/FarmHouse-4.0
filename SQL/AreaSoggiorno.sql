
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
  foreign key(UtenteRegistrato) references Registrato(Codice),
  foreign key(UtenteNonRegistrato) references NonRegistrato(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `Escursione`;
CREATE TABLE `Prenotazione` (
  `Nome` varchar(50) NOT NULL,
  `Costo` float NOT NULL,
  `Itinerario` int NOT NULL,
  `OraFine` time,
  `OraInizio` time,
  `GiornoSettimana` char(2),		-- LU, MA, ME, GI, VE, SA, DO
  `Guida` int not null,
  PRIMARY KEY (`Nome`),
  foreign key(Guida) references Dipendente(Codice),
  foreign key(Itinerario) references Itinerario(Codice)
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
  foreign key(Itinerario) references Itinerario(Codice),
  foreign key(Agriturismo) references Agriturismo(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `ServizioAggiuntivo`;
CREATE TABLE `ServizioAggiuntivo` (
  `Servizio` varchar(50) NOT NULL,
  `TimeInizio` time NOT NULL,
  `TimeFine` time NOT NULL,
  `Prenotazione` int NOT NULL, 
  PRIMARY KEY (`Servizio`, `TimeInizio`, `TimeFine`, `Prenotazione`),
  foreign key(Servizio) references Servizio(Nome),
  foreign key(Prenotazione) references Prenotazione(ID)
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
  foreign key(Stanza) references Stanza(NumStanza)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




DROP TABLE IF EXISTS `Pagamento`;
CREATE TABLE `Pagamento` (
  `Prenotazione` int NOT NULL,
  `Time` time NOT NULL,			
  `Importo` float NOT NULL,			
  PRIMARY KEY (`Prenotazione`, `Time`),
  foreign key(Prenotazione) references Prenotazione(ID)
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
  foreign key(Prenotazione) references Prenotazione(ID),
  foreign key(Stanza) references Stanza(NumStanza)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;





DROP TABLE IF EXISTS `Associare`;
CREATE TABLE `Associare` (
  `Prenotazione` int NOT NULL,
  `Escursione` varchar(50) NOT NULL,			
  PRIMARY KEY (`Prenotazione`, `Escursione`),
  foreign key(Prenotazione) references Prenotazione(ID),
  foreign key(Escursione) references Escursione(Nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


