-- Problem 1. Create DATABASE
CREATE DATABASE Minions;

USE Minions
GO

-- Problem 2. CREATE TABLES
CREATE TABLE Minions
(
ID INT PRIMARY KEY,
[Name] NVARCHAR (30) NOT NULL,
Age INT NOT NULL
);


CREATE TABLE Towns
(
ID INT PRIMARY KEY,
[Name] NVARCHAR (30) NOT NULL
);


-- Problem 3 ALTER Minions TABLE
ALTER TABLE Minions
ADD TownID INT FOREIGN KEY REFERENCES Towns(ID) NOT NULL;

-- another option
ALTER TABLE Minions
ADD TownID INT
ALTER TABLE Minions
ADD CONSTRAINT FK_TownID
FOREIGN KEY (TownID) REFERENCES Towns(ID);

-- Check table content
SELECT * FROM Minions
SELECT * FROM Towns

-- Problem 4 INSERT records in  both tables

INSERT INTO Towns(Id, [Name])
VALUES (1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')

INSERT INTO Minions(Id, [Name], Age, TownID)
VALUES (1, 'Kevin', 22, 1),
(2, 'Bob', 15,3),
(3, 'Steward', NULL, 2);


-- Problem 5. (deletes all data which is part of the table, but not the table itself) TRUNCATE TABLE
TRUNCATE TABLE Minions

-- Problem 6. (deletes the entire table) DROP TABLE
DROP TABLE Minions
DROP TABLE Towns


-- Problem 7 Create TABLE People
CREATE TABLE People
( 
ID INT UNIQUE IDENTITY NOT NULL,
[Name] NVARCHAR (200) NOT NULL,
Picture VARBINARY(MAX),
Height DECIMAL(15,2),
[Weight] DECIMAL(15,2),
Gender CHAR(1) CHECK([Gender] IN ('M', 'F')) NOT NULL,
Birthdate DATE NOT NULL,
Biography NVARCHAR(MAX)
);

ALTER TABLE People
ADD PRIMARY KEY(ID)

INSERT INTO People(Name, Gender, Birthdate)
VALUES
('FirstOne', 'M', '02-03-1999'),
('SecondOne', 'M', '04-08-1994'),
('ThirdOne', 'F', '07-28-2001'),
('FourthOne', 'F', '05-20-2000'),
('FifthOne', 'F', '02-19-2003')

-- Problem 8 CREATE TABLE Users
CREATE TABLE Users
(
	ID INT UNIQUE IDENTITY NOT NULL,
	Username VARCHAR(30) UNIQUE NOT NULL,
	Password VARCHAR(26) NOT NULL,
	ProfilePicture VARBINARY(MAX),
	LastLoginTime DATETIME2,
	IsDeleted BIT NOT NULL DEFAULT(0)
);

ALTER TABLE Users
ADD CONSTRAINT PK_Users PRIMARY KEY(ID)


-- Problem 9 CHANGE PRIMARY KEY
ALTER TABLE Users
DROP CONSTRAINT PK_Users;
ALTER TABLE Users
ADD CONSTRAINT PK_Users PRIMARY KEY(Id, Username);

-- Problem 10 Add Check constraint
ALTER TABLE Users
ADD CONSTRAINT CHK_Users_Password CHECK(LEN(Password) >= 5);

-- Problem 11 Set Default Value of a Field
ALTER TABLE Users
ADD CONSTRAINT DF_Users DEFAULT GETDATE() FOR LastLoginTime;  


-- Prolem 12 Set Unique Field
ALTER TABLE Users
DROP CONSTRAINT PK_Users;

ALTER TABLE Users
ADD CONSTRAINT PK_Users PRIMARY KEY(Id);

ALTER TABLE Users
ADD CONSTRAINT UC_Users UNIQUE(Username);

ALTER TABLE Users
ADD CONSTRAINT LEN_Username CHECK(LEN(Username) >=3);

-- Problem 13 Create DATABASE MOVIES
CREATE DATABASE Movies
GO
USE Movies;

CREATE TABLE Directors
( ID INT PRIMARY KEY NOT NULL,
DirectorName NVARCHAR (30) NOT NULL,
Notes NVARCHAR (MAX)
);

INSERT INTO Directors(ID, DirectorName)
VALUES 
(1, 'X'),
(2, 'Y'),
(3, 'Z'),
(4, 'A'),
(5, 'B')


CREATE TABLE Genres
( ID INT PRIMARY KEY NOT NULL,
GenreName NVARCHAR (30) NOT NULL,
Notes NVARCHAR (MAX)
);

INSERT INTO Genres(Id,GenreName)
VALUES
(1, 'X'),
(2, 'Y'),
(3, 'Z'),
(4, 'A'),
(5, 'B')


CREATE TABLE Categories
( ID INT PRIMARY KEY NOT NULL,
CategoryName NVARCHAR(30) NOT NULL,
NOTES NVARCHAR (MAX)
);

INSERT INTO Categories(Id,CategoryName)
	VALUES
	(1, 'X'),
(2, 'Y'),
(3, 'Z'),
(4, 'A'),
(5, 'B')



CREATE TABLE Movies
( ID INT NOT NULL PRIMARY KEY,
Title NVARCHAR(300) NOT NULL,
DirectorID INT FOREIGN KEY REFERENCES Directors(ID),
Copyrightyear INT,
Lenght NVARCHAR(50),
GenreID INT FOREIGN KEY REFERENCES Genres(ID),
CategoryID INT FOREIGN KEY REFERENCES Categories(ID),
Rating INT,
Notes NVARCHAR(MAX));

INSERT INTO Movies (ID, Title, DirectorID, GenreID, CategoryID)
VALUES
(1, 'Title1', 2,3,4),
(2, 'Title2', 3,4,5),
(3, 'Title3', 1,3,2),
(4, 'Title4', 4,5,1),
(5, 'Title5', 5,2,3)

SELECT * FROM MOVIES

-- Problem 14 CREATE CarRental Database/Tables/Insert Values
CREATE DATABASE CarRental;
GO
USE CarRental

CREATE TABLE Categories
(Id INT NOT NULL PRIMARY KEY,
CategoryName NVARCHAR (50) NOT NULL,
DailyRate DECIMAL(10,2),
WeeklyRate DECIMAL(10,2),
MonthlyRate DECIMAL(10,2),
WeekendRate DECIMAL(10,2)
);

ALTER TABLE Categories
ADD CONSTRAINT CK_AtLeastRateOnce CHECK((DailyRate IS NOT NULL)
									OR (WeeklyRate IS NOT NULL)
									OR (MonthlyRate IS NOT NULL)
									OR (WeekendRate IS NOT NULL));
															
INSERT INTO Categories(Id,CategoryName,DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES
(1, 'First Category', 20,30,40,50),
(2,'Second Category', 20,30,40,50),
(3, 'Third Category', 20,30,40,50)

CREATE TABLE Cars
(Id INT NOT NULL PRIMARY KEY,
PlateNumber VARCHAR (50) NOT NULL,
Manufactcurer NVARCHAR(50) NOT NULL,
Model NVARCHAR(50) NOT NULL,
CarYear INT NOT NULL,
CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(ID),
Doors TINYINT NOT NULL,
Picture VARBINARY(MAX),
Condition NVARCHAR (50),
Available BIT DEFAULT 1
);

INSERT INTO CARS(Id,PlateNumber,Manufactcurer,Model,CarYear,CategoryId,Doors,Available)
VALUES
(1, 'CX2413', 'Mercedes', 'Sclass', '2005', 1,4,1),
(2, 'GGHA21', 'Audi', 'A7', '2019', 2,4,0),
(3, 'FFJ213', 'BMW', '335', '2019', 3,4,1);

CREATE TABLE Employees
(Id INT PRIMARY KEY NOT NULL,
FirstName NVARCHAR(50),
LastName NVARCHAR(50),
Title NVARCHAR(500),
Notes NVARCHAR(MAX));

INSERT INTO Employees (Id,FirstName,LastName,Title)
VALUES
(1, 'John', 'Nakov', 'Mr'),
(2, 'Peter', 'Barov', 'Mr'),
(3, 'Maria', 'Petrova', 'Ms');


CREATE TABLE Customers
(ID INT PRIMARY KEY NOT NULL,
DriverLicenceNumber NVARCHAR(50) UNIQUE NOT NULL,
FullName NVARCHAR(50) NOT NULL,
[Adress] NVARCHAR(100),
City NVARCHAR(50),
ZIPCode NVARCHAR(50),
Notes NVARCHAR(MAX)
);

INSERT INTO Customers(Id,DriverLicenceNumber,FullName)
VALUES
(1, 'RFF214', 'Peter Nedkov'),
(2, 'CBA525', 'Stephen Malkovic'),
(3, 'FJG361', 'Biden Joe');

CREATE TABLE RentalOrders
(Id INT PRIMARY KEY NOT NULL,
EmployeeId INT NOT NULL FOREIGN KEY REFERENCES Employees(Id),
CustomerId INT NOT NULL FOREIGN KEY REFERENCES Customers(ID),
CarId      INT NOT NULL FOREIGN KEY REFERENCES Cars(Id),
TankLevel NUMERIC(5,2),
KilometrageStart INT,
KilometrageEnd   INT,
TotalKilometrage INT,
StartDate        DATE NOT NULL,
EndDate			 DATE NOT NULL,
TotalDays        INT NOT NULL,
RateApplied      DECIMAL(10,2),
Taxrate          DECIMAL(10,2),
OrderStatus NVARCHAR(50),
Notes NVARCHAR(MAX));

ALTER TABLE RentalOrders
ADD CONSTRAINT CK_TotalDays CHECK(DATEDIFF(DAY, StartDate, EndDate) = TotalDays);

INSERT INTO RentalOrders(Id,EmployeeId,CustomerId,CarId,StartDate,EndDate,TotalDays)
VALUES
(1,1,1,1, '01-01-2015', '01-03-2015',2),
(2,2,2,2, '02-02-2015', '02-03-2015',1),
(3,3,3,3, '03-03-2015', '03-04-2015',1);

-- Problem 15. Hotel Database

CREATE DATABASE Hotel
GO
USE Hotel;

CREATE TABLE Employees
(Id INT PRIMARY KEY NOT NULL,
FirstName NVARCHAR (50) NOT NULL,
LastName NVARCHAR (50) NOT NULL,
Title NVARCHAR(50) NOT NULL,
Notes NVARCHAR(MAX));

INSERT INTO Employees(Id,FirstName,LastName,Title)
VALUES
(1,'Vasil', 'Manoev', 'Mr'),
(2, 'Joanna', 'Nedkova', 'Ms'),
(3, 'Peter', 'Johnson', 'Mr');

CREATE TABLE Customers
(AccountNumber INT PRIMARY KEY NOT NULL,
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
PhoneNumber VARCHAR(50),
EmergencyName NVARCHAR(50) NOT NULL,
EmergencyNumber INT NOT NULL,
Notes NVARCHAR(MAX));
	

	INSERT INTO Customers(AccountNumber,FirstName,LastName, EmergencyName, EmergencyNumber)
	VALUES
	(1, 'Peter', 'Brezovic', 'Anna', 9999),
	(2, 'Norman', 'Gonzalez', 'Kieran', 1111),
	(3, 'Sadio', 'Mane', 'Eve', 2441)

	
	CREATE TABLE RoomStatus
	(RoomStatus NVARCHAR(50) PRIMARY KEY NOT NULL,
Notes NVARCHAR(MAX));

INSERT INTO RoomStatus(RoomStatus)
VALUES
('Available'), ('Free'), ('In use')


CREATE TABLE RoomTypes
(RoomType NVARCHAR(50) PRIMARY KEY NOT NULL,
Notes NVARCHAR(MAX));

INSERT INTO RoomTypes(RoomType)
VALUES
('Luxury'), ('Common'), ('Palace')


CREATE TABLE BedTypes
(BedType NVARCHAR(50) PRIMARY KEY NOT NULL,
Notes NVARCHAR(MAX));

INSERT INTO BedTypes(BedType)
VALUES ('Big'), ('Small'), ('Extra big')

CREATE TABLE Rooms
(RoomNumber INT PRIMARY KEY NOT NULL,
RoomType NVARCHAR(50) NOT NULL,
BedType NVARCHAR(50) NOT NULL,
Rate DECIMAL(10,2),
RoomStatus NVARCHAR(50) NOT NULL,
Notes NVARCHAR(MAX));

INSERT INTO Rooms(RoomNumber, RoomType, BedType, RoomStatus)
VALUES
(1, 'Palace', 'Extra big', 'Available'),
(2, 'Studio', 'Small', 'In use'),
(3, 'Common', 'Big', 'Free')


CREATE TABLE Payments
(Id INT PRIMARY KEY NOT NULL,
EmployeeId INT NOT NULL,
PaymentDate DATE NOT NULL,
AccountNumber INT NOT NULL,
FirstDateOccupied DATE NOT NULL,
LastDateOccupied DATE NOT NULL,
TotalDays INT NOT NULL,
AmountCharged DECIMAL(10,2) NOT NULL,
TaxRate DECIMAL(10,2) NOT NULL,
TaxAmount DECIMAL(10,2) NOT NULL,
PaymentTotal DECIMAL(10,2) NOT NULL,
Notes NVARCHAR(MAX));

ALTER TABLE Payments
ADD CONSTRAINT CK_TotalDays CHECK(DATEDIFF(DAY, FirstDateOccupied, LastDateOccupied) = TotalDays);

ALTER TABLE Payments
ADD CONSTRAINT CK_TaxAmount CHECK(TaxAmount = TotalDays * TaxRate);

INSERT INTO Payments(Id,EmployeeId,PaymentDate,AccountNumber,FirstDateOccupied,LastDateOccupied,TotalDays,AmountCharged,TaxRate,TaxAmount,PaymentTotal)
VALUES
(1, 1, '01-01-2010', 1, '01-01-2010', '01-06-2010', 5, 200, 10, 50, 250);

CREATE TABLE Occupancies
(Id INT PRIMARY KEY NOT NULL,
EmployeeId INT NOT NULL,
DateOccupied DATE NOT NULL,
AccountNumber INT NOT NULL,
RoomNumber INT NOT NULL,
RateApplied DECIMAL(10,2),
PhoneCharge NVARCHAR(50) NOT NULL,
Notes NVARCHAR(MAX));

INSERT INTO Occupancies(Id, EmployeeId, DateOccupied, AccountNumber, RoomNumber, PhoneCharge)
VALUES
(1, 2, '05-06-2015', 6266, 65, '62727826')


-- Problem 16 CREATE DATABASE SoftUni
CREATE DATABASE SoftUni
GO
USE SoftUni;

CREATE TABLE Towns
(Id INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(50));

CREATE TABLE Addresses
(Id INT PRIMARY KEY IDENTITY NOT NULL,
AddressText NVARCHAR(100) NOT NULL,
TownId INT FOREIGN KEY REFERENCES Towns(Id) NOT NULL);


CREATE TABLE Departments
(Id INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(50));


CREATE TABLE Employees
(Id INT PRIMARY KEY IDENTITY NOT NULL,
FirstName NVARCHAR(50) NOT NULL,
MiddleName NVARCHAR(50),
LastName NVARCHAR(50),
JobTitle VARCHAR(50) NOT NULL,
DepartmentId INT FOREIGN KEY REFERENCES Departments(Id) NOT NULL,
HireDate DATE,
Salary DECIMAL(10,2) NOT NULL,
AddressID INT FOREIGN KEY REFERENCES Addresses(Id));

-- Problem 17. Backup database

BACKUP DATABASE SoftUni TO DISK = 'D:\backup'

DROP DATABASE SoftUni;
RESTORE DATABASE SoftUni FROM DISK = 'D:\backup'

-- Problem 18.
INSERT INTO Towns([Name])
VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas')

INSERT INTO Departments([Name])
VALUES
('Software Development'),
('Engineering'),
('Quality Assurance'),
('Sales'),
('Marketing')



INSERT INTO Employees(FirstName,MiddleName,LastName,JobTitle,DepartmentId,HireDate,Salary)
VALUES
('Ivan', 'Ivanov', 'Ivanov',  'NET Developer', 4, CONVERT(DATE, '01-02-2013', 103), 3500),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 2, CONVERT(DATE, '02-03-2004', 103),4000),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, CONVERT(DATE, '28-08-2016', 103), 525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, CONVERT(DATE, '09-12-2007', 103), 3000),
('Peter', 'Pan', 'Pan', 'Intern', 3, CONVERT(DATE, '28-08-2016', 103), 599.88);


-- Problem 19. SELECT STATEMENTS
SELECT * FROM Towns;
SELECT * FROM Departments;
SELECT * FROM Employees;

-- Problem 20. Basic Select All Fields and Order Them

SELECT * 
FROM Towns
ORDER BY [Name] ASC

SELECT *
FROM Departments
ORDER BY [Name] ASC

SELECT *
FROM Employees
ORDER BY Salary DESC

-- Problem 21.

SELECT 
[Name]
FROM Towns
ORDER BY [Name]

SELECT 
[Name]
FROM Departments
ORDER BY [Name]

SELECT
FirstName,
LastName,
JobTitle,
Salary
FROM
Employees
ORDER BY Salary DESC

-- Problem 22. Increase Employees Salary/Update

UPDATE Employees
SET Salary *= 1.10;

--SET Salary += Salary * 0.10

SELECT Salary
FROM 
Employees


-- Problem 23. Decrease Tax rate
GO
Use Hotel
-- you should first drop the constraint

ALTER TABLE Payments
DROP CONSTRAINT [CK_TaxAmount];
UPDATE Payments
SET TaxRate *=0.97;   /  TaxRate = TaxRate - (TaxRate * 0.03);


-- Problem 24. TRUNCATE
GO
USE Hotel;

TRUNCATE TABLE Occupancies / DELETE FROM Occupancies 
-- If you omit the WHERE clause, all records in the table will be deleted!