-- -----------------------------------------------------
-- Group 30 DDL 
-- Team Members: Gautam Kovoor, Matthew Adams 
-- Project Title: Soccer Player Transfer Index 
-- -----------------------------------------------------

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

-- -----------------------------------------------------
-- Table `Leagues`
-- -----------------------------------------------------
CREATE OR REPLACE TABLE Leagues (
  `leagueID` INT NOT NULL AUTO_INCREMENT,
  `leagueName` VARCHAR(100) NOT NULL,
  `country` VARCHAR(100),
  `divisionRank` INT,
  `numberOfTeams` INT,
  `yearFounded` YEAR,
  PRIMARY KEY (`leagueID`)
);

-- -----------------------------------------------------
-- Table `Teams`
-- -----------------------------------------------------
CREATE OR REPLACE TABLE Teams (
  `teamID` INT NOT NULL AUTO_INCREMENT,
  `teamName` VARCHAR(100) NOT NULL,
  `city` VARCHAR(100),
  `country` VARCHAR(100),
  `yearFounded` YEAR,
  `stadiumCapacity` INT,
  `leagueID` INT,
  PRIMARY KEY (`teamID`),
  FOREIGN KEY (`leagueID`) REFERENCES Leagues(`leagueID`) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table `Agents`
-- -----------------------------------------------------
CREATE OR REPLACE TABLE Agents (
  `agentID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `agentFirstName` VARCHAR(100) NOT NULL,
  `agentLastName` VARCHAR(100) NOT NULL,
  `agentAgency` VARCHAR(100),
  `agentYearsExperience` INT,
  `agentCommissionRate` DECIMAL(2,2),
  PRIMARY KEY (`agentID`)
);

-- -----------------------------------------------------
-- Table `Players`
-- -----------------------------------------------------
CREATE OR REPLACE TABLE Players (
  `playerID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `playerFirstName` VARCHAR(100) NOT NULL,
  `playerLastName` VARCHAR(100) NOT NULL,
  `currentSalary` DECIMAL(12,2),
  `age` INT,
  `country` VARCHAR(100),
  `position` VARCHAR(50),
  `clubAppearances` INT,
  `internationalAppearances` INT,
  `playerMarketValue` DECIMAL(12,2),
  `goals` INT,
  `assists` INT,
  `saves` INT,
  `minutesPlayed` INT,
  `teamID` INT,
  PRIMARY KEY (`playerID`),
  FOREIGN KEY (`teamID`) REFERENCES Teams(`teamID`) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table `Transfers`
-- -----------------------------------------------------
CREATE OR REPLACE TABLE Transfers (
  `transferID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `playerID` INT UNSIGNED NOT NULL,
  `agentID` INT UNSIGNED NOT NULL,
  `sellingTeamID` INT NOT NULL,
  `buyingTeamID` INT NOT NULL,
  `dateOfTransfer` DATE,
  `transferFee` DECIMAL(12,2),
  `newContractLength` INT,
  `agentCommissionPercent` DECIMAL(2,2),
  PRIMARY KEY (`transferID`),
  FOREIGN KEY (`playerID`) REFERENCES Players(`playerID`) ON DELETE CASCADE,
  FOREIGN KEY (`sellingTeamID`) REFERENCES Teams(`teamID`) ON DELETE CASCADE,
  FOREIGN KEY (`buyingTeamID`) REFERENCES Teams(`teamID`) ON DELETE CASCADE,
  FOREIGN KEY (`agentID`) REFERENCES Agents(`agentID`) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Intersection Table `Teams_Leagues`
-- -----------------------------------------------------
CREATE OR REPLACE TABLE TeamsLeagues (
  `teamID` INT NOT NULL,
  `leagueID` INT NOT NULL,
  PRIMARY KEY (`teamID`, `leagueID`),
  FOREIGN KEY (`teamID`) REFERENCES Teams(`teamID`) ON DELETE CASCADE,
  FOREIGN KEY (`leagueID`) REFERENCES Leagues(`leagueID`) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Inserting into Leagues Table
-- -----------------------------------------------------
INSERT INTO Leagues (`leagueName`, `country`, `divisionRank`, `numberOfTeams`, `yearFounded`)
VALUES
('Premier League', 'England', '1', '20', '1992'),
('La Liga', 'Spain', '1', '20', '1929'),
('Ligue 1', 'France', '1', '18', '1932');

INSERT INTO Leagues (`leagueName`, `numberOfTeams`, `yearFounded`)
VALUES
('UEFA Champions League', '36', '1955');

-- -----------------------------------------------------
-- Inserting into Teams Table
-- -----------------------------------------------------
INSERT INTO Teams (`teamName`, `city`, `country`, `yearFounded`, `stadiumCapacity`, `leagueID`)
VALUES
('Arsenal F.C.', 'London', 'England', '1886', '60704', (SELECT leagueID FROM Leagues WHERE country = 'England')),
('Real Madrid CF', 'Madrid', 'Spain', '1902', '85000', (SELECT leagueID FROM Leagues WHERE country = 'Spain')),
('Manchester United F.C.', 'Manchester', 'England', '1878', '74310', (SELECT leagueID FROM Leagues WHERE country = 'England')),
('FC Barcelona', 'Barcelona', 'Spain', '1899', '110000', (SELECT leagueID FROM Leagues WHERE country = 'England')),
('Paris Saint-Germain F.C.', 'Paris', 'France', '1970', '47929', (SELECT leagueID FROM Leagues WHERE country = 'France'));

-- -----------------------------------------------------
-- Inserting into Agents Table
-- -----------------------------------------------------
INSERT INTO Agents (`agentFirstName`, `agentLastName`, `agentAgency`, `agentYearsExperience`, `agentCommissionRate`)
VALUES
('Kia', 'Joorabchian', 'Team Raiola', '15', '11'),
('Jorge', 'Mendes', 'Nordic Sky', '20', '25'),
('Fayza', 'Lamari', 'Vibra Footbal', '17', '13');

-- -----------------------------------------------------
-- Inserting into Players Table
-- -----------------------------------------------------
INSERT INTO Players (`playerFirstName`, `playerLastName`, `currentSalary`, `age`, `country`, 
`position`, `clubAppearances`, `internationalAppearances`, `playerMarketValue`, `goals`, 
`assists`, `saves`, `minutesPlayed`, `teamID`)
VALUES
('Martin', 'Odegaard', '250000', '25', 'Norway', 'Midfielder', '369', '59', '110000000',
'66', '67', '0', '27690', (SELECT teamID FROM Teams WHERE teamName = 'Arsenal F.C.')),
('Bukayo', 'Saka', '300000', '22', 'England', 'Forward', '269', '40', '140000000',
'80', '70', '0', '20838', (SELECT teamID FROM Teams WHERE teamName = 'Arsenal F.C.')),
('Kylian', 'Mbappe', '400000', '25', 'France', 'Forward', '373', '59', '180000000',
'288', '126', '0', '28,278', (SELECT teamID FROM Teams WHERE teamName = 'Paris Saint-Germain F.C.')),
('Alexis', 'Sanchez', '350000', '35', 'Chile', 'Forward', '701', '166', '2500000',
'202', '147', '0', '44041', (SELECT teamID FROM Teams WHERE teamName = 'Arsenal F.C.')),
('Christian', 'Eriksen', '7800000', '32', 'Denmark', 'Midfielder', '287', '134', '8000000',
'54', '79', '0', '22460', (SELECT teamID FROM Teams WHERE teamName = 'Manchester United F.C.')),
('Lamine', 'Yamal', '3340000', '17', 'Spain', 'Midfielder', '38', '14', '120000000',
'5', '8', '0', '2187', (SELECT teamID FROM Teams WHERE teamName = 'FC Barcelona'));

-- -----------------------------------------------------
-- Inserting into Transfers Table
-- -----------------------------------------------------
INSERT INTO Transfers (`playerID`, `agentID`, `sellingTeamID`, `buyingTeamID`, `dateOfTransfer`, 
`transferFee`, `newContractLength`, `agentCommissionPercent`)
VALUES
((SELECT playerID FROM Players WHERE playerFirstName = 'Kylian' AND playerLastName = 'Mbappe'), (SELECT 
agentID FROM Agents WHERE agentFirstName = 'Fayza' AND agentLastName = 'Lamari'), (SELECT teamID FROM
Teams WHERE teamName = 'Paris Saint-Germain F.C.'), (SELECT teamID FROM
Teams WHERE teamName = 'Real Madrid CF'), '2024-07-01', '180000000', '5', '20'),
((SELECT playerID FROM Players WHERE playerFirstName = 'Martin' AND playerLastName = 'Odegaard'), (SELECT 
agentID FROM Agents WHERE agentFirstName = 'Kia' AND agentLastName = 'Joorabchian'), (SELECT teamID FROM
Teams WHERE teamName = 'Real Madrid CF'), (SELECT teamID FROM
Teams WHERE teamName = 'Arsenal F.C.'), '2021-08-21', '35000000', '5', '15'),
((SELECT playerID FROM Players WHERE playerFirstName = 'Alexis' AND playerLastName = 'Sanchez'), (SELECT 
agentID FROM Agents WHERE agentFirstName = 'Jorge' AND agentLastName = 'Mendes'), (SELECT teamID FROM
Teams WHERE teamName = 'FC Barcelona'), (SELECT teamID FROM
Teams WHERE teamName = 'Arsenal F.C.'), '2014-07-10', '30000000', '6', '11');

-- -----------------------------------------------------
-- Inserting into Teams_Leagues Table
-- -----------------------------------------------------
INSERT INTO TeamsLeagues (`teamID`, `leagueID`)
VALUES
((SELECT teamID FROM Teams WHERE teamName = 'Paris Saint-Germain F.C.'), 
(SELECT leagueID FROM Leagues WHERE leagueName = 'UEFA Champions League')),
((SELECT teamID FROM Teams WHERE teamName = 'Paris Saint-Germain F.C.'), 
(SELECT leagueID FROM Leagues WHERE leagueName = 'Ligue 1')),
((SELECT teamID FROM Teams WHERE teamName = 'Arsenal F.C.'), 
(SELECT leagueID FROM Leagues WHERE leagueName = 'UEFA Champions League')),
((SELECT teamID FROM Teams WHERE teamName = 'Arsenal F.C.'), 
(SELECT leagueID FROM Leagues WHERE leagueName = 'Premier League')),
((SELECT teamID FROM Teams WHERE teamName = 'Real Madrid CF'), 
(SELECT leagueID FROM Leagues WHERE leagueName = 'UEFA Champions League')),
((SELECT teamID FROM Teams WHERE teamName = 'Real Madrid CF'), 
(SELECT leagueID FROM Leagues WHERE leagueName = 'La Liga')),
((SELECT teamID FROM Teams WHERE teamName = 'FC Barcelona'), 
(SELECT leagueID FROM Leagues WHERE leagueName = 'UEFA Champions League')),
((SELECT teamID FROM Teams WHERE teamName = 'FC Barcelona'), 
(SELECT leagueID FROM Leagues WHERE leagueName = 'La Liga'));

SET FOREIGN_KEY_CHECKS=1;
COMMIT;