-- File: Views.sql
-- Purpose: Define analytical views for easier querying and reporting.
-- Notes:
--  - vw_OrderAnalysis: Combines all core tables into a single denormalized view 
--    for detailed order-level analysis.
--  - vw_CustomerCategoryYear: Provides aggregated sales and profit data 
--    grouped by Customer, Product Category, and Year.

CREATE OR REPLACE VIEW vw_OrderAnalysis AS
SELECT 
    o.OrderID,
    o.OrderDate,
    o.ShipDate,
    o.ShipMode,
    o.OrderPriority,
    c.CustomerID,
    c.CustomerName,
    c.Segment,
    c.City,
    c.State,
    c.Country,
    c.Region,
    p.ProductID,
    p.Category,
    p.SubCategory,
    p.ProductName,
    od.Quantity,
    od.Sales,
    od.Discount,
    od.Profit,
    od.ShippingCost
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID;

CREATE OR REPLACE VIEW vw_CustomerCategoryYear AS
SELECT 
    c.CustomerID,
    c.CustomerName,
    p.Category,
    YEAR(o.OrderDate) AS OrderYear,
    SUM(od.Sales) AS TotalSales,
    SUM(od.Profit) AS TotalProfit
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName, p.Category, OrderYear;
