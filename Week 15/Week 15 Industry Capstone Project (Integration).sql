USE ecoms_db;

-- =====================================================================
-- CAPSTONE REQUIREMENT: UNIFIED INTELLIGENCE VIEW
-- =====================================================================
-- This view combines data from all tables to create a single platform for 
-- Business Intelligence, tracking customer, product, order, and payment data.

CREATE OR REPLACE VIEW Capstone_Ecommerce_Intelligence_View AS
SELECT 
    o.Order_ID,
    o.Order_Date,
    c.Customer_ID,
    c.Customer_Name,
    p.Product_ID,
    p.Product_Name,
    oi.Quantity AS Quantity_Purchased,
    oi.Price AS Unit_Price,
    (oi.Quantity * oi.Price) AS Line_Item_Revenue,
    o.Total_Amount AS Total_Order_Amount,
    o.Order_Status,
    pay.Payment_Mode,
    pay.Payment_Status
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
JOIN Products p ON oi.Product_ID = p.Product_ID
LEFT JOIN Payments pay ON o.Order_ID = pay.Order_ID;

-- =====================================================================
-- CAPSTONE ANALYTICS: EXECUTIVE DASHBOARD QUERIES
-- =====================================================================

-- 1. Overall Platform Health (Total Revenue & Orders)
SELECT '--- EXECUTIVE SUMMARY ---' AS '';
SELECT 
    COUNT(DISTINCT Order_ID) AS Total_Orders_Processed,
    SUM(Total_Order_Amount) AS Total_Gross_Revenue,
    COUNT(DISTINCT Customer_ID) AS Total_Active_Customers
FROM Capstone_Ecommerce_Intelligence_View;

-- 2. Top 5 Best-Selling Products
SELECT '--- TOP 5 PRODUCTS ---' AS '';
SELECT 
    Product_Name,
    SUM(Quantity_Purchased) AS Total_Units_Sold,
    SUM(Line_Item_Revenue) AS Total_Revenue
FROM Capstone_Ecommerce_Intelligence_View
GROUP BY Product_Name
ORDER BY Total_Units_Sold DESC
LIMIT 5;

-- 3. Payment Gateway Success Rate
SELECT '--- PAYMENT GATEWAY PERFORMANCE ---' AS '';
SELECT 
    Payment_Mode,
    COUNT(Order_ID) AS Total_Transactions,
    SUM(CASE WHEN Payment_Status = 'Success' THEN 1 ELSE 0 END) AS Successful_Payments,
    CONCAT(ROUND((SUM(CASE WHEN Payment_Status = 'Success' THEN 1 ELSE 0 END) / COUNT(Order_ID)) * 100, 2), '%') AS Success_Rate
FROM Capstone_Ecommerce_Intelligence_View
GROUP BY Payment_Mode;

-- =====================================================================
-- FINAL VERIFICATION: SHOW ALL CREATED OBJECTS
-- =====================================================================
-- Proves the complete database solution is in place.
SELECT '--- DATABASE OBJECTS CREATED ---' AS '';
SELECT TABLE_NAME AS 'Tables/Views' FROM information_schema.tables WHERE table_schema = 'ecoms_db';