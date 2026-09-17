 BASIC SQL QUERIES

 
SELECT * FROM customer;

<img width="768" height="462" alt="image" src="https://github.com/user-attachments/assets/b19bb889-24be-4953-ba3a-fbcb654c050c" />

SELECT * FROM product;

<img width="667" height="366" alt="image" src="https://github.com/user-attachments/assets/0717b9a7-c923-4d6e-9656-4266fb1642a3" />

SELECT product_name, price FROM product;

<img width="328" height="419" alt="image" src="https://github.com/user-attachments/assets/86b1eb4c-ec2e-4f7a-a1f9-9c8dfcf7a14b" />

SELECT * FROM orders;

<img width="621" height="238" alt="image" src="https://github.com/user-attachments/assets/998499db-ec96-4072-976a-d1cd30175d7f" />

SELECT * FROM payment;

<img width="631" height="256" alt="image" src="https://github.com/user-attachments/assets/403e6b80-a78c-4cb3-95f8-dbd56ec6333b" />



-- Apply Filtering Conditions Using WHERE

<img width="615" height="66" alt="image" src="https://github.com/user-attachments/assets/33c7e0f5-df45-4340-91f5-fecaa3896246" />



-- Sort Data Using ORDER BY

<img width="619" height="242" alt="image" src="https://github.com/user-attachments/assets/d7e2d628-994f-4c10-8daa-5316c092b151" />



-- Retrieve Unique Values Using DISTINCT

<img width="205" height="271" alt="image" src="https://github.com/user-attachments/assets/3f5966a0-aab9-4a2d-bf58-792e72e78431" />



-- Search Products Based on Conditions

SELECT * FROM product 
WHERE price BETWEEN 1000 AND 5000;
SELECT * FROM product 
WHERE category_id = 1;
SELECT * FROM inventory 
WHERE quantity > 0;
SELECT * FROM product 
WHERE product_name LIKE 'S%';
SELECT * FROM inventory 
WHERE quantity < 10;


-- Retrieve Customer and Product Information 
SELECT c.*, o.*
FROM customer c
JOIN orders o ON c.customer_id = o.customer_id;

SELECT p.*, c.category_name
FROM product p
JOIN categories c ON p.category_id = c.category_id;

SELECT DISTINCT c.*
FROM customer c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
WHERE od.product_id = 101;

SELECT c.customer_name, p.product_name
FROM customer c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN product p ON od.product_id = p.product_id;


-- Multiple Filtering Conditions
SELECT * FROM product 
WHERE category_id = 1 AND price > 10000;
SELECT * FROM customer 
WHERE city = 'Chennai' OR city = 'Bangalore';
SELECT * FROM product 
WHERE product_name LIKE '%Mobile%';
SELECT * FROM orders 
WHERE order_date BETWEEN '2023-01-01' AND '2023-12-31';

-- REPORT 4:
-- Report 1: Product Availability Report
SELECT 
    product_name, 
    price, 
    stock_quantity,
    CASE 
        WHEN stock_quantity > 0 THEN 'In Stock'
        ELSE 'Out of Stock'
    END AS availability_status
FROM product;

-- Report 2: Customer Report
SELECT COUNT(*) AS total_customers FROM customer;
SELECT city, COUNT(*) AS customer_count 
FROM customer 
GROUP BY city;
SELECT * FROM customer 
ORDER BY registration_date DESC;

-- Report 3: Order Report
SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'Completed' THEN 1 ELSE 0 END) AS completed_orders,
    SUM(CASE WHEN order_status = 'Pending' THEN 1 ELSE 0 END) AS pending_orders,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders
FROM orders;

-- Report 4: Product Performance Report
SELECT * FROM product ORDER BY price DESC LIMIT 10;
SELECT p.product_name, COUNT(r.review_id) AS review_count
FROM product p
JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_name
ORDER BY review_count DESC;
SELECT * FROM product WHERE stock_quantity > 0;
