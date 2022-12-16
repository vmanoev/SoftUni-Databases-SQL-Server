SELECT * FROM WizzardDeposits
-- Problem 1.
SELECT
COUNT(Id) AS [Count]
FROM WizzardDeposits;

-- Problem 2.
SELECT
MAX(MagicWandSize) AS [LongestMagicWand]
FROM WizzardDeposits;

-- Problem 3.
SELECT
DepositGroup,
MAX(MagicWandSize) AS [LongestMagicWand]
FROM WizzardDeposits
GROUP BY DepositGroup;

-- Problem 4.
SELECT TOP 2
DepositGroup,
(AVG(MagicWandSize)) as [LowestAverageWandSize]
FROM WizzardDeposits
GROUP BY DepositGroup
HAVING AVG(MagicWandSize) > 1
ORDER BY [LowestAverageWandSize] ASC

SELECT TOP(2) w.DepositGroup
    FROM WizzardDeposits AS w
GROUP BY w.DepositGroup
ORDER BY AVG(w.MagicWandSize)

-- Problem 5.
SELECT
DepositGroup,
SUM(DepositAmount) AS [Total Sum]
FROM WizzardDeposits
GROUP BY DepositGroup;

-- Problem 6.
SELECT
DepositGroup,
SUM(DepositAmount) AS [Total Sum]
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
HAVING MagicWandCreator = 'Ollivander family';
--OR
SELECT
DepositGroup,
SUM(DepositAmount) AS [Total Sum]
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup, MagicWandCreator

-- Problem 7.
SELECT
DepositGroup,
SUM(DepositAmount) AS [Total Sum]
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY [Total Sum] DESC;

-- Problem 8.
SELECT
	DepositGroup,
	MagicWandCreator,
	MIN(DepositCharge) AS [MinDepositCharge]
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup;

-- Problem 9.
SELECT
w.AgeRange,
COUNT(w.AgeRange) AS Totalnumber
FROM(
SELECT
	CASE 
	WHEN Age <= 10 THEN '[0-10]'
	WHEN Age BETWEEN 11 and 20 THEN '[11-20]'
	WHEN Age BETWEEN 21 and 30 THEN '[21-30]'
	WHEN Age BETWEEN 31 and 40 THEN '[31-40]'
	WHEN Age BETWEEN 41 and 50 THEN '[41-50]'
	WHEN Age BETWEEN 51 and 60 THEN '[51-60]'
	ELSE '[61+]'
	END AS AgeRange
	FROM WizzardDeposits) AS w
GROUP BY w.AgeRange

-- Problem 10.
SELECT DISTINCT
SUBSTRING(a.FirstName, 1,1) AS FirstLetter
FROM(
SELECT
w.FirstName,
w.DepositGroup
FROM WizzardDeposits AS w
GROUP BY w.FirstName, w.DepositGroup
HAVING w.DepositGroup = 'Troll Chest') AS a
ORDER BY FirstLetter;

-- Problem 11.
SELECT
w.DepositGroup,
w.IsDepositExpired,
AVG(w.DepositInterest) AS AverageInterest
FROM WizzardDeposits AS w
WHERE w.DepositStartDate > '01-01-1985'
GROUP BY w.DepositGroup, w.IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired 

-- Problem 12.
SELECT 
    SUM(a.DepositAmount - b.DepositAmount) AS 'sum_difference'
FROM
    WizzardDeposits AS a,
    WizzardDeposits AS b
WHERE
    b.id - a.id = 1;
	

SELECT 
a.FirstName AS "Host_wizard",
a.DepositAmount AS "Host_wizard_amount",
b.FirstName as "Guest_wizard",
b.DepositAmount AS "Guest_wizard_amount",
a.DepositAmount - b.DepositAmount AS "Amount_difference"
FROM WizzardDeposits AS a, WizzardDeposits as b
WHERE b.id - a.id = 1;


-- Problem 13.
USE SoftUni
GO

SELECT
SUM(e.Salary) [TotalSalary],
e.DepartmentID
FROM Employees AS e
GROUP BY e.DepartmentID
ORDER BY e.DepartmentID;

-- Problem 14.
SELECT
e.DepartmentID,
MIN(e.Salary) AS [MinSalary]
FROM Employees AS e
WHERE e.DepartmentID IN (2,5,7) AND e.HireDate > '01-01-2000'
GROUP BY e.DepartmentID

-- Problem 15.
SELECT *
  INTO EmployeesAverageSalaries
  FROM Employees
 WHERE Salary > 30000

DELETE FROM EmployeesAverageSalaries
 WHERE ManagerID = 42

UPDATE EmployeesAverageSalaries
   SET Salary += 5000
 WHERE DepartmentID = 1

  SELECT DepartmentID,
         AVG(Salary) AS [AverageSalary]
    FROM EmployeesAverageSalaries
GROUP BY DepartmentID

-- Problem 16.
SELECT
DepartmentID,
MAX(Salary) AS [MaxSalary]
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000
ORDER BY DepartmentID;

-- Problem 17.
SELECT
COUNT(e.Salary) AS "Count"
FROM Employees AS e
WHERE e.ManagerID IS NULL;

-- Problem 18.
SELECT TOP 1 c.SALARY
FROM(
SELECT TOP 3 SALARY
FROM Employees
ORDER BY SALARY DESC) AS C
ORDER BY SALARY ASC;


SELECT DISTINCT s.[DepartmentID],
       s.[Salary]
  FROM (SELECT DepartmentId, 
               Salary,
		       DENSE_RANK() OVER (PARTITION BY DepartmentId ORDER BY Salary DESC)
	        AS [RowNum]
          FROM Employees) AS s
 WHERE s.[RowNum] = 3


SELECT 
    e.DepartmentID,
    MAX(e.salary) AS [third_highest_salary]
FROM
    Employees AS e
        JOIN
    (SELECT 
        e.DepartmentID, MAX(e.salary) AS max_salary
    FROM
        Employees AS e
    JOIN (SELECT 
        e.DepartmentID, MAX(e.salary) AS max_salary
    FROM
        Employees AS e
    GROUP BY e.DepartmentID) AS first_max_salary ON e.DepartmentID = first_max_salary.DepartmentID
    WHERE
        e.Salary < first_max_salary.max_salary
    GROUP BY e.DepartmentID) AS second_max_salary ON e.DepartmentID = second_max_salary.DepartmentID
WHERE
    e.Salary < second_max_salary.max_salary
GROUP BY e.DepartmentID
ORDER BY e.DepartmentID


-- Problem 19.
 SELECT TOP 10
 FirstName,
 LastName,
 DepartmentID
 FROM Employees
 WHERE Salary > (
 SELECT
 AVG(Salary) AS "Average Salary"
 FROM Employees)
 ORDER BY DepartmentID
 
 --OR

 SELECT TOP 10
    e.Firstname, e.Lastname, e.DepartmentID
FROM
    Employees AS e
        JOIN
    (SELECT 
        departmentID, AVG(Salary) AS "dep_avg_salary"
    FROM
        Employees
    GROUP BY DepartmentID) AS a 
	ON e.departmentid = a.departmentid
WHERE
    Salary > a.dep_avg_salary
ORDER BY DepartmentID


--#Personal_Training

--From the employees table, write a SQL query to find those employees who receive a higher salary than the employee with ID 163. Return first name, last name.

SELECT 
FirstName,
LastName
FROM Employees
WHERE Salary > (
SELECT
Salary
FROM Employees
WHERE EmployeeID = 163);

--From the employees table, write a SQL query to find out which employees have the same designation as the employee whose ID is 169. Return first name, last name, department ID and job ID.
SELECT
FirstName,
LastName,
DepartmentID,
JobTitle
FROM Employees
WHERE JobTitle = (
SELECT
JobTitle
FROM Employees
WHERE EmployeeID = 169)

--From the employees table, write a SQL query to find those employees whose salary matches the lowest salary of any of the departments. Return first name, last name, salary and department ID.
SELECT
FirstName,
LastName,
DepartmentID,
Salary
FROM Employees
WHERE Salary IN
(SELECT
MIN(Salary)
FROM Employees
GROUP BY DepartmentID);

--From the following table, write a SQL query to find those employees who earn more than the average salary. Return employee ID, first name, last name
SELECT
FirstName,
LastName,
EmployeeID
FROM Employees
WHERE Salary >(
SELECT AVG(Salary)
FROM Employees)
ORDER BY EmployeeID

--From the following table, write a SQL query to find those employees who report to that manager whose first name is ‘Payam’. Return first name, last name, employee ID and salary
SELECT
FirstName,
LastName,
EmployeeID,
Salary
FROM Employees
WHERE ManagerID = (
SELECT
EmployeeID
FROM Employees
WHERE FirstName = 'Jo');

--From the employees and departments table, write a SQL query to find all those employees who work in the Finance department. Return department ID, name (first name), last name, job title and department name
--Декартово сечение
SELECT e.DepartmentID, e.FirstName, e.LastName, e.JobTitle , d.[Name]
FROM Employees e , Departments d  
WHERE e.departmentid = d.departmentid  
AND  d.[Name] = 'Finance';


--From the employees table, write a SQL query to find those employees whose ID matches any of the numbers 134, 159 and 183. Return all the fields.
SELECT *
FROM Employees
WHERE EmployeeID IN (134,159,183)

--From the following table write a SQL query to find those employees whose salary falls within the range of the smallest salary and 25000. Return all the fields
SELECT * 
FROM employees 
WHERE salary BETWEEN  
(SELECT MIN(salary) 
FROM employees) AND 25000;

--From the following tables, write a SQL query to find those employees who do not work in the departments where managers’ IDs are between 100 and 200 (Begin and end values are included.)
--Return all the fields of the employees' table
SELECT * 
FROM employees 
WHERE departmentid NOT IN 
(SELECT departmentid 
FROM departments 
WHERE managerid BETWEEN 100 AND 200);

SELECT *
FROM Employees AS e
JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID AND d.ManagerID NOT BETWEEN 100 and 200

--From the following table, write a SQL query to find those employees who get second-highest salary. Return all the fields of the employees

SELECT TOP 1 Salary
FROM
(
SELECT TOP 2
Salary
FROM Employees
ORDER BY Salary DESC) as C
ORDER BY Salary ASC;


SELECT
*
FROM Employees
WHERE Salary = (
SELECT
MAX(Salary) as "MaxSalary"
FROM Employees)
OR
Salary = (
SELECT
MIN(Salary) as "MinSalary"
FROM Employees)

SELECT
*
FROM Employees
WHERE Salary = (
SELECT
MAX(Salary) as "MaxSalary"
FROM Employees 
WHERE Salary NOT IN (
SELECT MAX(SALARY) FROM Employees))
