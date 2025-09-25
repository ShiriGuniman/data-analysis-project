-- File: Products.sql
-- Purpose: Create and populate the Products dimension table from the 
--          SuperstoreFlat dataset. Stores unique product information 
--          for reporting and analysis.
-- Notes:
--  - Uses REPLACE INTO to handle duplicates caused by multiple rows per order.
--  - Indexes created on Category and SubCategory for faster lookups.

CREATE TABLE Products (
    ProductID VARCHAR(20) PRIMARY KEY,
    Category VARCHAR(50),
    SubCategory VARCHAR(50),
    ProductName VARCHAR(200)
);

REPLACE INTO Products (ProductID, Category, SubCategory, ProductName)
SELECT DISTINCT ProductID, Category, SubCategory, ProductName
FROM SuperstoreFlat
WHERE ProductID IS NOT NULL;

CREATE INDEX idx_products_category ON Products(Category);
CREATE INDEX idx_products_subcategory ON Products(SubCategory);
