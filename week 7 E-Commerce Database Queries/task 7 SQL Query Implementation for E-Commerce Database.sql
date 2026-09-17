USE ecoms_db;
--  BASIC SQL QUERIES
SELECT * FROM customer;
SELECT * FROM product;
SELECT product_name, price FROM product;
SELECT * FROM orders;
SELECT * FROM payment;

-- Apply Filtering Conditions Using WHERE
SELECT * FROM product 
WHERE price > 5000;
SELECT * FROM product 
WHERE stock_quantity > 0;
SELECT * FROM customer 
WHERE city = 'Chennai';
SELECT * FROM orders 
WHERE order_status = 'Completed';
SELECT * FROM product 
WHERE rating > 4;

-- Sort Data Using ORDER BY
SELECT * FROM product 
ORDER BY price ASC;
SELECT * FROM customer 
ORDER BY customer_name ASC;
SELECT * FROM product 
ORDER BY price DESC;
SELECT * FROM orders 
ORDER BY order_date DESC;

-- Retrieve Unique Values Using DISTINCT
SELECT DISTINCT category_id FROM product;
SELECT DISTINCT payment_method FROM payment;
SELECT DISTINCT city FROM customer;


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