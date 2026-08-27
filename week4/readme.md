-- TASK 4: ORDER MANAGEMENT SYSTEM - COMPLETE

--  CREATE DATABASE
CREATE DATABASE IF NOT EXISTS ecoms_db;

--  SELECT DATABASE
USE ecoms_db;

--  DROP OLD TABLES (in correct order)
DROP TABLE IF EXISTS Order_Details;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Customer;

--  INSERT DATA

-- Insert Customers
<img width="688" height="190" alt="image" src="https://github.com/user-attachments/assets/9139b459-195e-422e-ac02-158d5f8b1471" />

-- Insert Products
<img width="613" height="180" alt="image" src="https://github.com/user-attachments/assets/cacc3469-a675-4720-803a-f37b677ab28d" />

-- Insert Orders
INSERT INTO Orders (Customer_ID, Order_Date, Total_Amount, Order_Status) VALUES
<img width="610" height="149" alt="image" src="https://github.com/user-attachments/assets/dc267c4c-4420-4f02-b9a8-28993f7e5fb2" />

-- Insert Order Details
INSERT INTO Order_Details (Order_ID, Product_ID, Quantity, Price) VALUES
<img width="556" height="188" alt="image" src="https://github.com/user-attachments/assets/526eb2ce-e534-4846-9ae9-b25159fc9a40" />

-- VIEW ALL DATA

SELECT '=== CUSTOMERS ===' AS '';
SELECT * FROM Customer;
<img width="556" height="188" alt="image" src="https://github.com/user-attachments/assets/3f2251dd-a76d-4350-bd2c-78bcfafdf811" />

SELECT '=== PRODUCTS ===' AS '';
SELECT * FROM Product;


SELECT '=== ORDERS ===' AS '';
SELECT * FROM Orders;
<img width="1050" height="169" alt="image" src="https://github.com/user-attachments/assets/3be4b7b0-3537-4db4-8e02-616b2a6b74e3" />

SELECT '=== ORDER DETAILS ===' AS '';
SELECT * FROM Order_Details;
<img width="491" height="177" alt="image" src="https://github.com/user-attachments/assets/19a67337-c265-4792-91d2-519040fd9d53" />

-- MODIFY ORDER

UPDATE Orders
SET Order_Status = 'Shipped'
WHERE Order_ID = 1;

UPDATE Orders
SET Total_Amount = 1600.00
WHERE Order_ID = 1;

-- CUSTOMER ORDER HISTORY

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


-- CUSTOMER-WISE ORDER SUMMARY

SELECT
    Customer_ID,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Total_Amount) AS Total_Spent
FROM Orders
GROUP BY Customer_ID
ORDER BY Total_Spent DESC;

-- ORDER STATUS REPORT

SELECT
    Order_Status,
    COUNT(*) AS Total_Orders,
    SUM(Total_Amount) AS Total_Amount
FROM Orders
GROUP BY Order_Status;
<img width="420" height="151" alt="image" src="https://github.com/user-attachments/assets/0d003e0f-3475-494b-a75c-2e81cd317d04" />



-- DELETE ORDER

DELETE FROM Orders
WHERE Order_ID = 4;
<img width="1043" height="154" alt="image" src="https://github.com/user-attachments/assets/1aea2b31-ece2-471a-a868-c9a784a8dcf0" />


-- FINAL ORDER REPORT (After Delete)

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

-- ADDITIONAL REPORTS

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
