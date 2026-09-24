Database Relationship Analysis using Joins


-- DATABASE


USE ecoms_db;

--  INNER JOIN
-- 1.1 Display customer details along with their orders

<img width="426" height="229" alt="image" src="https://github.com/user-attachments/assets/66b53c52-5d99-47eb-9669-71f498b98ddd" />


-- 1.2 Display order details with payment information


-- 1.3 Retrieve products purchased by customers

<img width="559" height="64" alt="image" src="https://github.com/user-attachments/assets/8d0807f4-20aa-4745-a049-d40a65892390" />



--  LEFT JOIN
-- 2.1 Display all customers including those who have not placed orders

<img width="858" height="319" alt="image" src="https://github.com/user-attachments/assets/45bfda4d-392f-4059-8462-a4c9aa8e3b35" />


-- 2.2 Find customers without any purchases

<img width="512" height="438" alt="image" src="https://github.com/user-attachments/assets/423d0ff7-9284-4ea1-a269-a4a6d34e773a" />


-- 2.3 Display all products including products with no sales

<img width="655" height="297" alt="image" src="https://github.com/user-attachments/assets/1e891c44-2a29-4ff6-b0d3-0f99b2b56b09" />


-- RIGHT JOIN
-- 3.1 Display all orders with customer information

<img width="794" height="229" alt="image" src="https://github.com/user-attachments/assets/3304f1c1-1e79-42bf-8386-75621ae6e2fe" />


-- 3.2 Find orders where customer details are missing

<img width="401" height="81" alt="image" src="https://github.com/user-attachments/assets/fb54e2a4-fa8b-4af5-8eb3-d981758eeda8" />

-- 3.3 Display all payment records with order details


-- 4. COMPLETE ORDER REPORT

   
-- 5. CUSTOMER PURCHASE HISTORY
-- 5.1 All products purchased by customers


-- 5.2 Total amount spent by each customer

<img width="447" height="152" alt="image" src="https://github.com/user-attachments/assets/cedef4b4-0099-48df-bb3e-0d01d996078c" />


-- 5.3 Number of orders placed by each customer

<img width="437" height="373" alt="image" src="https://github.com/user-attachments/assets/c84be341-814f-4d7b-a018-570a301cedce" />


-- 5.4 Latest purchase details of each customer

<img width="533" height="226" alt="image" src="https://github.com/user-attachments/assets/b0159e06-dfb6-4a13-95ca-d3d0937c747d" />


--  MULTI-TABLE BUSINESS REPORTS

-- Report 1: Customer Order Report

<img width="520" height="225" alt="image" src="https://github.com/user-attachments/assets/7f5e2254-af8b-485b-b5a0-9b71fa259315" />


-- Report 2: Sales Report


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
