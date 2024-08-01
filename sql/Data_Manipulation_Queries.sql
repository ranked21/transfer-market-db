-- -----------------------------------------------------
-- Table `Leagues` Operations
-- -----------------------------------------------------
-- Get all Leagues
SELECT * FROM Leagues;

-- Add a new League
INSERT INTO Leagues (`leagueName`, `country`, `divisionRank`, `numberOfTeams`, `yearFounded`)
VALUES (:leagueName, :country, :divisionRank, :numberOfTeams, :yearFounded);

-- Update an existing League
UPDATE Leagues
SET leagueName = :leagueName, country = :country, divisionRank = :divisionRank, 
numberOfTeams = :numberOfTeams, yearFounded = :yearFounded
WHERE leagueID = :leagueID;

-- Delete a League
DELETE FROM Leagues
WHERE leagueID = :leagueID

-- -----------------------------------------------------
-- Table `Teams`
-- -----------------------------------------------------
-- Get all Teams
SELECT * FROM Teams;

-- Add a new Team
INSERT INTO Teams (`teamName`, `city`, `country`, `yearFounded`, `stadiumCapacity`, `leagueID`)
VALUES (:teamName, :city, :country, :yearFounded, :stadiumCapacity, :leagueID);

-- Updating an existing Team
UPDATE Teams
SET team = :teamName, city = :city, country = :country, yearFounded = :yearFounded,
stadiumCapacity = :stadiumCapacity, leagueID = :leagueID
WHERE teamID = :teamID;

-- Delete a Team
DELETE FROM Teams
WHERE teamID = :teamID;

-- -----------------------------------------------------
-- Table `Agents`
-- -----------------------------------------------------
-- Get all Agents
SELECT * FROM Agents;

-- Add a new Agent
INSERT INTO Agents (`agentFirstName`, `agentLastName`, `agentAgency`, `agentYearsExperience`, `agentCommissionRate`)
VALUES (:agentFirstName, :agentLastName, :agentAgency, :agentYearsExperience, :agentCommissionRate);

-- Update an existing Agent
UPDATE Agents
SET agentFirstName = :agentFirstName, agentLastName = agentLastName, agentAgency = :agentAgency,
agentYearsExperience = :agentYearsExperience, agentCommissionRate = :agentCommissionRate
WHERE agentID = :agentID;

-- Delete an Agent
DELETE FROM Agents
WHERE agentID = :agentID;

-- -----------------------------------------------------
-- Table 'Players'
-- -----------------------------------------------------
-- Get all Players
SELECT * FROM Players;

-- Add a new Player
INSERT INTO Players (`playerFirstName`, `playerLastName`, `currentSalary`, `age`, `country`, 
`position`, `clubAppearances`, `internationalAppearances`, `playerMarketValue`, `goals`, 
`assists`, `saves`, `minutesPlayed`, `teamID`)
VALUES (:playerFirstName, :playerLastName, :currentSalary, :age, :country, :position,
:clubAppearances, :internationalAppearances, :playerMarketValue, :goals, :assists, :saves,
:minutesPlayed, :teamID);

-- Update an existing Player
UPDATE Players
SET playerFirstName = :playerFirstName, playerLastName = :playerLastName, currentSalary = :currentSalary,
age = :age, county = :country, position = :position, clubAppearances = :clubAppearances, internationalAppearances = :internationalAppearances,
playerMarketValue = :playerMarketValue, goals = :goals, assists = :assists, saves = :saves,
minutesPlayed = :minutesPlayed, teamID = :teamID
WHERE playerID = :playerID;

-- Delete an existing Player
DELETE FROM Players
WHERE playerID = :playerID;

-- -----------------------------------------------------
-- Table `Transfers`
-- -----------------------------------------------------
-- Get all Transfers
SELECT * FROM Transfers;

-- Add a new Transfer
INSERT INTO Transfers (`playerID`, `agentID`, `sellingTeamID`, `buyingTeamID`, `dateOfTransfer`, 
`transferFee`, `newContractLength`, `agentCommissionPercent`)
VALUES (:playerID, :agentID, :sellingTeamID, :buyingTeamID, :dateOfTransfer, :transferFee,
:newContractLength, :agentCommissionPercent);

-- Update an existing Transfer
Update Transfers
SET playerID = :playerID, agentID = :agentID, sellingTeamID = :sellingTeamID, buyingTeamID = :buyingTeamID,
dateOfTransfer = :dateOfTransfer, transferFee = :transferFee, newContractLength = :newContractLength, agentCommissionPercent = :agentCommissionPercent
WHERE transferID = :transferID;


-- -----------------------------------------------------
-- Other Operations
-- -----------------------------------------------------
-- Finding all the Transfers by a specific Agent
SELECT * FROM Transfers
WHERE agentID = :agentID;

-- Finding all the Players with the highest transfer Value
SELECT * FROM Players
INNER JOIN Transfers ON Players.playerID = Transfers.playerID
ORDER BY Transfers.transferFee DESC;

-- Finding all the Agents who have been a part of the highest transfers
SELECT * FROM Agents
INNER JOIN Transfers ON Agents.agentID = Transfers.agentID
ORDER BY Transfers.transferFee DESC;

-- Instead of returning all information, we can just return information specific to the Transfer
SELECT Players.playerFirstName, Players.playerLastName, Players.currentSalary, Players.playerMarketValue, Transfers.transferFee
FROM Players
INNER JOIN Transfers ON Players.playerID = Transfers.playerID
ORDER BY Transfers.transferFee DESC;

-- Find all the Leagues for a specific Team
SELECT TeamsLeagues.leagueName
FROM TeamsLeagues
INNER JOIN Leagues ON Leagues.leagueID = TeamsLeagues.teamID;

-- Find all the Teams for a specific League
SELECT Teams.teamName
FROM Teams
INNER JOIN TeamsLeagues ON Teams.teamID = TeamsLeagues.leagueID;