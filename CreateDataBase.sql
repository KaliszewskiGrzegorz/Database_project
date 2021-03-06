DROP DATABASE CRS

CREATE DATABASE CRS
GO
USE CRS
CREATE TABLE Employees(
	EmployeeID INT PRIMARY KEY IDENTITY(1,1),
	[First Name] NVARCHAR(256) NOT NULL,
	[Last Name] NVARCHAR(256) NOT NULL,
	Position INT NOT NULL,
	[Post Code] NVARCHAR(6) NULL,
	City NVARCHAR(50) NULL,
	Adress NVARCHAR(256) NULL,
	Phone NVARCHAR(12) NOT NULL,
	[Date of Emploment] DATE NOT NULL
)

CREATE TABLE POSITIONS(			
	Name NVARCHAR(50) PRIMARY KEY NOT NULL,
	[Price per hour] MONEY NOT NULL,
	[Hourly rate] MONEY NOT NULL,
)

ALTER TABLE Employees
ADD CONSTRAINT HeldPosition
FOREIGN KEY (Position) REFERENCES Positions.Name

CREATE TABLE Customers(
	ID INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR(256) NOT NULL,
	NIP NVARCHAR(10) NULL,
	[Post Code] NVARCHAR(6) NOT NULL,
	City NVARCHAR(50) NOT NULL,
	Adress NVARCHAR(256) NOT NULL,
	Phone NVARCHAR(12) NOT NULL,
	[Date of Emploment] DATE NOT NULL,
	Category NVARCHAR(30) NOT NULL
)

CREATE TABLE Customers_Categories(
	Name NVARCHAR(30) PRIMARY KEY,
	Discount TINYINT NOT NULL,
	[Payment Method] NVARCHAR(30) NOT NULL,		
	[Business Entity] NVARCHAR(30) NOT NULL
)

ALTER TABLE Customers
ADD CONSTRAINT [type of buisness entity]
FOREIGN KEY (Category) REFERENCES Customers_Categories.Name

CREATE TABLE Warehouse(
	Part_Number VARCHAR(10) PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Quantity INT NOT NULL,
	[Logistic_Minimum] INT NOT NULL,
	Unity NVARCHAR(20) NOT NULL,
	[Purchase Price] MONEY NULL,
	Price MONEY NOT NULL,
	Category INT NOT NULL,
--	[Rotation Factor] FLOAT NOT NULL,
--	Zapotrzebowanie
	Location NVARCHAR(10) NULL
)

CREATE TABLE Parts_Categories(					
	CategoryID INT PRIMARY KEY IDENTITY(1,1),		
	VAT INT NOT NULL,
	Name NVARCHAR(50),
	 
)
AlTER TABLE Warehouse
ADD CONSTRAINT [part category]
FOREIGN KEY (Category) REFERENCES Warehouse.ID_Category

CREATE TABLE Suppliers(
	ID_Suppiler INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR(256) NOT NULL,
	NIP NVARCHAR(10) NULL,					
	[Post Code] NVARCHAR(6) NOT NULL,
	City NVARCHAR(50) NOT NULL,
	Adress NVARCHAR(256) NOT NULL,
	Phone NVARCHAR(12) NOT NULL,
	[Account Number] NVARCHAR(12) NOT NULL,
)

CREATE TABLE Repair_Orders(					
	OrderNumber INT PRIMARY KEY IDENTITY(1,1),
	CustomerID INT NOT NULL,
	VIN NVARCHAR(50) NOT NULL,
	[Release Date] DATE NOT NULL,
	MechanicID INT NOT NULL,				
	Details INT NULL,					
)							

CREATE TABLE Orders_Detalis(
	OrderID INT,
	PartID INT,
--	[Transfer Number] INT NULL,
	[Predicted Quantity] INT NOT NULL,	
	[Used Quantity] INT NULL,
	--PRIMARY KEY(OrderNumber, PartID)		
)

fancy: hierarchia pracowmnikow
triger: walidacja numeru NIP, nr telefonu, peselu, sprawdzanie czy jest juz czesc w magazynie (jesli tak to dodanie, jesli nie to stworzenie rekordu), 
	aktualizacje wspolczynnika rotacji,   Zam??w nowe cz????ci, je??li stare si?? sko??cz??
procedury: dodawanie zlecenia, pracownika, dostawcy, wystawienie faktury, pracownik przechodzi na emeryture (automatycznie), procedury do usuwania itd
widoki, funkcje to ez bd (obliczanie dochodu rocznego, mieisecznego itp)
panel admina itp : mechanik moze dodawac np. naprawe, a menedzer bd mogl wszystko
