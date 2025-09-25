-- File: Queries.sql
-- Purpose: Analytical SQL queries for sales, profit, shipping, and customer insights.
-- Notes:
--  - Includes queries with aggregations, subqueries, conditional logic, and date functions.
--  - Demonstrates use of JOINs, UNION, and INTERSECT-style logic.
--  - Some queries use the vw_OrderAnalysis view for simplified joins and aggregation.
--  - Useful for dashboards, reporting, and business analysis.

-- 1) Orders with late shipping (>7 days)
SELECT OrderID, DATEDIFF(ShipDate, OrderDate) AS DaysToShip
FROM Orders
WHERE DATEDIFF(ShipDate, OrderDate) > 7;

-- 2) Sales and Profit by Category and Year
SELECT YEAR(o.OrderDate) AS Year, p.Category,
       ROUND(SUM(od.Sales),2) AS TotalSales,
       ROUND(SUM(od.Profit),2) AS TotalProfit
FROM Orders o
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY Year, p.Category
ORDER BY Year, TotalSales DESC;

-- 3) Sales by Month
SELECT 
    DATE_FORMAT(OrderDate, '%Y-%m') AS YearMonth,
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit
FROM vw_OrderAnalysis
GROUP BY YearMonth
ORDER BY YearMonth;

-- 4) Categories with Highest Profit
SELECT 
    Category,
    SubCategory,
    SUM(Profit) AS TotalProfit
FROM vw_OrderAnalysis
GROUP BY Category, SubCategory
ORDER BY TotalProfit DESC;

-- 5) Top 5 Products by Total Profit
SELECT 
    p.ProductID,
    p.ProductName,
    p.Category,
    p.SubCategory,
    SUM(od.Profit) AS TotalProfit,
    SUM(od.Sales) AS TotalSales,
    SUM(od.Quantity) AS TotalQuantity
FROM Products p
INNER JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category, p.SubCategory
ORDER BY TotalProfit DESC
LIMIT 5;

-- 6) Customers with Most Orders
SELECT 
    CustomerID,
    CustomerName,
    COUNT(DISTINCT OrderID) AS NumOrders,
    SUM(Sales) AS TotalSales
FROM vw_OrderAnalysis
GROUP BY CustomerID, CustomerName
ORDER BY NumOrders DESC
LIMIT 10;

-- 7) Average Shipping Time by ShipMode
SELECT 
    ShipMode,
    AVG(DATEDIFF(ShipDate, OrderDate)) AS AvgShippingDays
FROM Orders
GROUP BY ShipMode;

-- 8) Sales by Country
SELECT 
    Country,
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit
FROM vw_OrderAnalysis
GROUP BY Country
ORDER BY TotalSales DESC;

-- 9) Customers with Highest Profit
SELECT c.CustomerName, ROUND(SUM(od.Profit),2) AS TotalProfit
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerName
ORDER BY TotalProfit DESC
LIMIT 10;

-- 10) All Customers and their Total Sales and Profit (including customers without orders)
SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(od.Sales) AS TotalSales,
    SUM(od.Profit) AS TotalProfit,
    COUNT(DISTINCT o.OrderID) AS NumOrders
FROM Customers c
LEFT OUTER JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT OUTER JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSales DESC;

-- 11) Products with a Profitability Flag (Profitable / Loss)
SELECT 
    ProductID,
    ProductName,
    SUM(Profit) AS TotalProfit,
    IF(SUM(Profit) > 0, 'Profitable', 'Loss') AS ProfitStatus
FROM vw_OrderAnalysis
GROUP BY ProductID, ProductName
ORDER BY TotalProfit DESC;

-- 12) Customers without orders in the last 365 days
SELECT c.CustomerID, c.CustomerName
FROM Customers c
WHERE c.CustomerID NOT IN (
    SELECT o.CustomerID
    FROM Orders o
    WHERE o.OrderDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);

-- 13) Products with profit higher than all products in the 'Furniture' category
SELECT p.ProductID, p.ProductName, SUM(od.Profit) AS TotalProfit
FROM Products p
INNER JOIN OrderDetails od ON p.ProductID = od.ProductID
WHERE p.Category = 'Furniture'
GROUP BY p.ProductID, p.ProductName
HAVING SUM(od.Profit) > ALL (
    SELECT SUM(od2.Profit)
    FROM Products p2
    INNER JOIN OrderDetails od2 ON p2.ProductID = od2.ProductID
    WHERE p2.Category = 'Furniture' AND p2.ProductID <> p.ProductID
    GROUP BY p2.ProductID
);

-- 14) Customers who purchased in 2013 AND also in 2014 (INTERSECT style)
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM Customers c
WHERE c.CustomerID IN (
    SELECT o13.CustomerID
    FROM Orders o13
    WHERE YEAR(o13.OrderDate) = 2013
)
AND c.CustomerID IN (
    SELECT o14.CustomerID
    FROM Orders o14
    WHERE YEAR(o14.OrderDate) = 2014
);


-- 15) Union of customers from Europe and APAC markets
SELECT CustomerID, CustomerName, Market
FROM Customers
WHERE Market = 'Europe'
UNION
SELECT CustomerID, CustomerName, Market
FROM Customers
WHERE Market = 'APAC';

