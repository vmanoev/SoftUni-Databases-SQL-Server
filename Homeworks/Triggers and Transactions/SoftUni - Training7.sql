-- Problem 1.
USE SoftUni
GO

CREATE PROC usp_GetEmployeesSalaryAbove35000 
AS
BEGIN
SELECT 
e.FirstName,
e.LastName
FROM Employees AS e
WHERE e.Salary > 35000
END;

EXEC usp_GetEmployeesSalaryAbove35000

--Problem 2.
CREATE PROC usp_GetEmployeesSalaryAboveNumber(@number DECIMAL(18,4))
AS
BEGIN
SELECT
e.FirstName,
e.LastName
FROM Employees AS e
WHERE e.Salary >= @number
END;

EXEC usp_GetEmployeesSalaryAboveNumber @number = 48100

--Problem 3.
CREATE PROC usp_GetTownsStartingWith(@startingLetter NVARCHAR(MAX))
AS
BEGIN
SELECT
t.[Name]
FROM Towns AS t
WHERE LEFT(t.[Name], LEN(@startingLetter)) = @startingLetter
END;

EXEC usp_GetTownsStartingWith @StartingLetter = 'b'
--OR

CREATE PROC usp_GetTownsStartingWith1 (@startingLetter NVARCHAR(MAX))
AS
BEGIN
SELECT
t.[Name]
FROM Towns AS t
WHERE LEFT(t.[Name], 1) = @startingLetter
END

EXEC usp_GetTownsStartingWith1 @StartingLetter = 'c'

--Problem 4.
CREATE PROC usp_GetEmployeesFromTown(@Town NVARCHAR(MAX))
AS
BEGIN
SELECT 
e.FirstName,
e.LastName
FROM Employees AS e
JOIN Addresses AS a
ON a.AddressID = e.AddressID
JOIN Towns AS t
ON t.TownID = a.TownID
WHERE t.[Name] = @town
END;

EXEC usp_GetEmployeesFromTown @Town = 'Sofia'

Syntax
--CREATE PROCEDURE SelectAllCustomers @City nvarchar(30), @PostalCode nvarchar(10)
--AS BEGIN
--SELECT * FROM Customers WHERE City = @City AND PostalCode = @PostalCode
--GO;

--Problem 5.
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE @SalaryLevel NVARCHAR(10)
IF (@salary < 30000)
BEGIN
SET @SalaryLevel = 'Low'
END
ELSE IF (@Salary BETWEEN 30000 AND 50000)
BEGIN
SET @SalaryLevel = 'Average'
END 
ELSE
SET @SalaryLevel = 'High'
RETURN @SalaryLevel
END;

--Testing
SELECT DISTINCT
Salary,
dbo.ufn_GetSalaryLevel(Salary) AS SalaryLevel
FROM Employees
WHERE Salary BETWEEN 13000 AND 23000


--Problem 6.
CREATE PROC usp_EmployeesBySalaryLevel(@Salarylevel NVARCHAR(10))
AS
BEGIN
SELECT
e.FirstName,
e.LastName
FROM Employees AS e
WHERE dbo.ufn_GetSalaryLevel(e.Salary) = @Salarylevel
END;

EXEC usp_EmployeesBySalaryLevel @Salarylevel = 'High'


--Problem 7.
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters NVARCHAR(MAX), @word NVARCHAR(MAX))
RETURNS BIT
AS
BEGIN
DECLARE @counter INT = 1;
DECLARE @currentLetter CHAR;
WHILE (@counter <= LEN(@word))
BEGIN
SET @currentLetter = SUBSTRING(@Word, @counter, 1)
DECLARE @charIndex INT = CHARINDEX(@currentLetter, @setOfLetters);
IF (@charIndex <= 0)
BEGIN
RETURN 0;
END
SET @counter +=1;
END
RETURN 1;
END

-- Problem 8.
CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
BEGIN
DELETE FROM EmployeesProjects
WHERE EmployeeID IN (
SELECT EmployeeID
FROM Employees
WHERE DepartmentID = @departmentId)

UPDATE Employees
SET ManagerID = NULL
WHERE ManagerID IN (
SELECT EmployeeID
FROM Employees
WHERE DepartmentID = @departmentId)

ALTER TABLE Departments
ALTER COLUMN ManagerID INT

UPDATE Departments
SET ManagerID = NULL
WHERE DepartmentID = @departmentId

DELETE FROM Employees
WHERE DepartmentID = @departmentId

DELETE FROM Departments
WHERE DepartmentID = @departmentId

SELECT COUNT(*)
FROM Employees
WHERE DepartmentID = @departmentId
END;

--Problem 9.
USE Bank
GO

CREATE PROC usp_GetHoldersFullName
AS
BEGIN
SELECT
CONCAT(ah.FirstName, ' ', ah.LastName) AS "Fullname"
FROM AccountHolders AS ah
END;

EXEC dbo.usp_GetHoldersFullName

--Problem 10.
CREATE PROC usp_GetHoldersWithBalanceHigherThan(@number DECIMAL(15,2))
AS
BEGIN
SELECT
ah.FirstName,
ah.LastName
FROM AccountHolders AS ah
JOIN Accounts a
ON ah.ID = a.AccountHolderID
GROUP BY ah.FirstName, ah.LastName
HAVING SUM(a.Balance) > @number
ORDER BY ah.FirstName, ah.LastName
END;

EXEC dbo.usp_GetHoldersWithBalanceHigherThan @number = 100000


--Extra exercise
CREATE FUNCTION ufn_Circle(@Radius INT)
RETURNS real
AS
BEGIN
DECLARE @Area real
SET @Area = 3.14*@Radius*@Radius
RETURN @Area
END;

SELECT [dbo].ufn_Circle(6) AS "Area"
BEGIN
DECLARE
@area real
EXEC @area=[dbo].ufn_Circle @Radius=6
print(@area)
END;

--Extra exercise
CREATE FUNCTION ufn_Temperature(@Celcius real)
RETURNS real
AS
BEGIN
DECLARE @Fahrenheit real
SET @Fahrenheit = (@Celcius *9/5) + 32
RETURN @Fahrenheit
END;

SELECT [dbo].ufn_Temperature(21) AS "Fahrenheit"
BEGIN
DECLARE @Fahrenheit real
EXEC @Fahrenheit = [dbo].ufn_Temperature @Celcius = 21
print @Fahrenheit
END;


--Problem 11.
CREATE FUNCTION ufn_CalculateFutureValue (@Sum DECIMAL(15,2), @InterestRate FLOAT, @numberOfYears INT)
RETURNS DECIMAL(15,4)
AS
BEGIN
DECLARE @finalresult DECIMAL(15,4)
SET @finalresult = @Sum * (POWER((1+ @InterestRate), @numberOfYears))
RETURN @finalresult
END;

SELECT [dbo].ufn_CalculateFutureValue(1000, 0.1, 5) AS "Output"

--Problem 12.
CREATE PROC usp_CalculateFutureValueForAccount(@AccountID INT, @InterestRate FLOAT)
AS
BEGIN
SELECT
ah.ID AS [Account Id], 
ah.FirstName AS "First Name",
ah.LastName AS "Last Name",
a.Balance AS [Current Balance],
dbo.ufn_CalculateFutureValue(a.Balance, @InterestRate, 5) AS [Balance in 5 years]
FROM AccountHolders ah
JOIN Accounts a
ON ah.ID = a.AccountHolderID
WHERE a.ID = @AccountID
END;

SELECT * FROM ACCOUNTS
SELECT * FROM AccountHolders

--Problem 13.
CREATE FUNCTION ufn_CashInUsersGames (@gameName NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN 
SELECT SUM(r.Cash) AS [SumCash]
FROM (SELECT 
g.[Name],
us.Cash,
ROW_NUMBER() OVER (PARTITION BY @gameName ORDER BY us.Cash DESC) AS [Row Number]
FROM Games AS g
          JOIN UsersGames AS us
            ON us.GameId = g.Id
WHERE g.[Name] = @gameName) AS r
WHERE r.[Row Number] % 2 != 0

--Problem 14.
CREATE TABLE Logs
(LogId INT PRIMARY KEY IDENTITY NOT NULL,
AccountId INT FOREIGN KEY REFERENCES Accounts(Id),
OldSum DECIMAL(15,2),
NewSum DECIMAL(15,2));


CREATE TRIGGER tr_AccountChanges ON Accounts FOR UPDATE
AS
BEGIN
DECLARE @AccountID INT;
DECLARE @OldSum DECIMAL(15,2);
DECLARE @NewSum DECIMAL(15,2);

SET @AccountID = (SELECT i.Id
FROM inserted AS i)

SET @OldSum = (SELECT d.Balance
FROM deleted AS d)

SET @NewSum = (SELECT i.Balance
FROM inserted AS i)

INSERT INTO Logs(AccountId, OldSum, NewSum)
VALUES (@AccountID, @OldSum, @NewSum)
END;


--Problem 15.

CREATE TRIGGER tr_NewEmail ON Logs FOR INSERT
AS
BEGIN

DECLARE @Recipient INT
DECLARE @Subject VARCHAR(200)
DECLARE @OldBalance DECIMAL(15,2)
DECLARE @NewBalance DECIMAL(15,2)
DECLARE @Body VARCHAR(200)

SET @Recipient = (SELECT i.AccountID FROM inserted AS i)
SET @Subject = 'Balance change for account: ' + CAST(@Recipient AS VARCHAR(MAX))
SET @OldBalance = (SELECT i.OldSum FROM inserted AS i)
SET @NewBalance = (SELECT i.NewSum FROM inserted as i)
SET @Body = 'On' + CAST(GETDATE() AS VARCHAR(MAX)) + 'your balance was changed from' +
CAST(@OldBalance AS VARCHAR(MAX)) + 'to' + CAST(@NewBalance AS VARCHAR(MAX))

INSERT INTO NotificationEmails(Recipient, [Subject], Body)
VALUES(@Recipient, @Subject, @Body)

END;

--Problem 16.
GO
CREATE PROC usp_DepositMoney (@AccountId INT , @MoneyAmount DECIMAL(15,4))
AS
BEGIN TRANSACTION
IF (@MoneyAmount < 0 OR @MoneyAmount IS NULL)
BEGIN
ROLLBACK
RAISERROR('Invalid amount of money', 16, 1)
RETURN
END

IF (NOT EXISTS(
SELECT a.Id FROM Accounts AS a
WHERE a.Id = @AccountId))
BEGIN
ROLLBACK
RAISERROR('Invalid accountId', 16, 2)
RETURN
END

UPDATE Accounts
SET Balance += @MoneyAmount
WHERE Id = @AccountId
COMMIT;

--Problem 17.
CREATE PROC usp_WithdrawMoney (@AccountId INT , @MoneyAmount DECIMAL(15,4))
AS
BEGIN TRANSACTION
IF (@MoneyAmount < 0 OR @MoneyAmount IS NULL)
BEGIN
ROLLBACK
RAISERROR('Invalid amount of money', 16, 1)
RETURN
END

IF (NOT EXISTS(
SELECT a.Id FROM Accounts AS a
WHERE a.Id = @AccountId) OR @AccountId IS NULL)
BEGIN
ROLLBACK
RAISERROR('Invalid accountId', 16, 2)
RETURN
END

UPDATE Accounts
SET Balance -= @MoneyAmount
WHERE Id = @AccountId
COMMIT;



--Problem 18.
CREATE PROC usp_TransferMoney(@senderId INT, @receiverId INT, @amount DECIMAL(15, 4))
AS
BEGIN TRANSACTION
	IF (@amount < 0 OR @amount IS NULL)
	BEGIN
		ROLLBACK
		RAISERROR('Invalid amount of money', 16, 1)
		RETURN
	END

	IF (NOT EXISTS(
		SELECT * FROM Accounts a
		WHERE a.Id = @senderId OR @senderId IS NULL))
	BEGIN
		ROLLBACK
		RAISERROR('Invalid senderId', 16, 2)
		RETURN
	END

	IF (NOT EXISTS(
		SELECT * FROM Accounts a
		WHERE a.Id = @receiverId) OR @receiverId IS NULL)
	BEGIN
		ROLLBACK
		RAISERROR('Invalid receiverId', 16, 3)
		RETURN
	END
COMMIT;


--Problem 19.
USE Diablo
GO


--Problem 20.


--Problem 21.
CREATE PROC usp_AssignProject(@employeeId INT, @projectId INT)
AS
BEGIN TRANSACTION
DECLARE @ProjectsCount INT;

SET @ProjectsCount = (SELECT COUNT (ep.EmployeeID)
					FROM EmployeesProjects AS ep
					WHERE ep.EmployeeID = @employeeId)

IF (@ProjectsCount >=3)
BEGIN
ROLLBACK
RAISERROR('The Employee has too many projects', 16,1)
RETURN
END

INSERT INTO EmployeesProjects(EmployeeID, ProjectID)
VALUES (@employeeId, @projectId)

COMMIT;

--Problem 22.
CREATE TRIGGER tr_deletedemployees ON Employees FOR DELETE
AS
BEGIN
INSERT INTO Deleted_Employees(FirstName, LastName, MiddleName, JobTitle, DepartmentID, Salary)
SELECT d.FirstName, d.LastName, d.MiddleName, d.JobTitle, d.DepartmentID, d.Salary
FROM Deleted_Employees AS d
END;