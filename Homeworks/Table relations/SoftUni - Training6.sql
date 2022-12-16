--Problem 1.
CREATE DATABASE TableCreation

CREATE TABLE Passports(
PassportID INT PRIMARY KEY NOT NULL,
PassportNumber NVARCHAR(50) UNIQUE NOT NULL
)
;
INSERT INTO Passports (PassportID, PassportNumber)
VALUES
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2');

CREATE TABLE Persons(
PersonID INT PRIMARY KEY IDENTITY NOT NULL,
FirstName NVARCHAR(50),
Salary DECIMAL(15,2),
PassportID INT NOT NULL,
CONSTRAINT FK_Persons_Passport
FOREIGN KEY(PassportID) REFERENCES Passports(PassportID));

INSERT INTO Persons(PersonID, FirstName, Salary, PassportID)
VALUES(
1, 'Roberto', 43300.00,102),
(2, 'Tom', 56100.00, 103),
(3, 'Yana', 60200.00, 101);

--Problem 2.
SET IDENTITY_INSERT Manufacturers ON
CREATE TABLE Manufacturers(
ManufacturerID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(50) NOT NULL,
EstablishedOn DATE NOT NULL);

INSERT INTO Manufacturers(ManufacturerID,[Name],EstablishedOn)
VALUES(
1, 'BMW', '07/03/1916'),
(2, 'Tesla', '01/01/2003'),
(3, 'Lada', '01/05/1996');


CREATE TABLE Models(
ModelID INT PRIMARY KEY NOT NULL,
[Name] NVARCHAR(50) NOT NULL,
ManufacturerID INT NOT NULL,
CONSTRAINT FK_Models_Manufacturers
FOREIGN KEY (ManufacturerID)  REFERENCES Manufacturers(ManufacturerID));

INSERT INTO Models(ModelID, [Name], ManufacturerID)
VALUES      (101, 'X1', 1),
            (102, 'i6', 1),
			(103, 'Model S', 2),
			(104, 'Model X', 2),
			(105, 'Model 3', 2),
			(106, 'Nova', 3);

-- Problem 3.
CREATE TABLE Students(
StudentID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(50) NOT NULL);

CREATE TABLE Exams(
ExamID INT PRIMARY KEY NOT NULL,
[Name] NVARCHAR(50) NOT NULL);

CREATE TABLE StudentsExams(
StudentID INT NOT NULL,
ExamID INT NOT NULL,
CONSTRAINT PK_StudentExam
PRIMARY KEY(StudentID,ExamID),
CONSTRAINT FK_Exams_ExamsID
FOREIGN KEY(ExamID) REFERENCES Exams(ExamID),
CONSTRAINT FK_Students_StudentID
FOREIGN KEY(StudentID) REFERENCES Students(StudentID));

--Composite primary key


INSERT INTO Students([Name])
VALUES      ('Mila'),
            ('Toni'),
			('Ron')

			INSERT INTO Exams(ExamID ,[Name])
VALUES      (101, 'SpringMVC'),
            (102, 'Neo4j'),
			(103, 'Oracle 11g')

			INSERT INTO StudentsExams(StudentID, ExamID)
VALUES      (1, 101),
            (1, 102),
			(2, 101),
			(3, 103),
			(2, 102),
			(2, 103)

--Problem 4.

CREATE TABLE Teachers(
TeacherID INT PRIMARY KEY NOT NULL,
[Name] NVARCHAR(50) NOT NULL,
ManagerID INT,
CONSTRAINT FK_ManagerID_TeacherID
FOREIGN KEY(ManagerID) REFERENCES Teachers(TeacherID));

INSERT INTO Teachers(TeacherID, [Name], ManagerID)
VALUES      (101, 'John', NULL),
			(102, 'Maya', 106),
			(103, 'Silvia', 106),
			(104, 'Ted', 105),
			(105, 'Mark', 101),
			(106, 'Greta', 101);


--Problem 5.
CREATE TABLE Cities(
CityID INT PRIMARY KEY IDENTITY NOT NULL,
"Name" VARCHAR(50) NOT NULL);

CREATE TABLE Customers(
CustomerID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(50) NOT NULL,
Birthday DATE NOT NULL,
CityID INT NOT NULL,
CONSTRAINT FK_Customers_CityID
FOREIGN KEY(CityID) REFERENCES Cities(CityID));

CREATE TABLE Orders(
OrderID INT PRIMARY KEY IDENTITY NOT NULL,
CustomerID INT NOT NULL,
CONSTRAINT FK_Orders_CustomerID
FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID));

CREATE TABLE ItemTypes(
ItemTypeID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL);

CREATE TABLE Items(
ItemID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(50) NOT NULL,
ItemTypeID INT NOT NULL,
CONSTRAINT FK_Items_ItemTypeID
FOREIGN KEY(ItemTypeID) REFERENCES ItemTypes(ItemTypeID));

CREATE TABLE Orderitems(
OrderID INT NOT NULL,
ItemID INT NOT NULL,
CONSTRAINT PK_OrderItemsID
PRIMARY KEY (OrderID, ItemID),
CONSTRAINT FK_OrderItems_OrderID
FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
CONSTRAINT FK_OrderItems_ItemID
FOREIGN KEY(ItemID) REFERENCES Items(ItemID));
--compository key


--Problem 6.
CREATE TABLE Majors(
MajorID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(50) NOT NULL);

CREATE TABLE Students1(
StudentID INT PRIMARY KEY IDENTITY NOT NULL,
StudentNumber INT NOT NULL,
StudentName NVARCHAR(50),
MajorID INT NOT NULL,
CONSTRAINT FK_Students_MajorsID
FOREIGN KEY(MajorID) REFERENCES Majors(MajorID));

CREATE TABLE Subjects(
SubjectID INT PRIMARY KEY IDENTITY NOT NULL,
SubjectName NVARCHAR(50));


CREATE TABLE Agenda(
SubjectID INT NOT NULL,
StudentID INT NOT NULL,
CONSTRAINT PK_StudentSubjectID
PRIMARY KEY(SubjectID, StudentID),
CONSTRAINT FK_Agenda_StudentID
FOREIGN KEY(StudentID) REFERENCES Students1(StudentID),
CONSTRAINT FK_Agenda_SubjectID
FOREIGN KEY(SubjectID) REFERENCES Subjects(SubjectID));

CREATE TABLE Payments(
PaymentID INT PRIMARY KEY IDENTITY NOT NULL,
PaymentDate DATE NOT NULL,
PaymentAmount DECIMAL(15,2) NOT NULL,
StudentID INT NOT NULL,
CONSTRAINT FK_Payments_StudentID
FOREIGN KEY(StudentID) REFERENCES Students1(StudentID));

--Problem 9.
USE Geography
GO

SELECT
m.MountainRange,
p.PeakName,
p.Elevation
FROM Mountains AS m
JOIN Peaks AS p
ON m.Id = p.MountainId
WHERE m.MountainRange = 'Rila'
ORDER BY p.Elevation DESC;
