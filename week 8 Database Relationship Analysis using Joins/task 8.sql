-- DATABASE
USE ecoms_db;

--  INNER JOIN
-- 1.1 Display customer details along with their orders
SELECT 
    c.Customer_Name, 
    o.Order_ID, 
    o.Total_Amount
FROM Customer c
INNER JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID;

-- 1.2 Display order details with payment information
SELECT 
    o.Order_ID,
    o.Order_Date,
    o.Total_Amount,
    p.Payment_Mode,
    p.Payment_Status
FROM Orders o
INNER JOIN Payments p 
    ON o.Order_ID = p.Order_ID;

-- 1.3 Retrieve products purchased by customers
SELECT 
    c.Customer_Name,
    p.Product_Name,
    od.Quantity,
    o.Order_Date
FROM Customer c
INNER JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
INNER JOIN Order_Details od 
    ON o.Order_ID = od.Order_ID
INNER JOIN Products p 
    ON od.Product_ID = p.Product_ID
ORDER BY c.Customer_Name;


--  LEFT JOIN
-- 2.1 Display all customers including those who have not placed orders
SELECT 
    c.Customer_ID,
    c.Customer_Name,
    c.Email,
    o.Order_ID,
    o.Order_Date,
    o.Total_Amount
FROM Customer c
LEFT JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
ORDER BY c.Customer_ID;

-- 2.2 Find customers without any purchases
SELECT 
    c.Customer_ID,
    c.Customer_Name,
    c.Email
FROM Customer c
LEFT JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
WHERE o.Order_ID IS NULL
ORDER BY c.Customer_ID;

-- 2.3 Display all products including products with no sales
SELECT 
    p.Product_ID,
    p.Product_Name,
    p.Price,
    od.Order_ID,
    od.Quantity
FROM Products p
LEFT JOIN Order_Details od 
    ON p.Product_ID = od.Product_ID
ORDER BY p.Product_ID;


-- RIGHT JOIN
-- 3.1 Display all orders with customer information
SELECT 
    o.Order_ID,
    o.Order_Date,
    o.Total_Amount,
    c.Customer_ID,
    c.Customer_Name,
    c.Email
FROM Customer c
RIGHT JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
ORDER BY o.Order_ID;

-- 3.2 Find orders where customer details are missing
SELECT 
    o.Order_ID,
    o.Order_Date,
    o.Total_Amount
FROM Customer c
RIGHT JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
WHERE c.Customer_ID IS NULL
ORDER BY o.Order_ID;

-- 3.3 Display all payment records with order details
SELECT 
    p.Payment_ID,
    p.Payment_Mode,
    p.Payment_Status,
    o.Order_ID,
    o.Order_Date,
    o.Total_Amount
FROM Orders o
RIGHT JOIN Payments p 
    ON o.Order_ID = p.Order_ID
ORDER BY p.Payment_ID;


-- 4. COMPLETE ORDER REPORT
SELECT 
    c.Customer_Name    AS Customer,
    p.Product_Name     AS Product,
    od.Quantity        AS Quantity,
    o.Total_Amount     AS Amount,
    pay.Payment_Status AS Payment_Status
FROM Customer c
INNER JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
INNER JOIN Order_Details od 
    ON o.Order_ID = od.Order_ID
INNER JOIN Products p 
    ON od.Product_ID = p.Product_ID
LEFT JOIN Payments pay 
    ON o.Order_ID = pay.Order_ID
ORDER BY c.Customer_Name, o.Order_ID;


-- 5. CUSTOMER PURCHASE HISTORY
-- 5.1 All products purchased by customers
SELECT 
    c.Customer_Name,
    p.Product_Name,
    od.Quantity,
    od.Unit_Price,
    o.Order_Date
FROM Customer c
INNER JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
INNER JOIN Order_Details od 
    ON o.Order_ID = od.Order_ID
INNER JOIN Products p 
    ON od.Product_ID = p.Product_ID
ORDER BY c.Customer_Name, o.Order_Date;

-- 5.2 Total amount spent by each customer
SELECT 
    c.Customer_ID,
    c.Customer_Name,
    SUM(o.Total_Amount) AS Total_Spent
FROM Customer c
INNER JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Spent DESC;

-- 5.3 Number of orders placed by each customer
SELECT 
    c.Customer_ID,
    c.Customer_Name,
    COUNT(o.Order_ID) AS Total_Orders
FROM Customer c
LEFT JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Orders DESC;

-- 5.4 Latest purchase details of each customer
SELECT 
    c.Customer_Name,
    o.Order_ID,
    o.Order_Date,
    o.Total_Amount
FROM Customer c
INNER JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
WHERE o.Order_Date = (
    SELECT MAX(o2.Order_Date)
    FROM Orders o2
    WHERE o2.Customer_ID = o.Customer_ID
)
ORDER BY c.Customer_Name;


--  MULTI-TABLE BUSINESS REPORTS

-- Report 1: Customer Order Report
SELECT 
    c.Customer_Name,
    o.Order_ID,
    o.Order_Date,
    o.Order_Status
FROM Customer c
INNER JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
ORDER BY c.Customer_Name;

-- Report 2: Sales Report
SELECT 
    p.Product_Name,
    SUM(od.Quantity)                 AS Quantity_Sold,
    SUM(od.Quantity * od.Unit_Price) AS Total_Revenue
FROM Products p
INNER JOIN Order_Details od 
    ON p.Product_ID = od.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Total_Revenue DESC;

-- Report 3: Payment Analysis Report
SELECT 
    Payment_Mode,
    COUNT(*) AS Number_of_Transactions,
    SUM(CASE WHEN Payment_Status = 'Success' THEN 1 ELSE 0 END) AS Successful_Payments
FROM Payments
GROUP BY Payment_Mode
ORDER BY Number_of_Transactions DESC;


-- Report 4: Customer Purchase Analysis
-- 4a. Top purchasing customers (by quantity)
SELECT 
    c.Customer_Name,
    SUM(od.Quantity) AS Total_Quantity
FROM Customer c
INNER JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
INNER JOIN Order_Details od 
    ON o.Order_ID = od.Order_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Quantity DESC;

-- 4b. Customers with maximum orders
SELECT 
    c.Customer_Name,
    COUNT(o.Order_ID) AS Total_Orders
FROM Customer c
INNER JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Orders DESC;

-- 4c. Customers with highest spending
SELECT 
    c.Customer_Name,
    SUM(o.Total_Amount) AS Total_Spending
FROM Customer c
INNER JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Spending DESC;