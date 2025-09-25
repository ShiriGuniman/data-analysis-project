-- File: OrderDetails.sql
-- Purpose: Create and populate the OrderDetails fact table from the 
--          SuperstoreFlat dataset. This table stores line-item level data 
--          (one row per product per order) for detailed sales analysis.
-- Notes:
--  - Uses REPLACE INTO since each OrderDetailID is unique, so no DISTINCT needed.
--  - Includes calculated columns (UnitPrice, ProfitMargin, ProfitPerUnit) 
--    for profitability and pricing analysis.
--  - Indexes created on OrderID, ProductID, Profit, and Sales for optimized queries.

CREATE TABLE IF NOT EXISTS OrderDetails (
    OrderDetailID INT NOT NULL PRIMARY KEY,
    OrderID VARCHAR(20) NOT NULL,
    ProductID VARCHAR(20) NOT NULL,
    Sales DECIMAL(10,2) NOT NULL CHECK (Sales >= 0),
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Discount DECIMAL(5,2) DEFAULT 0 CHECK (Discount >= 0 AND Discount <= 1),
    Profit DECIMAL(10,2),
    ShippingCost DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert order details (fact table)
REPLACE INTO OrderDetails (OrderDetailID, OrderID, ProductID, Sales, Quantity, Discount, Profit, ShippingCost)
SELECT RowID, OrderID, ProductID, Sales, Quantity, Discount, Profit, ShippingCost
FROM SuperstoreFlat
WHERE RowID IS NOT NULL;

-- Calculated Columns
ALTER TABLE OrderDetails
ADD COLUMN UnitPrice DECIMAL(10,2) AS (Sales / (Quantity * (1 - Discount)));

ALTER TABLE OrderDetails
ADD COLUMN ProfitMargin DECIMAL(5,2) AS (Profit / (Quantity * UnitPrice) * 100);

ALTER TABLE OrderDetails
ADD COLUMN ProfitPerUnit DECIMAL(10,2) AS (Profit / Quantity);

-- Indexes to Improve Query Performance
CREATE INDEX idx_orderdetails_orderid ON OrderDetails(OrderID);
CREATE INDEX idx_orderdetails_productid ON OrderDetails(ProductID);
CREATE INDEX idx_orderdetails_profit ON OrderDetails(Profit);
CREATE INDEX idx_orderdetails_sales ON OrderDetails(Sales);