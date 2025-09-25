-- File: Orders.sql
-- Purpose: Create and populate the Orders table from the SuperstoreFlat dataset. 
--          Stores unique order details, including shipping info and links to Customers.
-- Notes:
--  - Uses REPLACE INTO to handle duplicates from multiple product rows per order.
--  - Includes foreign key to Customers table.
--  - Indexes created on OrderDate, ShipDate, and CustomerID for query optimization.

CREATE TABLE IF NOT EXISTS Orders (
    OrderID VARCHAR(20) NOT NULL PRIMARY KEY,
    OrderDate DATE NOT NULL,
    ShipDate DATE,
    ShipMode VARCHAR(50),
    OrderPriority VARCHAR(50),
    CustomerID VARCHAR(20) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert unique orders
REPLACE INTO Orders (OrderID, OrderDate, ShipDate, ShipMode, OrderPriority, CustomerID)
SELECT DISTINCT OrderID, OrderDate, ShipDate, ShipMode, OrderPriority, CustomerID
FROM SuperstoreFlat
WHERE OrderID IS NOT NULL;

-- Indexes to improve query performance
CREATE INDEX idx_orders_orderdate ON Orders(OrderDate);
CREATE INDEX idx_orders_customerid ON Orders(CustomerID);
CREATE INDEX idx_orders_shipdate ON Orders(ShipDate);
