-- WEEK 9: SALES AND CUSTOMER ANALYTICS SYSTEM

  -- Name :Harish SP
  -- Roll NO: ASML25005
-- Database: ecoms_db

USE ecoms_db;

-- APPLY SQL AGGREGATE FUNCTIONS

<img width="203" height="111" alt="image" src="https://github.com/user-attachments/assets/86544864-86b2-44ee-8bd6-6aaf511d7ed4" />


-- GENERATE TOTAL SALES REPORTS

<img width="735" height="104" alt="image" src="https://github.com/user-attachments/assets/9b1d00e5-ef1d-46c6-a3de-bf6fee66d903" />



-- CUSTOMER PURCHASE ANALYSIS

-- 3.1 Total number of orders placed by each customer

-- FIND TOP CUSTOMERS BASED ON PURCHASE AMOUNT

<img width="429" height="198" alt="image" src="https://github.com/user-attachments/assets/370cdea0-0d22-4cbe-9311-8f1666336356" />



-- IDENTIFY BEST-SELLING PRODUCTS

<img width="429" height="198" alt="image" src="https://github.com/user-attachments/assets/63292107-c447-4f4e-8ce1-dd700194ee19" />


-- PERFORM CATEGORY-WISE SALES ANALYSIS

-- Report 1: Sales Performance Report

-- Displays: Total sales, Number of orders, Average order value, Highest order value

<img width="663" height="64" alt="image" src="https://github.com/user-attachments/assets/11467901-86c7-4fb9-9eb3-61a2551811b8" />



-- Report 2: Customer Analytics Report
-- Displays: Customer name, Number of orders, Total spending, Purchase frequency

<img width="670" height="162" alt="image" src="https://github.com/user-attachments/assets/e388d216-caf9-47e2-9fcf-ad5340105bed" />


-- Report 3: Product Performance Report

-- Displays: Product name, Quantity sold, Revenue generated\

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
