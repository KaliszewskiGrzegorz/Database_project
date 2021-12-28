DROP DATABASE CRS
CREATE DATABASE CRS
GO
USE CRS
CREATE TABLE Employees(
	EmployeeID INT PRIMARY KEY IDENTITY(1,1),
	[First Name] NVARCHAR(256) NOT NULL,
	[Last Name] NVARCHAR(256) NOT NULL,
	Position NVARCHAR(50) NOT NULL,
	[Post Code] NVARCHAR(6) NULL,
	City NVARCHAR(50) NULL,
	Adress NVARCHAR(256) NULL,
	Phone NVARCHAR(12) NOT NULL,
	[Date of Emploment] DATE NOT NULL
)

CREATE TABLE Positions(			
	Name NVARCHAR(50) PRIMARY KEY,
	[Price per hour] MONEY NOT NULL,
	[Hourly rate] MONEY NOT NULL
)

ALTER TABLE Employees
ADD CONSTRAINT [HeldPosition]
FOREIGN KEY (Position) REFERENCES Positions(Name)

CREATE TABLE Customers(
	CustomerID INT PRIMARY KEY IDENTITY(1,1),
	CategoryID NVARCHAR(256) NOT NULL,
	NIP NVARCHAR(10) NULL,
	[Post Code] NVARCHAR(6) NOT NULL,
	City NVARCHAR(50) NOT NULL,
	Adress NVARCHAR(256) NOT NULL,
	Phone NVARCHAR(12) NOT NULL,
	[Date of Emploment] DATE NOT NULL,
	Category NVARCHAR(30) NOT NULL
)

CREATE TABLE Customers_Categories(
	CategoryID NVARCHAR(30) PRIMARY KEY,
	Discount TINYINT NOT NULL,
	[Payment Method] NVARCHAR(30) NOT NULL,		
	[Business Entity] NVARCHAR(30) NOT NULL
)

ALTER TABLE Customers
ADD CONSTRAINT [type of buisness entity]
FOREIGN KEY (Category) REFERENCES Customers_Categories(CategoryID)

CREATE TABLE Parts(
	PartID INT PRIMARY KEY IDENTITY(1,1),
	Category INT NOT NULL,
	[Name] VARCHAR(30) NOT NULL,
	[Logistic_Minimum] INT NOT NULL,
	Unity NVARCHAR(20) NOT NULL,
	Price MONEY NOT NULL
)

CREATE TABLE Suppliers(
	SuppilerID INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR(256) NOT NULL,
	NIP NVARCHAR(10) NULL,					
	[Post Code] NVARCHAR(6) NOT NULL,
	City NVARCHAR(50) NOT NULL,
	Adress NVARCHAR(256) NOT NULL,
	Phone NVARCHAR(12) NOT NULL,
	[Account Number] NVARCHAR(12) NOT NULL
)

CREATE TABLE Supply(
	SupplyID INT PRIMARY KEY IDENTITY(1,1),
	SuppilerID INT NOT NULL,
	[Delivery Date] DATE NOT NULL
)

ALTER TABLE Supply
ADD CONSTRAINT [Suppiler]
FOREIGN KEY (SuppilerID) REFERENCES Suppliers(SuppilerID)


CREATE TABLE Warehouse(
	PartID INT NOT NULL,
	SupplyID INT NOT NULL,
	Quantity INT NOT NULL,
	[Purchase Price] MONEY NULL,
	[Location] NVARCHAR(10) NULL,
	CONSTRAINT PKWarehouse PRIMARY KEY (PartID, SupplyID)
--	[Rotation Factor] FLOAT NOT NULL,
--	Zapotrzebowanie
)

CREATE TABLE Parts_Categories(					
	CategoryID INT PRIMARY KEY IDENTITY(1,1),		
	VAT INT NOT NULL,
	[Name] NVARCHAR(50) NOT NULL
)

ALTER TABLE Warehouse
ADD CONSTRAINT [partid]
FOREIGN KEY (PartID) REFERENCES Parts(PartID)

AlTER TABLE Parts 
ADD CONSTRAINT [part category]
FOREIGN KEY (Category) REFERENCES Parts_Categories(CategoryID)

ALTER TABLE Warehouse
ADD CONSTRAINT [supplyid]
FOREIGN KEY (SupplyID) REFERENCES Supply(SupplyID)

CREATE TABLE Repair_Orders(					
	OrderID INT PRIMARY KEY IDENTITY(1,1),
	CustomerID INT NOT NULL,
	VIN NVARCHAR(50) NOT NULL,
	[Release Date] DATE NOT NULL,
	EmployeeID INT NOT NULL									
)							

ALTER TABLE Repair_Orders
ADD CONSTRAINT [customer]
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)

ALTER TABLE Repair_Orders
ADD CONSTRAINT [assigned mechanic]
FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)

CREATE TABLE Orders_Detalis(
	OrderID INT NOT NULL,
	PartID INT NOT NULL,
	RelocationID INT NOT NULL,
	[Predicted Quantity] INT NOT NULL,	
	[Used Quantity] INT NULL,
	PRIMARY KEY(OrderID, PartID, RelocationID)		
)

ALTER TABLE Orders_Detalis
ADD CONSTRAINT [parts to order]
FOREIGN KEY (PartID) REFERENCES Parts(PartID)

ALTER TABLE Orders_Detalis
ADD CONSTRAINT [to order]
FOREIGN KEY (OrderID) REFERENCES Repair_Orders(OrderID) 

CREATE TABLE Relocations(
	RelocationID INT PRIMARY KEY IDENTITY(1,1),
	[Type] NVARCHAR(10) NOT NULL,
	[Date] DATE NOT NULL
)

ALTER TABLE Orders_Detalis
ADD CONSTRAINT [relocation for order]
FOREIGN KEY (RelocationID) REFERENCES Relocations(RelocationID)

CREATE TABLE Internal_Relocations(
	RelocationID INT,
	PartID INT,
	SupplyID INT,
	EmployeeID INT NOT NULL,
	OrderID INT NOT NULL,
	PRIMARY KEY(RelocationID, PartID, SupplyID)
)

ALTER TABLE	Internal_Relocations
ADD CONSTRAINT [relocationid]
FOREIGN KEY (RelocationID) REFERENCES Relocations(RelocationID)

ALTER TABLE	Internal_Relocations
ADD CONSTRAINT [partid in internal relocation]
FOREIGN KEY (PartID) REFERENCES Parts(PartID)

ALTER TABLE Internal_Relocations
ADD CONSTRAINT [orderid in internal relocation]
FOREIGN KEY (OrderID) REFERENCES Repair_Orders(OrderID)

CREATE TABLE External_Relocations(
	RelocationID INT NOT NULL,
	PartID INT NOT NULL,
	SupplyID INT NOT NULL,
	CustomerID INT NOT NULL,
	SalesID INT NOT NULL,
	PRIMARY KEY(RelocationID, PartID, SupplyID)
)

ALTER TABLE External_Relocations
ADD CONSTRAINT [relocationid]
FOREIGN KEY (RelocationID) REFERENCES Relocations(RelocationID)

ALTER TABLE External_Relocations
ADD CONSTRAINT [partid in external relocations]
FOREIGN KEY (PartID) REFERENCES Parts(PartID)

ALTER TABLE External_Relocations
ADD CONSTRAINT [supplyid in external relocations]
FOREIGN KEY (SupplyID) REFERENCES Supply(SupplyID)

ALTER TABLE Externale_Relocations
ADD CONSTRAINT [customerid in relocations]
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)

CREATE TABLE Buffer_Warehouse(
	PartID INT NOT NULL,
	OrderID INT NOT NULL,
	RelocationID INT NOT NULL,
	SupplyID INT NOT NULL,
	Quantity INT NOT NULL,
	PRIMARY KEY(PartID, OrderID, RelocationID, SupplyID)
)

ALTER TABLE Buffer_Warehouse
ADD CONSTRAINT [relocation to buffer]
FOREIGN KEY (RelocationID) REFERENCES Relocations(RelocationID)

ALTER TABLE Buffer_Warehouse
ADD CONSTRAINT [parts transfered for order]
FOREIGN KEY (OrderID) REFERENCES Repair_Orders(OrderID)

ALTER TABLE Buffer_Warehouse
ADD CONSTRAINT [parts in buffer]
FOREIGN KEY (PartID) REFERENCES Parts(PartID)

ALTER TABLE Buffer_Warehouse
ADD CONSTRAINT [supplyid in buffer]
FOREIGN KEY (SupplyID) REFERENCES Supply(SupplyID)

CREATE TABLE Sales(
	SalesID INT PRIMARY KEY IDENTITY(1,1),
	[Date] Date,
	CustomerID INt,
	RelocationID INT
)

ALTER TABLE External_Relocations
ADD CONSTRAINT [salesid in external relocations]
FOREIGN KEY (SalesID) REFERENCES Sales(SalesID)

ALTER TABLE Sales
ADD CONSTRAINT [parts sales]
FOREIGN KEY (RelocationID) REFERENCES Relocations(RelocationID)

ALTER TABLE Sales
ADD CONSTRAINT [buyer]
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)

CREATE TABLE Factures(
	FactureID INT PRIMARY KEY IDENTITY(1,1),
	CustomerID INT NOT NULL,
	[Payment Method] NVARCHAR(30) NOT NULL,
	[Date] DATE NOT NULL,
)

ALTER TABLE Factures
ADD CONSTRAINT [customerid on facture]
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)

CREATE TABLE Repaires_Factures(
	FactureID INT PRIMARY KEY,
	OrderID INT NOT NULL,
)

ALTER TABLE Repaires_Factures
ADD CONSTRAINT [repair factureid]
FOREIGN KEY (FactureID) REFERENCES Factures(FactureID)

ALTER TABLE Repaires_Factures
ADD CONSTRAINT [repairorederid]
FOREIGN KEY (OrderID) REFERENCES Repair_Orders(OrderID)

CREATE TABLE Sales_Factures(
	FactureID INT PRIMARY KEY,
	SalesID INT NOT NULL,
)

ALTER TABLE Sales_Factures
ADD CONSTRAINT [sales factureid]
FOREIGN KEY (FactureID) REFERENCES Factures(FactureID)

ALTER TABLE Sales_Factures
ADD CONSTRAINT [salesid]
FOREIGN KEY (SalesID) REFERENCES Sales(SalesID)

/*
fancy: hierarchia pracowmnikow
triger: walidacja numeru NIP, nr telefonu, peselu, sprawdzanie czy jest juz czesc w magazynie (jesli tak to dodanie, jesli nie to stworzenie rekordu), 
	aktualizacje wspolczynnika rotacji,   Zamów nowe części, jeśli stare się skończą
procedury: dodawanie zlecenia, pracownika, dostawcy, wystawienie faktury, pracownik przechodzi na emeryture (automatycznie), procedury do usuwania itd
widoki, funkcje to ez bd (obliczanie dochodu rocznego, mieisecznego itp)
panel admina itp : mechanik moze dodawac np. naprawe, a menedzer bd mogl wszystko
*/