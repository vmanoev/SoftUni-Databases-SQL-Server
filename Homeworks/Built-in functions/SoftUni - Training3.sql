-- Problem 1.
USE SoftUni
GO

SELECT
FirstName,
LastName
FROM Employees
WHERE FirstName LIKE 'SA%';

-- Problem 2.
SELECT
FirstName,
LastName
FROM Employees
WHERE LastName LIKE '%ei%';

-- Problem 3.
SELECT
FirstName
FROM Employees
WHERE YEAR(HireDate) BETWEEN 1995 AND 2005 AND DepartmentID IN (3,10);

-- Problem 4.
SELECT 
FirstName,
LastName
FROM Employees
WHERE JobTitle <> 'Engineer';

-- Problem 5.
 SELECT 
 [Name]
 FROM Towns
 WHERE LEN([Name]) BETWEEN 5 and 6
 ORDER BY [Name] ASC;  
--alphabetically 

 -- Problem 6.
 SELECT *
    FROM Towns
   WHERE [Name] LIKE '[MKBE]%'
ORDER BY [Name];
--OR
 SELECT
 TownID,
 [Name]
 FROM Towns
 WHERE [Name] LIKE 'M%' OR [Name] LIKE 'K%' OR [Name] LIKE 'B%' OR [Name] LIKE 'E%'
 ORDER BY [Name];

 -- Problem 7.
   SELECT *
    FROM Towns
   WHERE [Name] NOT LIKE '[RBD]%'
ORDER BY [Name]
--OR
  SELECT
 TownID,
 [Name]
 FROM Towns
 WHERE [Name] NOT LIKE 'R%' OR [Name] LIKE 'B%' OR [Name] LIKE 'D%'
 ORDER BY [Name];

 -- Problem 8.
 CREATE VIEW V_EmployeesHiredAfter2000 AS
 SELECT
 FirstName,
 LastName
 FROM Employees
 WHERE YEAR(HireDate) > 2000;

 SELECT * FROM V_EmployeesHiredAfter2000

 -- Problem 9.
 SELECT
 FirstName,
 LastName
 FROM Employees
 WHERE LEN(LastName) = 5;

 -- Problem 10.
 SELECT
 EmployeeID,
 FirstName,
 LastName,
 Salary,
 DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS Rank
 FROM Employees
 WHERE Salary BETWEEN 10000 and 50000
 ORDER BY Salary DESC;
 
 -- Problem 11.
  SELECT * FROM(
  SELECT
 EmployeeID,
 FirstName,
 LastName,
 Salary,
 DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS Rank
 FROM Employees
 WHERE Salary BETWEEN 10000 and 50000
 ) AS Ee
 WHERE Ee.[Rank] = 2
 ORDER BY Ee.Salary DESC

 -- Problem 12.
 USE Geography
 GO

 SELECT
 CountryName,
 IsoCode
 FROM Countries
 WHERE CountryName LIKE '%a%a%a'
 ORDER BY IsoCode;

 --Problem 13.
SELECT 
    PeakName,
    RiverName,
    LOWER(CONCAT(PeakName,RiverName)) AS 'mix'
FROM
    Peaks,
    Rivers
WHERE
    LOWER(RIGHT(PeakName, 1)) = LOWER(LEFT(RiverName, 1))
ORDER BY mix;

SELECT RIGHT('SQL Tutorial', 3) AS ExtractString;

--Problem 14.
USE DIABLO 
GO

SELECT TOP 50
[Name],
FORMAT([Start], 'dd-MM-yyyy') AS [Start_Date]
FROM Games
WHERE YEAR([Start]) BETWEEN 2011 AND 2012
ORDER BY [Start], [Name];

-- Problem 15.
SELECT 
Username,
SUBSTRING(Email,CHARINDEX('@', Email)+1 , LEN(Email)) AS [Email Provider]
FROM Users
ORDER BY Email, Username

SELECT SUBSTRING('SQL Tutorial', 1, 3) AS ExtractString;
SELECT CHARINDEX('t', 'Customer') AS MatchPosition;

-- Problem 16.
SELECT
Username,
IpAddress
FROM Users
WHERE IpAddress LIKE '___.1_%._%.___'
ORDER BY Username

--Problem 17.
SELECT [Name] AS Game,
CASE WHEN DATEPART(HOUR, [Start]) >= 0 
AND DATEPART(HOUR, [Start]) < 12 THEN 'Morning'
WHEN DATEPART(HOUR, [Start]) >= 12 
AND DATEPART(HOUR, [Start]) < 18 THEN 'Afternoon'
WHEN DATEPART(HOUR, [Start]) >= 18 
AND DATEPART(HOUR, [Start]) < 24 THEN 'Evening'
ELSE NULL
END AS [Part of the day],
CASE WHEN Duration <= 3 THEN 'Extra Short'
WHEN Duration >= 4 AND Duration <=6 THEN 'Short'
WHEN Duration > 6 THEN 'Long'
ELSE 'Without duration'
END AS Duration
FROM Games 
ORDER BY [Name] ,Duration, [Part of the day]

SELECT DATEPART(year, '2017/08/25') AS DatePartInt;

-- Problem 18.
GO
USE Orders;

SELECT
ID,
ProductName,
OrderDate,
DATEADD(DAY, 3, OrderDate) AS [Pay Due],
DATEADD (MONTH, 1, OrderDate) AS [Deliver Due]
FROM Orders

SELECT DATEADD(year, 3, '2017/08/25') AS "DateAdd";

--Problem 19.
CREATE TABLE People(
Id INT PRIMARY KEY NOT NULL,
[Name] NVARCHAR(100) NOT NULL,
Birthdate DATETIME NOT NULL)

INSERT INTO People(Id, [Name], Birthdate)
VALUES
(1, 'Victor', '2000-12-07 00:00:00'),
(2, 'Steven', '1992-09-10 00:00:00'),
(3, 'Stephen', '1910-09-19 00:00:00'),
(4, 'John', '2010-01-06 00:00:00');

SELECT
[Name],
DATEDIFF(YEAR, Birthdate, GETDATE()) AS [Age in years],
DATEDIFF(MONTH, Birthdate, CURRENT_TIMESTAMP) AS [Age in months],
DATEDIFF(DAY, Birthdate, SYSDATETIME()) AS [Age in days],
DATEDIFF(MINUTE, Birthdate, CURRENT_TIMESTAMP) AS [Age in minutes]
FROM People;

--SYSDATETIME(),GETDATE(),SYSDATETIMEOFFSET()
