-- WEEK 9: SALES AND CUSTOMER ANALYTICS SYSTEM
-- Database: ecoms_db

USE ecoms_db;

-- APPLY SQL AGGREGATE FUNCTIONS

-- COUNT: Total number of customers
SELECT COUNT(*) AS Total_Customers FROM Customer;

-- COUNT: Total number of orders
SELECT COUNT(*) AS Total_Orders FROM Orders;

-- SUM: Total sales amount
SELECT SUM(Total_Amount) AS Total_Sales FROM Orders;

-- AVG: Average order value
SELECT ROUND(AVG(Total_Amount), 2) AS Avg_Order_Value FROM Orders;

-- MIN: Lowest order amount
SELECT MIN(Total_Amount) AS Lowest_Order FROM Orders;

-- MAX: Highest order amount
SELECT MAX(Total_Amount) AS Highest_Order FROM Orders;

-- GENERATE TOTAL SALES REPORTS

-- 2.1 Total number of orders placed
SELECT COUNT(*) AS Total_Orders 
FROM Orders;

-- 2.2 Total revenue generated from sales
SELECT SUM(Total_Amount) AS Total_Revenue 
FROM Orders;

-- 2.3 Average order value
SELECT ROUND(AVG(Total_Amount), 2) AS Avg_Order_Value 
FROM Orders;

-- 2.4 Highest and lowest order amount
SELECT 
    MAX(Total_Amount) AS Highest_Order,
    MIN(Total_Amount) AS Lowest_Order
FROM Orders;

-- 2.5 Total sales for a specific period (July–August 2026)
SELECT 
    COUNT(*)          AS Orders,
    SUM(Total_Amount) AS Total_Sales
FROM Orders
WHERE Order_Date BETWEEN '2026-07-01' AND '2026-08-31';

-- 2.6 Complete Sales Summary Report
SELECT 
    COUNT(*)                    AS Total_Orders,
    SUM(Total_Amount)           AS Total_Revenue,
    ROUND(AVG(Total_Amount), 2) AS Avg_Order_Value,
    MAX(Total_Amount)           AS Highest_Order,
    MIN(Total_Amount)           AS Lowest_Order
FROM Orders;


-- CUSTOMER PURCHASE ANALYSIS

-- 3.1 Total number of orders placed by each customer
SELECT 
    c.Customer_ID,
    c.Customer_Name,
    COUNT(o.Order_ID) AS Total_Orders
FROM Customer c
JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Orders DESC;

-- 3.2 Total amount spent by each customer
SELECT 
    c.Customer_ID,
    c.Customer_Name,
    SUM(o.Total_Amount) AS Total_Spending
FROM Customer c
JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Spending DESC;

-- 3.3 Average spending per customer
SELECT 
    ROUND(SUM(Total_Amount) / COUNT(DISTINCT Customer_ID), 2) AS Avg_Spending_Per_Customer
FROM Orders;

-- 3.4 Customers with maximum purchase amount
SELECT 
    c.Customer_ID,
    c.Customer_Name,
    SUM(o.Total_Amount) AS Total_Spending
FROM Customer c
JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Spending DESC
LIMIT 1;

-- 3.5 Customers with fewer purchases
SELECT 
    c.Customer_ID,
    c.Customer_Name,
    COUNT(o.Order_ID) AS Total_Orders
FROM Customer c
LEFT JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Orders ASC
LIMIT 5;

-- FIND TOP CUSTOMERS BASED ON PURCHASE AMOUNT

-- 4.1 Top 5 customers based on total spending
SELECT 
    c.Customer_ID,
    c.Customer_Name,
    SUM(o.Total_Amount) AS Spending
FROM Customer c
JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Spending DESC
LIMIT 5;

-- 4.2 Customers with maximum number of orders
SELECT 
    c.Customer_ID,
    c.Customer_Name,
    COUNT(o.Order_ID) AS Total_Orders
FROM Customer c
JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Orders DESC;

-- 4.3 Frequent customers (2 or more orders)
SELECT 
    c.Customer_ID,
    c.Customer_Name,
    COUNT(o.Order_ID) AS Total_Orders
FROM Customer c
JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
HAVING COUNT(o.Order_ID) >= 2
ORDER BY Total_Orders DESC;

-- 4.4 High-value customers (spending above 3000)
SELECT 
    c.Customer_ID,
    c.Customer_Name,
    SUM(o.Total_Amount) AS Total_Spending
FROM Customer c
JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
HAVING SUM(o.Total_Amount) > 3000
ORDER BY Total_Spending DESC;


-- IDENTIFY BEST-SELLING PRODUCTS

-- 5.1 Products with maximum sales quantity
SELECT 
    p.Product_ID,
    p.Product_Name,
    SUM(od.Quantity) AS Total_Sold
FROM Products p
JOIN Order_Details od 
    ON p.Product_ID = od.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Total_Sold DESC;

-- 5.2 Products generating highest revenue
SELECT 
    p.Product_ID,
    p.Product_Name,
    SUM(od.Quantity * od.Unit_Price) AS Revenue
FROM Products p
JOIN Order_Details od 
    ON p.Product_ID = od.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Revenue DESC;

-- 5.3 Least-selling products (including zero sales)
SELECT 
    p.Product_ID,
    p.Product_Name,
    COALESCE(SUM(od.Quantity), 0) AS Total_Sold
FROM Products p
LEFT JOIN Order_Details od 
    ON p.Product_ID = od.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Total_Sold ASC
LIMIT 5;

-- 5.4 Products requiring promotion (lowest revenue)
SELECT 
    p.Product_ID,
    p.Product_Name,
    COALESCE(SUM(od.Quantity * od.Unit_Price), 0) AS Revenue
FROM Products p
LEFT JOIN Order_Details od 
    ON p.Product_ID = od.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Revenue ASC
LIMIT 5;


-- PERFORM CATEGORY-WISE SALES ANALYSIS

-- 6.1 Total sales generated by each category
SELECT 
    cat.Category_ID,
    cat.Category_Name,
    SUM(od.Quantity * od.Unit_Price) AS Category_Sales
FROM Category cat
JOIN Products p 
    ON cat.Category_ID = p.Category_ID
JOIN Order_Details od 
    ON p.Product_ID = od.Product_ID
GROUP BY cat.Category_ID, cat.Category_Name
ORDER BY Category_Sales DESC;

-- 6.2 Number of products sold in each category
SELECT 
    cat.Category_ID,
    cat.Category_Name,
    SUM(od.Quantity) AS Products_Sold
FROM Category cat
JOIN Products p 
    ON cat.Category_ID = p.Category_ID
JOIN Order_Details od 
    ON p.Product_ID = od.Product_ID
GROUP BY cat.Category_ID, cat.Category_Name
ORDER BY Products_Sold DESC;

-- 6.3 Highest revenue-generating category
SELECT 
    cat.Category_ID,
    cat.Category_Name,
    SUM(od.Quantity * od.Unit_Price) AS Total_Revenue
FROM Category cat
JOIN Products p 
    ON cat.Category_ID = p.Category_ID
JOIN Order_Details od 
    ON p.Product_ID = od.Product_ID
GROUP BY cat.Category_ID, cat.Category_Name
ORDER BY Total_Revenue DESC
LIMIT 1;

-- 6.4 Average sales per category
SELECT 
    ROUND(AVG(t.Category_Sales), 2) AS Avg_Sales_Per_Category
FROM (
    SELECT SUM(od.Quantity * od.Unit_Price) AS Category_Sales
    FROM Products p
    JOIN Order_Details od 
        ON p.Product_ID = od.Product_ID
    GROUP BY p.Category_ID
) t;

-- Report 1: Sales Performance Report
-- Displays: Total sales, Number of orders, Average order value, Highest order value
SELECT 
    SUM(Total_Amount)           AS Total_Sales,
    COUNT(*)                    AS Number_of_Orders,
    ROUND(AVG(Total_Amount), 2) AS Avg_Order_Value,
    MAX(Total_Amount)           AS Highest_Order_Value
FROM Orders;


-- Report 2: Customer Analytics Report
-- Displays: Customer name, Number of orders, Total spending, Purchase frequency
SELECT 
    c.Customer_Name,
    COUNT(o.Order_ID)   AS Number_of_Orders,
    SUM(o.Total_Amount) AS Total_Spending,
    ROUND(AVG(o.Total_Amount), 2) AS Purchase_Frequency
FROM Customer c
JOIN Orders o 
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Spending DESC;


-- Report 3: Product Performance Report
-- Displays: Product name, Quantity sold, Revenue generated
SELECT 
    p.Product_Name,
    SUM(od.Quantity)                 AS Quantity_Sold,
    SUM(od.Quantity * od.Unit_Price) AS Revenue_Generated
FROM Products p
JOIN Order_Details od 
    ON p.Product_ID = od.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Revenue_Generated DESC;


-- Report 4: Category Analysis Report
-- Displays: Category name, Total products sold, Total revenue
SELECT 
    cat.Category_Name,
    SUM(od.Quantity)                 AS Total_Products_Sold,
    SUM(od.Quantity * od.Unit_Price) AS Total_Revenue
FROM Category cat
JOIN Products p 
    ON cat.Category_ID = p.Category_ID
JOIN Order_Details od 
    ON p.Product_ID = od.Product_ID
GROUP BY cat.Category_ID, cat.Category_Name
ORDER BY Total_Revenue DESC;