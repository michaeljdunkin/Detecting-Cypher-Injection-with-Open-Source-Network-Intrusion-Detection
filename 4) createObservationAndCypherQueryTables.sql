CREATE TABLE `CypherQuery` (
  `QueryId` int NOT NULL AUTO_INCREMENT,
  `QueryTypeCd` varchar(4000) NOT NULL,
  `QueryTxt` varchar(4000) NOT NULL,
  `InjectionQueryInd` tinyint(1) NOT NULL,
  `ExpectedSnortRuleId` int NOT NULL,
  `SourceTxt` varchar(4000) NOT NULL DEFAULT '',
  `DestructiveInd` tinyint NOT NULL DEFAULT 0,
TautologyInd  tinyint NOT NULL DEFAULT 0,
piggybackedInd tinyint not null default 0,
illegalIncorrectInd  tinyint NOT NULL DEFAULT 0,
unionInd  tinyint NOT NULL DEFAULT 0,
alternateEncodingInd tinyint NOT NULL DEFAULT 0,
booleanInd	 tinyint NOT NULL DEFAULT 0,
OOBInd	 tinyint NOT NULL DEFAULT 0,
detectionEvasionInd  tinyint NOT NULL DEFAULT 0,
storedProcedureInd  tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`QueryId`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `BaselineObservation` (
  `ObservationId` int NOT NULL AUTO_INCREMENT,
  `ObservationTs` datetime NOT NULL,
  `RunTs` datetime NOT NULL,
  `QueryId` int NOT NULL,
  `ResponseTxt` varchar(4000) NOT NULL,
  `DetectionTxt` varchar(4000) NOT NULL,
  `DetectedInd` tinyint(1) NOT NULL,
  `DurationMs` int NOT NULL,
  PRIMARY KEY (`ObservationId`)
) ENGINE=InnoDB AUTO_INCREMENT=2931 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
