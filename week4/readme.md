-- =============================================
-- TASK 4: ORDER MANAGEMENT SYSTEM - COMPLETE
-- =============================================

-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS ecoms_db;

-- 2. SELECT DATABASE
USE ecoms_db;

-- 3. DROP OLD TABLES (in correct order)
DROP TABLE IF EXISTS Order_Details;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Customer;

-- =============================================
-- 4. CREATE CUSTOMER TABLE (MISSING)
-- =============================================
<img width="681" height="159" alt="image" src="https://github.com/user-attachments/assets/9000544d-4b5b-450c-a6a1-8a06bb315626" />

-- =============================================
-- 5. CREATE PRODUCT TABLE (MISSING)
-- =============================================
<img width="614" height="187" alt="image" src="https://github.com/user-attachments/assets/320753fe-7564-437f-a44a-961acb1add5a" />
-- =============================================
-- CREATE ORDERS TABLE
-- =============================================
<img width="615" height="161" alt="image" src="https://github.com/user-attachments/assets/461fd6bc-eaf2-496a-9077-5660830bedc8" />
);
-- =============================================
-- 7. CREATE ORDER_DETAILS TABLE
-- =============================================
<img width="552" height="190" alt="image" src="https://github.com/user-attachments/assets/391973de-e86f-40aa-a0c0-d6743d5573fc" />

-- =============================================
-- 8. INSERT DATA
-- =============================================

-- Insert Customers
<img width="681" height="159" alt="image" src="https://github.com/user-attachments/assets/9000544d-4b5b-450c-a6a1-8a06bb315626" />
-- Insert Products
<img width="614" height="187" alt="image" src="https://github.com/user-attachments/assets/320753fe-7564-437f-a44a-961acb1add5a" />

-- Insert Orders
INSERT INTO Orders (Customer_ID, Order_Date, Total_Amount, Order_Status) VALUES
<img width="1036" height="174" alt="image" src="https://github.com/user-attachments/assets/0da3533e-74b8-4edc-917c-1f3e17ef4c51" />


-- Insert Order Details
INSERT INTO Order_Details (Order_ID, Product_ID, Quantity, Price) VALUES
<img width="415" height="159" alt="image" src="https://github.com/user-attachments/assets/5ab21714-af0d-4d37-9f19-851e96554b6f" />


-- =============================================
-- 9. VIEW ALL DATA
-- =============================================

SELECT '=== CUSTOMERS ===' AS '';
SELECT * FROM Customer;

SELECT '=== PRODUCTS ===' AS '';
SELECT * FROM Product;

SELECT '=== ORDERS ===' AS '';
SELECT * FROM Orders;

SELECT '=== ORDER DETAILS ===' AS '';
SELECT * FROM Order_Details;

-- =============================================
-- 10. MODIFY ORDER
-- =============================================

UPDATE Orders
SET Order_Status = 'Shipped'
WHERE Order_ID = 1;

UPDATE Orders
SET Total_Amount = 1600.00
WHERE Order_ID = 1;

-- =============================================
-- 11. CUSTOMER ORDER HISTORY
-- =============================================

SELECT
    o.Order_ID,
    c.Customer_Name,
    o.Order_Date,
    p.Product_Name,
    od.Quantity,
    od.Price,
    (od.Quantity * od.Price) AS Item_Total,
    o.Total_Amount,
    o.Order_Status
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
JOIN Order_Details od ON o.Order_ID = od.Order_ID
JOIN Product p ON od.Product_ID = p.Product_ID
ORDER BY o.Customer_ID, o.Order_Date;

-- =============================================
-- 12. CUSTOMER-WISE ORDER SUMMARY
-- =============================================

SELECT
    Customer_ID,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Total_Amount) AS Total_Spent
FROM Orders
GROUP BY Customer_ID
ORDER BY Total_Spent DESC;

-- =============================================
-- 13. ORDER STATUS REPORT
-- =============================================

SELECT
    Order_Status,
    COUNT(*) AS Total_Orders,
    SUM(Total_Amount) AS Total_Amount
FROM Orders
GROUP BY Order_Status;

-- =============================================
-- 14. DELETE ORDER
-- =============================================

DELETE FROM Orders
WHERE Order_ID = 4;

-- =============================================
-- 15. FINAL ORDER REPORT (After Delete)
-- =============================================

SELECT
    o.Order_ID,
    c.Customer_Name,
    o.Order_Date,
    p.Product_Name,
    od.Quantity,
    od.Price,
    (od.Quantity * od.Price) AS Item_Total,
    o.Total_Amount,
    o.Order_Status
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
JOIN Order_Details od ON o.Order_ID = od.Order_ID
JOIN Product p ON od.Product_ID = p.Product_ID
ORDER BY o.Order_ID;

-- =============================================
-- 16. ADDITIONAL REPORTS
-- =============================================

-- Report: Orders by Customer
SELECT '=== ORDERS BY CUSTOMER ===' AS '';
SELECT 
    c.Customer_Name,
    COUNT(o.Order_ID) AS Number_Of_Orders,
    SUM(o.Total_Amount) AS Total_Spent,
    ROUND(AVG(o.Total_Amount), 2) AS Average_Order_Value
FROM Customer c
LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID
ORDER BY Total_Spent DESC;

-- Report: Product Popularity
SELECT '=== PRODUCT POPULARITY ===' AS '';
SELECT 
    p.Product_Name,
    p.Category,
    COUNT(od.Order_ID) AS Times_Ordered,
    SUM(od.Quantity) AS Total_Quantity_Sold,
    SUM(od.Quantity * od.Price) AS Total_Revenue
FROM Product p
LEFT JOIN Order_Details od ON p.Product_ID = od.Product_ID
GROUP BY p.Product_ID
ORDER BY Total_Quantity_Sold DESC;

-- Report: Order Status Distribution
SELECT '=== ORDER STATUS DISTRIBUTION ===' AS '';
SELECT 
    Order_Status,
    COUNT(*) AS Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Orders), 2) AS Percentage
FROM Orders
GROUP BY Order_Status;
