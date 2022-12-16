--Section 1. DDL
CREATE DATABASE ColonialJourney
USE ColonialJourney
GO

CREATE TABLE Planets(
Id INT IDENTITY PRIMARY KEY,
[Name] VARCHAR(30) NOT NULL
);

CREATE TABLE Spaceports(
Id INT IDENTITY PRIMARY KEY,
[Name] VARCHAR(50) NOT NULL,
PlanetId INT NOT NULL FOREIGN KEY REFERENCES Planets(Id)
);

CREATE TABLE Spaceships(
Id INT IDENTITY PRIMARY KEY,
[Name] VARCHAR(50) NOT NULL,
Manufacturer VARCHAR(30) NOT NULL,
LightSpeedRate INT DEFAULT(0)
);

CREATE TABLE Colonists(
Id INT IDENTITY PRIMARY KEY,
FirstName VARCHAR(20) NOT NULL,
LastName VARCHAR(20) NOT NULL,
Ucn VARCHAR(10) UNIQUE NOT NULL,
BirthDate DATE NOT NULL
);

CREATE TABLE Journeys(
Id INT IDENTITY PRIMARY KEY,
JourneyStart DATETIME NOT NULL,
JourneyEnd DATETIME NOT NULL,
Purpose VARCHAR(11) CHECK(Purpose IN ('Medical', 'Technical', 'Educational', 'Military')),
DestinationSpaceportId INT NOT NULL FOREIGN KEY REFERENCES Spaceports(Id),
SpaceshipId INT NOT NULL FOREIGN KEY REFERENCES Spaceships(Id)
);

CREATE TABLE TravelCards(
Id INT IDENTITY PRIMARY KEY,
CardNumber VARCHAR(10) UNIQUE CHECK(LEN(CardNumber) = 10) NOT NULL,
JobDuringJourney VARCHAR(8) CHECK(JobDuringJourney IN ('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook')),
ColonistId INT NOT NULL FOREIGN KEY REFERENCES Colonists(Id),
JourneyId INT NOT NULL FOREIGN KEY REFERENCES Journeys(Id)
);

--Section 2

--INSERT
INSERT INTO Planets([Name])
VALUES ('Mars'),
('Earth'),
('Jupiter'),
('Saturn');

INSERT INTO Spaceships([Name], Manufacturer, LightSpeedRate)
VALUES ('Golf', 'VW', 3),
('WakaWaka', 'Wakanda', 4),
('Falcon9', 'SpaceX', 1),
('Bed', 'Vidolov', 6);

--UPDATE
SELECT * FROM Spaceships
UPDATE Spaceships
SET LightSpeedRate += 1
WHERE Id BETWEEN 8 AND 12

--DELETE
DELETE FROM TravelCards
WHERE JourneyID BETWEEN 1 AND 3

DELETE FROM Journeys
WHERE Id BETWEEN 1 AND 3

--Section 3
SELECT 
Id,
FORMAT(JourneyStart, 'dd/MM/yyyy') AS JourneyStart,
FORMAT(JourneyEnd, 'dd/MM/yyyy')   AS JourneyEnd
FROM Journeys
WHERE Purpose = 'Military'
ORDER BY JourneyStart;


SELECT
c.Id,
c.FirstName + ' ' + c.LastName AS full_name
FROM Colonists AS c
JOIN TravelCards AS t
ON c.Id = t.ColonistId
WHERE t.JobDuringJourney = 'Pilot'
ORDER BY c.Id;

SELECT 
COUNT(a.ColonistId) AS "Count"
FROM(
SELECT 
t.ColonistId
FROM TravelCards AS t
JOIN Journeys AS j
ON t.JourneyId = j.Id
WHERE j.Purpose = 'Technical') AS a

SELECT
s.[Name],
s.Manufacturer
FROM Spaceships AS s
JOIN Journeys AS j
ON s.Id = j.SpaceshipId
JOIN TravelCards AS t
ON j.ID = t.JourneyId AND t.JobDuringJourney = 'Pilot'
JOIN Colonists AS c
ON t.ColonistId = c.Id
WHERE c.BirthDate >= '1989-01-01'
ORDER BY s.[Name]


SELECT
w.[Name] AS "PlanetName",
COUNT(w.Id) AS JourneysCount
FROM(
SELECT
p.[Name],
j.Id
FROM Planets AS p
JOIN Spaceports AS s
ON p.Id = s.PlanetId
JOIN Journeys AS j
ON j.DestinationSpaceportId = s.Id) AS w
GROUP BY w.[Name]
ORDER BY COUNT(*) DESC, w.[Name]
--OR
SELECT
w.[Name] AS "PlanetName",
COUNT(*) AS JourneysCount
FROM(
SELECT
p.[Name],
j.Id
FROM Planets AS p
JOIN Spaceports AS s
ON p.Id = s.PlanetId
JOIN Journeys AS j
ON j.DestinationSpaceportId = s.Id) AS w
GROUP BY w.[Name]
ORDER BY COUNT(*) DESC, w.[Name]


SELECT
w.JobDuringJourney,
w.FullName,
w.JobRank
FROM
(SELECT
t.JobDuringJourney,
c.FirstName + ' ' + c.LastName AS "FullName",
DENSE_RANK() OVER (PARTITION BY t.JobDuringJourney ORDER BY c.Birthdate) AS JobRank
FROM TravelCards AS t
JOIN Colonists AS c
ON t.ColonistId = c.Id) AS w
WHERE w.JobRank = 2;


GO
CREATE FUNCTION dbo.udf_GetColonistsCount (@PlanetName AS VARCHAR (30))
RETURNS INT
AS
BEGIN
RETURN(
SELECT
COUNT(t.ColonistId) AS "Count"
FROM Planets AS p
JOIN Spaceports AS s
ON p.Id = s.PlanetId
JOIN Journeys AS j
ON j.DestinationSpaceportId = s.Id
JOIN TravelCards AS t
ON t.JourneyId = j.Id
WHERE p.[Name] = @PlanetName)
END;
GO


SELECT dbo.udf_GetColonistsCount('Otroyphus') AS "Output"




GO
CREATE OR ALTER PROC usp_ChangeJourneyPurpose(@JourneyId INT , @NewPurpose VARCHAR(30))
AS
BEGIN TRANSACTION
UPDATE Journeys
SET Purpose = @NewPurpose
WHERE Id = @JourneyId
IF(
SELECT
j.Id
FROM Journeys AS j
WHERE j.Id = @JourneyId) IS NULL
BEGIN
ROLLBACK
RAISERROR('The journey does not exist', 16, 1)
RETURN
END
COMMIT
IF(
SELECT
j.Purpose
FROM Journeys AS j
WHERE j.Id = @JourneyId
) = @NewPurpose
BEGIN
ROLLBACK
RAISERROR('You cannot change the purpose!', 16, 1)
RETURN
END
COMMIT
ELSE
END







EXEC usp_ChangeJourneyPurpose 4, 'Educational'
EXEC usp_ChangeJourneyPurpose 2, 'Educational'
EXEC usp_ChangeJourneyPurpose 196, 'Technical'


--TransactionExample
BEGIN TRANSACTION

INSERT INTO [dbo].[EmployeeRecords] (
	    [EmpID], [FirstName], [LastName], [Education], [Occupation], [YearlyIncome], [Sales])
     VALUES (6, 'Tutorial', 'Gateway', 'Education', 'Learning', 65000, 1400)

UPDATE [dbo].[EmployeeRecords]
	SET [Education] = 'Masters',
	    [YearlyIncome] = 'Wrong Data'
	WHERE [EmpID] = 6
	   
COMMIT TRANSACTION