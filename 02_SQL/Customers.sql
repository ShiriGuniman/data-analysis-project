-- File: Customers.sql
-- Purpose: Create and populate the Customers dimension table from the 
--          SuperstoreFlat dataset. This table stores unique customer 
--          details for use in analytics and reporting.
-- Notes:
--  - Uses REPLACE INTO to handle duplicates caused by multiple products per order.
--  - Includes indexes on Country and City columns to improve query performance.

CREATE TABLE IF NOT EXISTS Customers (
    CustomerID VARCHAR(20) NOT NULL PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Segment VARCHAR(50) DEFAULT 'Consumer',
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50),
    PostalCode VARCHAR(20),
    Market VARCHAR(50),
    Region VARCHAR(50)
);

-- Insert unique customers
REPLACE INTO Customers (CustomerID, CustomerName, Segment, City, State, Country, PostalCode, Market, Region)
SELECT DISTINCT CustomerID, CustomerName, Segment, City, State, Country, PostalCode, Market, Region
FROM SuperstoreFlat
WHERE CustomerID IS NOT NULL;

-- Indexes to Improve Query Performance
CREATE INDEX idx_customers_country ON Customers(Country);
CREATE INDEX idx_customers_city ON Customers(City);