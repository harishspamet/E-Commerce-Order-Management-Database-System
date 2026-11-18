# Week 11: Database Automation using Views and Procedures

A complete SQL script for automating an E-Commerce database (`ecoms_db`). Includes schema creation, reporting views, stored procedures, and functions.


## 📌 Features
- **Schema Setup:** Creates tables (`Customers`, `Products`, `Orders`, `Order_Items`, `Payments`) with foreign keys.
- 
<img width="245" height="208" alt="image" src="https://github.com/user-attachments/assets/ddb0ad21-7082-4144-a35b-60bc579817ad" />


- **Views:** `Customer_Order_Report`, `Product_Sales_Report`, `Payment_Status_Report`.

<img width="763" height="149" alt="image" src="https://github.com/user-attachments/assets/549ca652-1e47-4bd1-b599-0f38d119a192" />

<img width="739" height="91" alt="image" src="https://github.com/user-attachments/assets/2ed01a6b-b898-4696-a72f-8620b148ee20" />

<img width="301" height="112" alt="image" src="https://github.com/user-attachments/assets/6e003eb4-d91a-4111-9de2-8beaf733e36e" />


- **Procedures:** `AddNewOrder` (auto-handles stock, orders, payments), `UpdateOrderStatus`, `GetCustomerPurchaseHistory`.
- **Functions:** `CalculateTotalSales`, `CalculateCustomerSpending`, `CalculateProductRevenue`.

## 🚀 How to Run
1. Open MySQL Workbench.
2. Paste the entire script.
3. **Execute All** (`Ctrl + Shift + Enter`). 
   *(Do not run line-by-line — the script uses `DELIMITER //` for procedures).*

## 🧪 Testing
Insert dummy data first to avoid foreign key errors:
INSERT INTO Customers (Customer_Name) VALUES ('Arun'), ('Priya');
INSERT INTO Products (Product_Name, Price, Stock) VALUES ('Laptop', 750.00, 10), ('Mouse', 25.00, 50);
