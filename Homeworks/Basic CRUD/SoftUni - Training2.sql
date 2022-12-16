
SELECT FirstName + ' ' + LastName FROM Employees AS [FullName]
SELECT CONCAT(FirstName, ' ', LastName) FROM Employees
SELECT CONCAT_WS(' ', FirstName, LastName) FROM Employees

--View syntax
CREATE VIEW v_EmployeesSalaryInfo AS
SELECT 
FirstName + ' ' + LastName as [FullName],
Salary
FROM Employees


SELECT FirstName, LastName, JobTitle
INTO Myfiredemployees
FROM Employees
-- creates a new table directly from employees without constraints transfer

-- example of syntax for Identtiy SET IDENTITY_INSERT Towns ON
-- CREATE SEQUENCE seq_Customers_CustomerID 
   AS INT
   START WITH 1
   INCREMENT BY 1
   SELECT NEXT VALUE FOR seq_Customers_CustomerID
   MINVALUE 10
   MAXVALUE 10, 50 
   CYCLE
   -- UPDATE Addresses
   SET TownID IS NULL  
   WHERE TownID = 1
   DDL , DML
   ALTER, UPDATE
   CTRL+K+C to comment
   CTRL+R to close results window

  --used to change databases
GO
Use SoftUni;

  -- Problem 2
   SELECT *
   FROM Departments;
   
  -- Problem 3.
   SELECT [Name]
   FROM Departments;

  -- Problem 4.
   SELECT
   FirstName,
   LastName,
   Salary
   FROM Employees;
   
 -- Problem 5.
 SELECT
 FirstName,
 MiddleName,
 LastName
 FROM Employees;

 -- Problem 6.
 SELECT
 FirstName + '' + '.' + LastName + '@softuni.bg'  AS full_email_address  
 FROM Employees;


 SELECT
 CONCAT(FirstName, '.', LastName, '@softuni.bg') AS full_email_address1
 FROM Employees;

-- Problem 7.
SELECT DISTINCT
Salary	
FROM Employees;

-- Problem 8.
SELECT *
FROM Employees
WHERE JobTitle = 'Sales Representative';

-- Problem 9.
SELECT
FirstName,
LastName,
JobTitle
FROM Employees
WHERE Salary BETWEEN 20000 and 30000;

-- Problem 10.
SELECT
FirstName + ' ' + MiddleName + ' ' + LastName AS [Full Name]
FROM Employees
WHERE Salary IN(25000, 14000, 12500, 23600);

SELECT
CONCAT_WS(' ', FirstName, MiddleName, LastName) AS 'Fullname'
FROM Employees
WHERE Salary IN(25000, 14000, 12500, 23600);
--CONCAT_WS(separator, expression1, ....)

-- Problem 11.
SELECT
FirstName,
LastName
FROM Employees
WHERE ManagerID is NULL;

-- Problem 12.
SELECT
FirstName,
LastName,
Salary
FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC;

-- Problem 13.
SELECT TOP 5
FirstName,
LastName
FROM Employees
ORDER BY Salary DESC;

-- SELECT * FROM Customers LIMIT 3; used in Orcale, PostgreSQL / SELECT * FROM Customers FETCH FIRST 2 ROWS ONLY/ TOP(X) SQL Server

-- Problem 14.
SELECT
FirstName,
LastName
FROM Employees
WHERE DepartmentID != 4; / <> = !=

-- Problem 15.
SELECT *
FROM Employees
ORDER BY Salary DESC, FirstName, LastName DESC, MiddleName;

-- Problem 16.
CREATE VIEW V_employeessalaries AS
SELECT
FirstName,
LastName,
Salary
FROM Employees;

--Test view
SELECT * FROM V_employeessalaries

-- Problem 17.
CREATE VIEW V_EmployeeNameJobTitle AS
SELECT 
        CONCAT(FirstName,
                ' ',
                ISNULL(MiddleName, ''),
                ' ',
                LastName) AS 'Full Name',
        JobTitle
    FROM
        Employees;
--OR
CREATE VIEW v_EmployeeNameJobTitle2 AS
 SELECT
 CONCAT_WS(' ', FirstName, ISNULL(MiddleName, ''), LastName) AS [FullName],
 JobTitle
 FROM Employees

SELECT * FROM V_EmployeeNameJobTitle
--NULLIF, ISNULL 

-- Problem 18.
SELECT DISTINCT
Jobtitle
FROM Employees
ORDER BY JobTitle;

-- Problem 19.
SELECT TOP 10
ProjectID,
[Name],
[Description],
StartDate,
EndDate
FROM Projects
ORDER BY StartDate, [Name];

-- Problem 20.
SELECT TOP 7
FirstName,
LastName,
HireDate
FROM Employees
ORDER BY HireDate DESC;

-- Problem 21.
UPDATE Employees
   SET Salary += Salary * 0.12
   --SET Salary *= 1.12
 WHERE DepartmentID IN (1, 2, 4, 11)

SELECT Salary
  FROM Employees

-- Problem 22.
GO
USE Geography;

SELECT
PeakName
FROM Peaks
ORDER BY PeakName ASC;

-- Problem 23.

SELECT TOP 30
CountryName,
[Population]
FROM Countries
WHERE ContinentCode = 'EU'
ORDER BY 'Population' DESC, CountryName;

-- Problem 24.
SELECT
CountryName,
CountryCode,
CASE WHEN CurrencyCode = 'EUR' THEN 'Euro'
ELSE 'Not Euro'
END AS Currency
FROM Countries
ORDER BY CountryName;

-- Problem 25.
GO
USE Diablo
SELECT [Name]
FROM Characters
ORDER BY [Name]