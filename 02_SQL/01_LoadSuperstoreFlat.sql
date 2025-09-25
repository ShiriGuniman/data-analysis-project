-- File: LoadSuperstoreFlat.sql
-- Purpose: Create the SuperstoreFlat staging table and load the dataset from CSV.
-- Notes:
--  - This table contains the raw data from Global_Superstore.csv.
--  - Data is cleaned and converted: dates are parsed, numeric fields are cast to DECIMAL, 
--    empty strings are converted to NULL.
--  - Character set utf8mb4 is used for Unicode compatibility.
--  - This table serves as the source for building Customers, Orders, Products, and OrderDetails tables.

CREATE DATABASE IF NOT EXISTS Superstore;
USE Superstore;

CREATE TABLE IF NOT EXISTS SuperstoreFlat (
    RowID INT PRIMARY KEY,
    OrderID VARCHAR(20) NOT NULL,
    OrderDate DATE,
    ShipDate DATE,
    ShipMode VARCHAR(50),
    CustomerID VARCHAR(20) NOT NULL,
    CustomerName VARCHAR(100),
    Segment VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50),
    PostalCode VARCHAR(20),
    Market VARCHAR(50),
    Region VARCHAR(50),
    ProductID VARCHAR(20) NOT NULL,
    Category VARCHAR(50),
    SubCategory VARCHAR(50),
    ProductName VARCHAR(200),
    Sales DECIMAL(10,2) NOT NULL CHECK (Sales >= 0),
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Discount DECIMAL(5,2) CHECK (Discount >= 0 AND Discount <= 1),
    Profit DECIMAL(10,2),
    ShippingCost DECIMAL(10,2),
    OrderPriority VARCHAR(50)
);

ALTER TABLE SuperstoreFlat CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Global_Superstore.csv'
INTO TABLE SuperstoreFlat
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@RowID, @OrderID, @OrderDate, @ShipDate, @ShipMode, @CustomerID, @CustomerName,
 @Segment, @City, @State, @Country, @PostalCode, @Market, @Region, @ProductID,
 @Category, @SubCategory, @ProductName, @Sales, @Quantity, @Discount, @Profit, 
 @ShippingCost, @OrderPriority)
SET
    RowID = NULLIF(@RowID,''),
    OrderID = NULLIF(@OrderID,''),
    OrderDate = STR_TO_DATE(@OrderDate, '%Y-%m-%d'),
    ShipDate = STR_TO_DATE(@ShipDate, '%Y-%m-%d'),
    ShipMode = NULLIF(@ShipMode,''),
    CustomerID = NULLIF(@CustomerID,''),
    CustomerName = NULLIF(@CustomerName,''),
    Segment = NULLIF(@Segment,''),
    City = NULLIF(@City,''),
    State = NULLIF(@State,''),
    Country = NULLIF(@Country,''),
    PostalCode = NULLIF(@PostalCode,''),
    Market = NULLIF(@Market,''),
    Region = NULLIF(@Region,''),
    ProductID = NULLIF(@ProductID,''),
    Category = NULLIF(@Category,''),
    SubCategory = NULLIF(@SubCategory,''),
    ProductName = NULLIF(@ProductName,''),
    Sales = CAST(REPLACE(REPLACE(REPLACE(REPLACE(@Sales,'$',''),',',''), ' ',''),'"','') AS DECIMAL(10,2)),
    Quantity = NULLIF(@Quantity,''),
    Discount = CAST(REPLACE(REPLACE(REPLACE(@Discount,',','.'),'%',''),' ','') AS DECIMAL(5,2)),
    Profit = CAST(REPLACE(REPLACE(REPLACE(REPLACE(@Profit,'$',''),',',''),' ',''),'"','') AS DECIMAL(10,2)),
    ShippingCost = CAST(REPLACE(REPLACE(REPLACE(@ShippingCost,'$',''),',',''),' ','') AS DECIMAL(10,2)),
    OrderPriority = NULLIF(@OrderPriority,'');
