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

<img width="326" height="87" alt="image" src="https://github.com/user-attachments/assets/ac94ba96-2805-4d9d-bc4c-731f0f182a54" />


### 3.2 Customers with Maximum Orders

<img width="337" height="88" alt="image" src="https://github.com/user-attachments/assets/27241b80-5fe4-4d8d-b716-0dbfdb2bfa1e" />

### 3.3 Top 5 Customers

<img width="325" height="147" alt="image" src="https://github.com/user-attachments/assets/ea23cfd8-686b-4a7b-af97-fb32b63fc4d0" />



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

<img width="324" height="90" alt="image" src="https://github.com/user-attachments/assets/b306fe5d-611e-4e0f-b6e0-f0f28e2a3f53" />


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

<img width="470" height="136" alt="image" src="https://github.com/user-attachments/assets/39679088-aedd-41e2-990d-ffeb1ae41d40" />

### 5.3 Top 5 Selling Products

<img width="315" height="68" alt="image" src="https://github.com/user-attachments/assets/14ee10e3-b63e-4a87-b643-4355f8bc5e0f" />


### 5.4 Monthly Revenue

<img width="223" height="80" alt="image" src="https://github.com/user-attachments/assets/ece42508-4911-40ab-bceb-4e4f3337957b" />

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
