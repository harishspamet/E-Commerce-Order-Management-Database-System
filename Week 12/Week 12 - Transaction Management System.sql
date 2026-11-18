-- =====================================================================
-- WEEK 12: TRANSACTION MANAGEMENT SYSTEM
-- =====================================================================

-- ---------------------------------------------------------------------
-- PRE-REQUISITE: Ensure Tables and Data Exist (Fixes previous errors)
-- ---------------------------------------------------------------------
USE ecoms_db;

-- Create Inventory table (required for Week 12)
CREATE TABLE IF NOT EXISTS Inventory (
    Product_ID INT PRIMARY KEY,
    Stock_Quantity INT NOT NULL,
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);

-- Ensure 'Stock' column exists in Products table
-- (Using a dynamic check to add it only if it's missing)
SET @dbname = 'ecoms_db';
SET @tablename = 'Products';
SET @columnname = 'Stock';
SET @preparedStatement = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = @tablename AND COLUMN_NAME = @columnname) > 0,
  'SELECT 1;',
  'ALTER TABLE Products ADD COLUMN Stock INT DEFAULT 0;'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Insert Dummy Data
INSERT IGNORE INTO Customers (Customer_ID, Customer_Name) VALUES (101, 'Arun');
INSERT IGNORE INTO Products (Product_ID, Product_Name, Price, Stock) VALUES (1, 'Laptop', 55000.00, 10), (2, 'Mouse', 500.00, 50);
INSERT IGNORE INTO Inventory (Product_ID, Stock_Quantity) VALUES (1, 10), (2, 50);


-- =====================================================================
-- TASK 1 & 4: SCENARIO 1 - SUCCESSFUL PURCHASE TRANSACTION
-- =====================================================================
-- Customer 101 buys 1 Laptop (Product 1) using UPI. Total = 55000.

START TRANSACTION;

-- 1. Insert order details
INSERT INTO Orders (Order_ID, Customer_ID, Order_Date, Total_Amount, Order_Status) 
VALUES (5001, 101, CURDATE(), 55000.00, 'Pending');

-- 2. Insert ordered products
INSERT INTO Order_Items (Order_ID, Product_ID, Quantity, Price) 
VALUES (5001, 1, 1, 55000.00);

-- 3. Reduce inventory stock (Update both tables to keep them in sync)
UPDATE Inventory SET Stock_Quantity = Stock_Quantity - 1 WHERE Product_ID = 1;
UPDATE Products SET Stock = Stock - 1 WHERE Product_ID = 1;

-- 4. Insert payment details
INSERT INTO Payments (Order_ID, Payment_Mode, Payment_Status, Transaction_Amount) 
VALUES (5001, 'UPI', 'Success', 55000.00);

-- 5. Update order status as Completed
UPDATE Orders SET Order_Status = 'Completed' WHERE Order_ID = 5001;

-- If all steps above succeed without error, save permanently
COMMIT;

-- Verify Success:
SELECT '--- SUCCESSFUL TRANSACTION COMMITTED ---' AS Status;
SELECT * FROM Orders WHERE Order_ID = 5001;


-- =====================================================================
-- TASK 2 & 4: SCENARIO 2 - FAILED PAYMENT TRANSACTION (ROLLBACK)
-- =====================================================================
-- Customer 101 tries to buy 1 Laptop (Product 1), but payment fails.

START TRANSACTION;

-- 1. Create temporary order
INSERT INTO Orders (Order_ID, Customer_ID, Order_Date, Total_Amount, Order_Status) 
VALUES (5002, 101, CURDATE(), 55000.00, 'Pending');

-- 2. Insert ordered products
INSERT INTO Order_Items (Order_ID, Product_ID, Quantity, Price) 
VALUES (5002, 1, 1, 55000.00);

-- 3. Reduce inventory stock
UPDATE Inventory SET Stock_Quantity = Stock_Quantity - 1 WHERE Product_ID = 1;
UPDATE Products SET Stock = Stock - 1 WHERE Product_ID = 1;

-- 4. Record Payment (Simulating a failure here)
INSERT INTO Payments (Order_ID, Payment_Mode, Payment_Status, Transaction_Amount) 
VALUES (5002, 'Credit Card', 'Failed', 55000.00);

-- 💥 Payment failed! We must cancel the entire order.
-- Execute ROLLBACK to undo all the INSERTS and UPDATES above.
ROLLBACK;

-- Verify Failure: Order 5002 should not exist, stock should be restored
SELECT '--- FAILED TRANSACTION ROLLED BACK ---' AS Status;
SELECT * FROM Orders WHERE Order_ID = 5002; 
-- (Should return 0 rows)
SELECT Stock_Quantity FROM Inventory WHERE Product_ID = 1; 
-- (Should be back to 9, since 5001 succeeded but 5002 was rolled back)


-- =====================================================================
-- TASK 5: ENSURE DATABASE CONSISTENCY (Verification Queries)
-- =====================================================================

-- 1. Orders should have valid customer IDs (Returns 0 rows if consistent)
SELECT 'Check 1: Orphan Orders' AS Check_Type;
SELECT * FROM Orders o LEFT JOIN Customers c ON o.Customer_ID = c.Customer_ID WHERE c.Customer_ID IS NULL;

-- 2. Payments should have valid order IDs (Returns 0 rows)
SELECT 'Check 2: Orphan Payments' AS Check_Type;
SELECT * FROM Payments p LEFT JOIN Orders o ON p.Order_ID = o.Order_ID WHERE o.Order_ID IS NULL;

-- 3. Stock quantity should not become negative (Returns 0 rows)
SELECT 'Check 3: Negative Stock' AS Check_Type;
SELECT * FROM Inventory WHERE Stock_Quantity < 0;

-- 4. Completed orders should have successful payments (Returns 0 rows)
SELECT 'Check 4: Completed Orders with Failed Payments' AS Check_Type;
SELECT o.Order_ID, o.Order_Status, p.Payment_Status 
FROM Orders o JOIN Payments p ON o.Order_ID = p.Order_ID 
WHERE o.Order_Status = 'Completed' AND p.Payment_Status != 'Success';


-- =====================================================================
-- GENERATE TRANSACTION REPORTS
-- =====================================================================

-- Report 1: Order Transaction Report
SELECT '--- REPORT 1: ORDER TRANSACTION ---' AS '';
SELECT 
    o.Order_ID, 
    c.Customer_Name, 
    o.Total_Amount AS Amount, 
    p.Payment_Status, 
    o.Order_Status
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
JOIN Payments p ON o.Order_ID = p.Order_ID
ORDER BY o.Order_ID DESC;

-- Report 2: Failed Transaction Report
SELECT '--- REPORT 2: FAILED TRANSACTIONS ---' AS '';
-- Note: Because we used ROLLBACK in Scenario 2, that specific failed order does not exist. 
-- This report will show any historically failed payments that were saved to the DB.
SELECT 
    o.Order_ID, 
    p.Payment_Mode, 
    p.Payment_Status, 
    o.Order_Status
FROM Orders o
JOIN Payments p ON o.Order_ID = p.Order_ID
WHERE p.Payment_Status = 'Failed' OR o.Order_Status = 'Cancelled';

-- Report 3: Inventory Update Report
SELECT '--- REPORT 3: INVENTORY UPDATE ---' AS '';
SELECT 
    p.Product_Name, 
    10 AS Previous_Stock, -- Assuming initial stock was 10
    i.Stock_Quantity AS Current_Stock, 
    (10 - i.Stock_Quantity) AS Quantity_Sold
FROM Inventory i
JOIN Products p ON i.Product_ID = p.Product_ID;