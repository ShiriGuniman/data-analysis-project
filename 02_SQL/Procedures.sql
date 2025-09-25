-- File: Procedures.sql
-- Purpose: Stored procedures for reusable analytical operations.
-- Notes:
--  - sp_TopCustomersByProfit: Returns the top N customers ranked by total profit,
--    including total sales and number of orders.
--  - Can be called with different values of topN for flexible reporting.
--  - Example usage provided at the end of the file.

DELIMITER $$

CREATE PROCEDURE sp_TopCustomersByProfit(IN topN INT)
BEGIN
    SELECT 
        c.CustomerID,
        c.CustomerName,
        SUM(od.Profit) AS TotalProfit,
        SUM(od.Sales) AS TotalSales,
        COUNT(DISTINCT o.OrderID) AS NumOrders
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY c.CustomerID, c.CustomerName
    ORDER BY TotalProfit DESC
    LIMIT topN;
END $$

DELIMITER ;

-- Example Call
CALL sp_TopCustomersByProfit(5);
