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
	[Hourly rate] MONEY NOT NULL,
)

ALTER TABLE Employees
ADD CONSTRAINT [HeldPosition]
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
	PartID VARCHAR(10),
	SupplyID INT,
	[Name] VARCHAR(30) NOT NULL,
	Quantity INT NOT NULL,
	[Logistic_Minimum] INT NOT NULL,
	Unity NVARCHAR(20) NOT NULL,
	[Purchase Price] MONEY NULL,
	Price MONEY NOT NULL,
	Category INT NOT NULL,
--	[Rotation Factor] FLOAT NOT NULL,
--	Zapotrzebowanie
	[Location] NVARCHAR(10) NULL
	PRIMARY KEY(PartID, SupplyID)

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
	SuppilerID INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR(256) NOT NULL,
	NIP NVARCHAR(10) NULL,					
	[Post Code] NVARCHAR(6) NOT NULL,
	City NVARCHAR(50) NOT NULL,
	Adress NVARCHAR(256) NOT NULL,
	Phone NVARCHAR(12) NOT NULL,
	[Account Number] NVARCHAR(12) NOT NULL,
)

CREATE TABLE Repair_Orders(					
	OrderID INT PRIMARY KEY IDENTITY(1,1),
	CustomerID INT NOT NULL,
	VIN NVARCHAR(50) NOT NULL,
	[Release Date] DATE NOT NULL,
	EmployeeID INT NOT NULL,									
)							

ALTER TABLE Repair_Orders
ADD CONSTRAINT [customr]
FOREIGN KEY (CustomerID) REFERENCES Customers.CustomerID

ALTER TABLE Repair_Orders
ADD CONSTRAINT [assigned mechanic]
FOREIGN KEY (EmployeeID) REFERENCES Employees.EmployeeID

CREATE TABLE Orders_Detalis(
	OrderID INT,
	PartID INT,
	[Transfer Number] INT NULL,
	[Predicted Quantity] INT NOT NULL,	
	[Used Quantity] INT NULL,
	PRIMARY KEY(OrderID, PartID)		
)

ALTER TABLE Orders_Detalis
ADD CONSTRAINT [to order]
FOREIGN KEY (OrderID) REFERENCES Repair_Orders.OrderID

ALTER TABLE Orders_Detalis
ADD CONSTRAINT [parts to order]
FOREIGN KEY (OrderID) REFERENCES Warehouse.PartID

CREATE TABLE Buffer_Warehouse(
	PartID NVARCHAR(10),
	OrderID INT,
	TransferID INT,
	SupplyID INT,
	Quantity INT NOT NULL,
	PRIMARY KEY(PartID, OrderID, TransferID, SupplyID)
)
-- Kolejne klucze obce do zrobienia po zrobieniu tabel z przeniesiami wew.
ALTER TABLE Buffer_Warehouse
ADD CONSTRAINT [parts transfered for order]
FOREIGN KEY (OrderID) REFERENCES Repair_Orders.OrderID

CREATE TABLE Supply(
	SupplyID INT PRIMARY KEY IDENTITY(1,1),
	SuppilerID INT NOT NULL,
	[Delivery Date] DATE NOT NULL,
)

ALTER TABLE Supply
ADD CONSTRAINT [Suppiler]
FOREIGN KEY (SuppilerID) REFERENCES Suppliers.SuppilerID

CREATE TABLE Supply_Detalist(
	SupplyID INT,
	PartID NVARCHAR(10),
	Price MONEY NOT NULL,
	Quantity INT NOT NULL,
	PRIMARY KEY(SupplyID, PartID)
)

ALTER TABLE Warehouse
ADD CONSTRAINT [supplyid]
FOREIGN KEY (SupplyID) REFERENCES Supply_Detalist.SupplyID

ALTER TABLE Warehouse
ADD CONSTRAINT [partid]
FOREIGN KEY (PartID) REFERENCES Supply_Detalist.PartID


ALTER TABLE Supply_Detalist
ADD CONSTRAINT [supply]
FOREIGN KEY (SupplyID) REFERENCES Supply.SupplyID

ALTER TABLE Supply_Detalist
ADD CONSTRAINT [delivered parts]
FOREIGN KEY (PartID) REFERENCES Warehouse.PartID

CREATE TABLE Sales(
	SalesID INT PRIMARY KEY IDENTITY(1,1),
	[Date] Date,
	CustomerID INt,
	RelocationID INT
)

CREATE TABLE Relocations(
	RelocationID INT PRIMARY KEY IDENTITY(1,1),
	[Type] NVARCHAR(10) NOT NULL,
	[Date] DATE NOT NULL,
)

ALTER TABLE Sales
ADD CONSTRAINT [parts sales]
FOREIGN KEY (RelocationID) REFERENCES Relocations.RelocationID

ALTER TABLE Sales
ADD CONSTRAINT [buyer]
FOREIGN KEY (CustomerID) REFERENCES Relocations.CustomerID

CREATE TABLE Internal_Relocations(
	RelocationID INT,
	PartID NVARCHAR(10),
	SupplyID INT,
	EmployeeID INT NOT NULL,
	OrderID INT NOT NULL,
	PRIMARY KEY(RelocationID, PartID, SupplyID)
)

ALTER TABLE	Internal_Relocations
ADD CONSTRAINT [relocationid]
FOREIGN KEY (RelocationID) REFERENCES Relocations.RelocationID

ALTER TABLE	Internal_Relocations
ADD CONSTRAINT [partid]
FOREIGN KEY (PartID) REFERENCES Warehouse.PaertID

ALTER TABLE Internal_Relocations
ADD CONSTRAINT [orderid]
FOREIGN KEY (OrderID) REFERENCES Repair_Orders.OrderID

CREATE TABLE External_Relocations(
	RelocationID INT,
	PartID NVARCHAR(10),
	SupplyID INT,
	CustomerID INT NOT NULL,
	SalesID INT NOT NULL,
	PRIMARY KEY(RelocationID, PartID, SupplyID)
)


fancy: hierarchia pracowmnikow
triger: walidacja numeru NIP, nr telefonu, peselu, sprawdzanie czy jest juz czesc w magazynie (jesli tak to dodanie, jesli nie to stworzenie rekordu), 
	aktualizacje wspolczynnika rotacji,   Zamów nowe części, jeśli stare się skończą
procedury: dodawanie zlecenia, pracownika, dostawcy, wystawienie faktury, pracownik przechodzi na emeryture (automatycznie), procedury do usuwania itd
widoki, funkcje to ez bd (obliczanie dochodu rocznego, mieisecznego itp)
panel admina itp : mechanik moze dodawac np. naprawe, a menedzer bd mogl wszystko
