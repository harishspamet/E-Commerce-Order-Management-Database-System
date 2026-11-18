## 🔒 Week 13: Database Security and Performance Optimization

### 1. Security & Access Control (RBAC)
Implemented strict role-based access control to protect sensitive data. 
- **Admin User:** Full database privileges.
- **Sales User:** `SELECT` access on Orders, Order_Items, and Customers. (Restricted from modifying payments).
- **Inventory User:** `SELECT` and `UPDATE` access on Products and Inventory.
- **Customer Support:** `SELECT` access on Customers, Orders, and Payments.

*Note: `GRANT` and `REVOKE` commands were utilized and verified using `SHOW GRANTS`.*

### 2. Performance Optimization (Indexing)
Created indexes on frequently searched columns to reduce query execution time.
- **Products:** Indexed `Product_Name`.
- **Orders:** Indexed `Order_Date` and `Customer_ID`.
- **Customers:** Prepared indexes for Email/Phone (dependent on schema).
- **Analysis:** Used the `EXPLAIN` command to verify index usage and optimize search queries.

---

