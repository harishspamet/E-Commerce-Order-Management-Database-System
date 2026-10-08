# Week 10 – Advanced SQL Query System

## 📌 Topic
**Subqueries & Nested Queries**

## 🗄️ Database
`ecoms_db`

## 1. Subqueries

### 1.1 Products Above Average Price

<img width="356" height="132" alt="image" src="https://github.com/user-attachments/assets/2f3f5d62-a972-4f39-9183-c5f399b96878" />

### 1.2 Customers with Orders Above ₹30,000

<img width="414" height="61" alt="image" src="https://github.com/user-attachments/assets/f94dfabe-1396-47bc-a7e8-b12fb84bdd9d" />


### 1.3 Average Customer Spending

<img width="233" height="71" alt="image" src="https://github.com/user-attachments/assets/577e18f7-aefe-4633-96b9-d9f4b85f1fcf" />


# 2. Products Above Average Price

### 2.1 Product, Category and Price
SELECT p.Product_Name, c.Category_Name, p.Price
FROM Products p
JOIN Category c ON p.Category_ID = c.Category_ID
WHERE p.Price > (SELECT AVG(Price) FROM Products);

### 2.2 Most Expensive Product in Each Category
SELECT c.Category_Name, p.Product_Name, p.Price
FROM Products p
JOIN Category c ON p.Category_ID = c.Category_ID
WHERE p.Price = (
    SELECT MAX(p2.Price)
    FROM Products p2
    WHERE p2.Category_ID = p.Category_ID
);



# 3. Customer Analysis

### 3.1 Highest Spending Customer
SELECT Customer_ID, SUM(Total_Amount) AS Total_Spent
FROM Orders
GROUP BY Customer_ID
ORDER BY Total_Spent DESC
LIMIT 1;

### 3.2 Customers with Maximum Orders
SELECT Customer_ID, COUNT(Order_ID) AS Total_Orders
FROM Orders
GROUP BY Customer_ID
ORDER BY Total_Orders DESC
LIMIT 1;

### 3.3 Top 5 Customers
SELECT c.Customer_Name, SUM(o.Total_Amount) AS Total_Spending
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Spending DESC
LIMIT 5;


# 4. Complex Business Queries

### 4.1 Best-Selling Product
SELECT p.Product_Name,
       SUM(od.Quantity) AS Quantity_Sold,
       SUM(od.Quantity * od.Unit_Price) AS Revenue
FROM Products p
JOIN Order_Details od ON p.Product_ID = od.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Quantity_Sold DESC
LIMIT 1;

### 4.2 High-Value Customers
SELECT c.Customer_Name, SUM(o.Total_Amount) AS Total_Spent
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
HAVING SUM(o.Total_Amount) > (
    SELECT AVG(Total)
    FROM (
        SELECT SUM(Total_Amount) AS Total
        FROM Orders
        GROUP BY Customer_ID
    ) AS T
);

### 4.3 Category Revenue
SELECT c.Category_Name,
       SUM(od.Quantity * od.Unit_Price) AS Revenue
FROM Category c
JOIN Products p ON c.Category_ID = p.Category_ID
JOIN Order_Details od ON p.Product_ID = od.Product_ID
GROUP BY c.Category_ID, c.Category_Name
ORDER BY Revenue DESC;


# 5. Advanced Reports

### 5.1 Premium Product Report
SELECT p.Product_Name, c.Category_Name, p.Price, p.Stock
FROM Products p
JOIN Category c ON p.Category_ID = c.Category_ID
WHERE p.Price > (SELECT AVG(Price) FROM Products);

### 5.2 Customer Value Report
SELECT c.Customer_Name,
       COUNT(o.Order_ID) AS Total_Orders,
       SUM(o.Total_Amount) AS Total_Spending
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Spending DESC;

### 5.3 Top 5 Selling Products
SELECT p.Product_Name,
       SUM(od.Quantity) AS Quantity_Sold
FROM Products p
JOIN Order_Details od ON p.Product_ID = od.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Quantity_Sold DESC
LIMIT 5;

### 5.4 Monthly Revenue
SELECT DATE_FORMAT(Order_Date, '%Y-%m') AS Month,
       SUM(Total_Amount) AS Revenue
FROM Orders
GROUP BY Month
ORDER BY Month;

## 🛠️ SQL Concepts Used
- `SELECT`
- `WHERE`
- `JOIN`
- `GROUP BY`
- `HAVING`
- `ORDER BY`
- `LIMIT`
- `SUM()`
- `AVG()`
- `MAX()`
- `COUNT()`
- Subqueries
- Nested Queries
- Correlated Subqueries

## 📂 Database Tables
- `Customer`
- `Orders`
- `Order_Details`
- `Products`
- `Category`

## ✅ Conclusion
This Week 10 project demonstrates how **advanced SQL queries** can be used to identify valuable customers, expensive products, best-selling products, category performance, and business trends.
