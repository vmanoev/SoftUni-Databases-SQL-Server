--Problem 1.
SELECT TOP 5
e.EmployeeID,
e.JobTitle,
a.AddressId,
a.AddressText
FROM Employees e
JOIN Addresses a on e.EmployeeID = a.AddressID
ORDER BY a.AddressID;

SELECT TOP 5
e.EmployeeID,
e.JobTitle,
a.AddressId,
a.AddressText
FROM Employees e
JOIN Addresses a on e.AddressID = a.AddressID
ORDER BY a.AddressID;

--Problem 2.
SELECT TOP 50
e.FirstName,
e.LastName,
t.[Name] AS "Town",
a.AddressText
FROM Employees AS e
JOIN Addresses a
ON a.AddressID = e.AddressID
JOIN Towns AS t
ON a.TownID = t.TownID
ORDER BY e.FirstName, e.LastName;

--Problem 3.
SELECT
e.EmployeeID,
e.FirstName,
e.LastName,
d.[Name] AS "Department Name"
FROM Employees AS e
JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID AND d.[Name] = 'Sales'
ORDER BY e.EmployeeID;


--Problem 4.

SELECT TOP 5
e.EmployeeID,
e.FirstName,
e.Salary,
d.[Name] AS "Department Name"
FROM Employees AS e
JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID AND e.Salary > 15000
ORDER BY e.DepartmentID;

--Problem 5.
SELECT TOP 3
e.EmployeeID,
e.FirstName
FROM Employees AS e
LEFT JOIN EmployeesProjects AS p
ON e.EmployeeID = p.EmployeeID 
WHERE p.EmployeeID IS NULL AND p.ProjectID IS NULL
ORDER BY e.EmployeeID;

--Problem 6.
SELECT
e.FirstName,
e.LastName,
e.HireDate,
d.[Name] AS "Department Name"
FROM Employees AS e
JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID AND d.[Name] IN ('Sales', 'Finance')
WHERE e.HireDate > '01-01-1999'
ORDER BY e.HireDate;

--Problem 7.
SELECT TOP 5
e.EmployeeID,
e.FirstName,
pp.[Name] AS "Project Name"
FROM Employees AS e
JOIN EmployeesProjects AS p
ON e.EmployeeID = p.EmployeeID
JOIN Projects AS pp
ON p.ProjectID = pp.ProjectID
WHERE pp.StartDate > '2002-08-13' AND pp.EndDate IS NULL
ORDER BY e.EmployeeID
;

--Problem 8.
SELECT
e.EmployeeID,
e.FirstName,
CASE WHEN pp.StartDate >=CAST('2005' AS DATETIME) THEN NULL
ELSE pp.[Name]
END AS [ProjectName]
FROM Employees AS e
JOIN EmployeesProjects p
ON e.EmployeeID = p.EmployeeID AND e.EmployeeID = 24
JOIN Projects pp
ON p.ProjectID = pp.ProjectID;


--Problem 9.
SELECT
e.EmployeeID,
e.FirstName,
e.ManagerID,
ee.FirstName AS "ManagerName"
FROM Employees AS e
JOIN Employees AS ee
ON e.ManagerID = ee.EmployeeID
WHERE e.ManagerID IN (3,7)
ORDER BY e.EmployeeID;

--Problem 10.
SELECT TOP 50
e.EmployeeID,
e.FirstName + ' ' + e.LastName AS "EmployeName",
ee.FirstName + ' ' + ee.LastName AS "ManagerName",
d.[Name] AS "DepartmentName"
FROM Employees AS e
JOIN Employees AS ee
ON e.ManagerID = ee.EmployeeID
JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID;


--Problem 11.
SELECT
MIN(d.AverageSalary) AS "MinAverageSalary"
FROM(
SELECT AVG(Salary) AS "AverageSalary"
FROM Employees
GROUP BY DepartmentID) AS d;

--Problem 12.
SELECT
c.CountryCode,
m.MountainRange,
p.PeakName,
p.Elevation
FROM MountainsCountries AS c
JOIN Mountains AS m
ON c.MountainId = m.ID AND c.CountryCode = 'BG'
JOIN Peaks as p
ON m.ID = p.MountainId AND p.Elevation > 2835
ORDER BY p.Elevation DESC;

--Problem 13.
SELECT
m.CountryCode,
COUNT(ms.MountainRange) AS "MountainRanges"
FROM MountainsCountries AS m
JOIN Mountains AS ms
ON m.MountainId = ms.ID AND m.CountryCode IN ('US', 'RU', 'BG')
GROUP BY m.CountryCode;

--Problem 14.
SELECT TOP 5
c.CountryName,
r.RiverName
FROM Countries AS c
LEFT JOIN CountriesRivers AS cs
ON c.CountryCode = cs.CountryCode         
LEFT JOIN Rivers AS r
ON cs.RiverId = r.ID
WHERE c.ContinentCode = 'AF'
ORDER BY CountryName;


--Problem 15.
  SELECT k.ContinentCode,
         k.CurrencyCode,
         k.CurrencyUsage
    FROM (SELECT [cont].ContinentCode,
         [count].CurrencyCode,
		 COUNT([count].CurrencyCode)
	  AS [CurrencyUsage],
	     DENSE_RANK() OVER (PARTITION BY [cont].ContinentCode ORDER BY COUNT([count].CurrencyCode) DESC)
      AS [Rank]
    FROM Countries AS [count]
    JOIN Continents AS [cont]
      ON [cont].ContinentCode = [count].ContinentCode
GROUP BY [cont].ContinentCode,
         [count].CurrencyCode) AS k
WHERE k.[Rank] = 1
  AND k.CurrencyUsage != 1
ORDER BY k.ContinentCode;
I
--Problem 16.
SELECT COUNT(d.CountryCode) AS [Count]
FROM
(SELECT c.CountryCode
FROM Countries AS c
LEFT JOIN MountainsCountries AS ms
ON c.CountryCode = ms.CountryCode
LEFT JOIN Mountains AS m
ON ms.MountainId = m.Id
WHERE m.Id IS NULL
GROUP BY c.CountryCode) AS d;

--Problem 17.
SELECT TOP(5) c.CountryName,
MAX(p.Elevation) AS "HighestPeekElevation",
MAX(r.[Length]) AS "LongestRiverLength"
FROM Countries AS c
FULL JOIN MountainsCountries AS mc
ON mc.CountryCode = c.CountryCode
FULL JOIN Mountains AS m
ON m.Id = mc.MountainId
FULL JOIN Peaks AS p
ON p.MountainId = m.Id
FULL JOIN CountriesRivers AS cr
ON cr.CountryCode = c.CountryCode 
FULL JOIN Rivers AS r
ON r.Id = cr.RiverId
GROUP BY c.CountryName
ORDER BY
HighestPeekElevation DESC,
LongestRiverLength DESC, 
c.CountryName

--Problem 18.
   SELECT TOP(5) 
          k.Country,
          ISNULL(k.PeakName, '(no highest peak)') 
       AS [Highest Peak Name],
	  ISNULL(k.[Highest Peak Elevation], 0) 
       AS [Highest Peak Elevation],
          ISNULL(k.MountainRange, '(no mountain)') 
       AS [Mountain]
     FROM (   SELECT c.CountryName AS [Country],
           	     p.PeakName,
                     MAX(p.Elevation) AS [Highest Peak Elevation],
           	     m.MountainRange,
           	     DENSE_RANK() OVER (PARTITION BY c.CountryName ORDER BY MAX(p.Elevation) DESC)
           	  AS [Rank]
                FROM Countries AS c
           LEFT JOIN MountainsCountries AS mc
                  ON mc.CountryCode = c.CountryCode
           LEFT JOIN Mountains AS m
                  ON m.Id = mc.MountainId
           LEFT JOIN Peaks AS p
                  ON p.MountainId = m.Id
            GROUP BY c.CountryName,
           	     p.PeakName,
           	     m.MountainRange) AS k
    WHERE k.[Rank] = 1
 ORDER BY k.Country, [Highest Peak Name]



