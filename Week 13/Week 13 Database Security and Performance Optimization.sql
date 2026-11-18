USE ecoms_db;

CREATE USER IF NOT EXISTS 'admin_user'@'localhost' IDENTIFIED BY 'AdminPass123!';
GRANT ALL PRIVILEGES ON ecoms_db.* TO 'admin_user'@'localhost';

CREATE USER IF NOT EXISTS 'sales_user'@'localhost' IDENTIFIED BY 'SalesPass123!';
GRANT SELECT ON ecoms_db.Orders TO 'sales_user'@'localhost';
GRANT SELECT ON ecoms_db.Order_Items TO 'sales_user'@'localhost';
GRANT SELECT ON ecoms_db.Customers TO 'sales_user'@'localhost';

CREATE USER IF NOT EXISTS 'inventory_user'@'localhost' IDENTIFIED BY 'InvPass123!';
GRANT SELECT, UPDATE ON ecoms_db.Inventory TO 'inventory_user'@'localhost';
GRANT SELECT, UPDATE ON ecoms_db.Products TO 'inventory_user'@'localhost';

CREATE USER IF NOT EXISTS 'support_user'@'localhost' IDENTIFIED BY 'SupportPass123!';
GRANT SELECT ON ecoms_db.Customers TO 'support_user'@'localhost';
GRANT SELECT ON ecoms_db.Orders TO 'support_user'@'localhost';
GRANT SELECT ON ecoms_db.Payments TO 'support_user'@'localhost';

REVOKE INSERT ON ecoms_db.Payments FROM 'sales_user'@'localhost';

FLUSH PRIVILEGES;

CREATE INDEX idx_product_name ON Products(Product_Name);
CREATE INDEX idx_order_date ON Orders(Order_Date);
CREATE INDEX idx_order_customer ON Orders(Customer_ID);

EXPLAIN SELECT * FROM Products WHERE Product_Name = 'Laptop';

SELECT * FROM Orders WHERE Customer_ID = 101;

SELECT o.Order_Date, SUM(oi.Quantity * oi.Price) AS Daily_Revenue 
FROM Orders o JOIN Order_Items oi ON o.Order_ID = oi.Order_ID 
GROUP BY o.Order_Date;

SELECT User, Host FROM mysql.user WHERE User LIKE '%_user';

SHOW GRANTS FOR 'sales_user'@'localhost';
SHOW GRANTS FOR 'inventory_user'@'localhost';