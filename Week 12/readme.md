 Week 12: Transaction Management System (MySQL)

This repository contains the SQL implementation for an E-Commerce Transaction Management System. It demonstrates how to ensure database consistency during complex operations (like placing an order) using SQL Transactions (`COMMIT` and `ROLLBACK`).

<img width="225" height="93" alt="image" src="https://github.com/user-attachments/assets/490a462c-0180-41c6-a04f-5fbdf90d0a0e" />

## 📌 Scenario
During order placement, multiple database operations must happen together (creating an order, updating stock, recording payment). If any step fails (e.g., payment declined), the entire process must be cancelled to prevent orphaned data or negative inventory.

## 🗂️ Prerequisites
Ensure the `ecoms_db` database exists and the basic tables (`Customers`, `Products`, `Orders`, `Order_Items`, `Payments`) are created. 
*The script automatically handles adding the `Inventory` table and the `Stock` column to the `Products` table if they are missing.*

## 🚀 What the Script Does

### 1. Successful Order (COMMIT)
Simulates a customer purchasing a Laptop using UPI.
- Inserts a new order.
- Adds the item to `Order_Items`.
- Reduces stock in both `Inventory` and `Products`.
- Records a successful payment.
- Updates order status to 'Completed'.
- **Executes `COMMIT`** to permanently save all changes.

### 2. Failed Order (ROLLBACK)
Simulates a customer attempting to purchase a Laptop, but the payment fails.
- Creates a temporary order and reduces stock.
- Records a failed payment.
- **Executes `ROLLBACK`** to completely undo the order creation and restore the inventory stock, maintaining database consistency.

### 3. Database Consistency Checks
Includes queries to verify:
- No orphaned orders (valid Customer IDs).
- No orphaned payments (valid Order IDs).
- No negative stock quantities.
- Completed orders only have successful payments.

### 4. Transaction Reports
Generates three final reports:
- **Order Transaction Report:** Shows order details, customer names, and payment/order statuses.
- 
<img width="640" height="141" alt="image" src="https://github.com/user-attachments/assets/a2d8fae6-4f38-46a3-8bff-9b0e336a8f2c" />

- **Failed Transaction Report:** Filters for any failed payments or cancelled orders.

- <img width="642" height="105" alt="image" src="https://github.com/user-attachments/assets/94b72efd-8413-4d3c-8b55-b5022523943d" />

- **Inventory Update Report:** Shows previous stock, current stock, and total quantity sold.

<img width="721" height="331" alt="image" src="https://github.com/user-attachments/assets/df96ec55-596c-4e2c-a75d-a493d2374c44" />


## 🛠️ How to Run
1. Open MySQL Workbench.
2. Paste the entire SQL script into a new tab.
3. Click **"Execute All"** (the lightning bolt with the script icon) or press `Ctrl + Shift + Enter`. 
*(Note: Do not run line-by-line, as it contains `START TRANSACTION` blocks that must execute sequentially).*

## 📝 ACID Properties Demonstrated
- **Atomicity:** The `ROLLBACK` in Scenario 2 proves that if one part fails, the entire transaction is undone.
- **Consistency:** The verification queries prove stock never goes negative and data remains valid.
- **Isolation:** `START TRANSACTION` ensures that concurrent users don't interfere with each other's stock deductions.
- **Durability:** The `COMMIT` in Scenario 1 ensures that once the order is completed, it is permanently saved to the database disk.



