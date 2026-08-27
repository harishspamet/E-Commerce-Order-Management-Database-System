-- TASK 4: ORDER MANAGEMENT SYSTEM - COMPLETE

-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS ecoms_db;

-- 2. SELECT DATABASE
USE ecoms_db;

-- 3. DROP OLD TABLES (in correct order)
DROP TABLE IF EXISTS Order_Details;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Customer;

-- 4. CREATE CUSTOMER TABLE (MISSING)
CREATE TABLE Customer (
    Customer_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50)
);

-- 5. CREATE PRODUCT TABLE (MISSING)
CREATE TABLE Product (
    Product_ID INT AUTO_INCREMENT PRIMARY KEY,
    Product_Name VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    Stock_Quantity INT DEFAULT 0
);

-- 6. CREATE ORDERS TABLE
CREATE TABLE Orders (
    Order_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Order_Date DATE NOT NULL DEFAULT (CURRENT_DATE),
    Total_Amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    Order_Status ENUM(
        'Pending',
        'Shipped',
        'Delivered',
        'Cancelled'
    ) NOT NULL DEFAULT 'Pending',

    FOREIGN KEY (Customer_ID)
        REFERENCES Customer(Customer_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CHECK (Total_Amount >= 0)
);

-- 7. CREATE ORDER_DETAILS TABLE
CREATE TABLE Order_Details (
    Order_Detail_ID INT AUTO_INCREMENT PRIMARY KEY,
    Order_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (Product_ID)
        REFERENCES Product(Product_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CHECK (Quantity > 0),
    CHECK (Price >= 0)
);

-- 8. INSERT DATA

-- Insert Customers
INSERT INTO Customer (Customer_ID, Customer_Name, Email, Phone, City) VALUES
(1, 'Rahul Sharma', 'rahul@email.com', '9876543210', 'Delhi'),
(2, 'Priya Patel', 'priya@email.com', '9876543211', 'Mumbai'),
(3, 'Amit Singh', 'amit@email.com', '9876543212', 'Bangalore'),
(4, 'Sneha Reddy', 'sneha@email.com', '9876543213', 'Hyderabad');

-- Insert Products
INSERT INTO Product (Product_ID, Product_Name, Category, Price, Stock_Quantity) VALUES
(1, 'Laptop', 'Electronics', 55000.00, 10),
(2, 'Mouse', 'Accessories', 500.00, 50),
(3, 'Keyboard', 'Accessories', 1200.00, 30),
(4, 'Smartphone', 'Electronics', 25000.00, 15),
(5, 'Headphones', 'Audio', 3000.00, 20);

-- Insert Orders
INSERT INTO Orders (Customer_ID, Order_Date, Total_Amount, Order_Status) VALUES
(1, '2026-08-20', 1500.00, 'Pending'),
(2, '2026-08-21', 2500.00, 'Shipped'),
(3, '2026-08-22', 999.00, 'Delivered'),
(4, '2026-08-23', 750.00, 'Cancelled');

-- Insert Order Details
INSERT INTO Order_Details (Order_ID, Product_ID, Quantity, Price) VALUES
(1, 1, 2, 500.00),
(1, 2, 1, 500.00),
(2, 3, 2, 1250.00),
(3, 4, 1, 999.00),
(4, 5, 1, 750.00);


-- 9. VIEW ALL DATA

SELECT '=== CUSTOMERS ===' AS '';
SELECT * FROM Customer;

SELECT '=== PRODUCTS ===' AS '';
SELECT * FROM Product;

SELECT '=== ORDERS ===' AS '';
SELECT * FROM Orders;

SELECT '=== ORDER DETAILS ===' AS '';
SELECT * FROM Order_Details;

-- 10. MODIFY ORDER

UPDATE Orders
SET Order_Status = 'Shipped'
WHERE Order_ID = 1;

UPDATE Orders
SET Total_Amount = 1600.00
WHERE Order_ID = 1;

-- 11. CUSTOMER ORDER HISTORY

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

-- 12. CUSTOMER-WISE ORDER SUMMARY

SELECT
    Customer_ID,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Total_Amount) AS Total_Spent
FROM Orders
GROUP BY Customer_ID
ORDER BY Total_Spent DESC;

-- 13. ORDER STATUS REPORT

SELECT
    Order_Status,
    COUNT(*) AS Total_Orders,
    SUM(Total_Amount) AS Total_Amount
FROM Orders
GROUP BY Order_Status;

-- 14. DELETE ORDER

DELETE FROM Orders
WHERE Order_ID = 4;

-- 
-- 15. FINAL ORDER REPORT (After Delete)

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

-- 16. ADDITIONAL REPORTS

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