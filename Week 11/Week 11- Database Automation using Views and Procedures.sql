USE ecoms_db;

-- Create Tables if they don't exist
CREATE TABLE IF NOT EXISTS Customers (
    Customer_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_Name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Products (
    Product_ID INT PRIMARY KEY AUTO_INCREMENT,
    Product_Name VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL
);

CREATE TABLE IF NOT EXISTS Orders (
    Order_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10,2),
    Order_Status VARCHAR(50),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

CREATE TABLE IF NOT EXISTS Order_Items (
    Order_Item_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_ID INT,
    Product_ID INT,
    Quantity INT,
    Price DECIMAL(10,2),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);

CREATE TABLE IF NOT EXISTS Payments (
    Payment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_ID INT,
    Payment_Mode VARCHAR(50),
    Payment_Status VARCHAR(50),
    Transaction_Amount DECIMAL(10,2),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID)
);

SHOW TABLES;

-- Add some dummy data for testing
INSERT INTO Customers (Customer_Name) VALUES ('Arun'), ('Priya');
INSERT INTO Products (Product_Name, Price, Stock) VALUES ('Laptop', 750.00, 10), ('Mouse', 25.00, 50);


-- 1. Customer Order Report View

CREATE VIEW Customer_Order_Report AS
SELECT 
    c.Customer_Name, 
    o.Order_ID, 
    o.Order_Date, 
    o.Total_Amount, 
    o.Order_Status
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID;

-- 2. Product Sales Report View
CREATE VIEW Product_Sales_Report AS
SELECT 
    p.Product_Name, 
    SUM(oi.Quantity) AS Quantity_Sold, 
    SUM(oi.Quantity * oi.Price) AS Total_Revenue
FROM Products p
JOIN Order_Items oi ON p.Product_ID = oi.Product_ID
GROUP BY p.Product_ID, p.Product_Name;

-- 3. Payment Status View
CREATE VIEW Payment_Status_Report AS
SELECT 
    Order_ID, 
    Payment_Mode, 
    Payment_Status, 
    Transaction_Amount
FROM Payments;

-- ==========================================
-- CHANGE DELIMITER BEFORE PROCEDURES
-- ==========================================
DELIMITER //

-- 1. Add New Customer Order
CREATE PROCEDURE AddNewOrder(
    IN p_CustID INT, 
    IN p_ProdID INT, 
    IN p_Qty INT, 
    IN p_PayMode VARCHAR(50)
)
BEGIN
    DECLARE v_Price DECIMAL(10,2);
    DECLARE v_Total DECIMAL(10,2);
    DECLARE v_OrderID INT;

    SELECT Price INTO v_Price FROM Products WHERE Product_ID = p_ProdID;
    SET v_Total = v_Price * p_Qty;

    INSERT INTO Orders (Customer_ID, Order_Date, Total_Amount, Order_Status)
    VALUES (p_CustID, CURDATE(), v_Total, 'Pending');
    
    SET v_OrderID = LAST_INSERT_ID();

    INSERT INTO Order_Items (Order_ID, Product_ID, Quantity, Price)
    VALUES (v_OrderID, p_ProdID, p_Qty, v_Price);

    UPDATE Products SET Stock = Stock - p_Qty WHERE Product_ID = p_ProdID;

    INSERT INTO Payments (Order_ID, Payment_Mode, Payment_Status, Transaction_Amount)
    VALUES (v_OrderID, p_PayMode, 'Completed', v_Total);
END //

-- 2. Update Order Status
CREATE PROCEDURE UpdateOrderStatus(IN p_OrderID INT, IN p_NewStatus VARCHAR(50))
BEGIN
    UPDATE Orders SET Order_Status = p_NewStatus WHERE Order_ID = p_OrderID;
END //

-- 3. Generate Customer Purchase History
CREATE PROCEDURE GetCustomerPurchaseHistory(IN p_CustID INT)
BEGIN
    SELECT Order_ID, Order_Date, Total_Amount, Order_Status
    FROM Orders
    WHERE Customer_ID = p_CustID;
END //

-- ==========================================
-- FUNCTIONS
-- ==========================================
-- (Delimiter // is still active, so we can create functions)

-- 1. Calculate Total Sales (By Date Range)
CREATE FUNCTION CalculateTotalSales(p_StartDate DATE, p_EndDate DATE)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_TotalSales DECIMAL(10,2);
    SELECT SUM(Total_Amount) INTO v_TotalSales 
    FROM Orders 
    WHERE Order_Date BETWEEN p_StartDate AND p_EndDate;
    
    RETURN IFNULL(v_TotalSales, 0);
END //

-- 2. Calculate Customer Total Spending
CREATE FUNCTION CalculateCustomerSpending(p_CustID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_Spent DECIMAL(10,2);
    SELECT SUM(Total_Amount) INTO v_Spent 
    FROM Orders 
    WHERE Customer_ID = p_CustID;
    
    RETURN IFNULL(v_Spent, 0);
END //

-- 3. Calculate Product Revenue
CREATE FUNCTION CalculateProductRevenue(p_ProdID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_Revenue DECIMAL(10,2);
    SELECT SUM(Quantity * Price) INTO v_Revenue 
    FROM Order_Items 
    WHERE Product_ID = p_ProdID;
    
    RETURN IFNULL(v_Revenue, 0);
END //

-- ==========================================
-- CHANGE DELIMITER BACK TO SEMICOLON
-- ==========================================
DELIMITER ;


-- ==========================================
-- TESTING BLOCKS
-- ==========================================

-- Test 1: Check Views
SELECT * FROM Customer_Order_Report;
SELECT * FROM Product_Sales_Report;
SELECT * FROM Payment_Status_Report;

-- Test 2: Execute Procedures
-- (Assuming Customer 1 buys 2 units of Product 5 using UPI)
CALL AddNewOrder(1, 5, 2, 'UPI'); 
CALL UpdateOrderStatus(101, 'Shipped'); 
CALL GetCustomerPurchaseHistory(1);

-- Test 3: Test Functions 
SELECT CalculateTotalSales('2023-01-01', '2023-12-31') AS Total_Yearly_Sales;
SELECT CalculateCustomerSpending(1) AS Arun_Total_Spent;
SELECT CalculateProductRevenue(5) AS Laptop_Revenue;

-- Test 4: Inventory Automation Check (Low stock report)
SELECT Product_Name, Stock, 
       CASE WHEN Stock < 10 THEN 'Low Stock' ELSE 'In Stock' END AS Status 
FROM Products;