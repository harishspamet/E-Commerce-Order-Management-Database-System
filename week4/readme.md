-- INVENTORY MANAGEMENT SYSTEM DATABASE

                 -- STEP 1: DATABASE & TABLE SCHEMA CREATION
-- Delete existing database (if it exists)
DROP DATABASE IF EXISTS inventory_db;

-- Create Database
CREATE DATABASE inventory_db;

-- Select Database
USE inventory_db;

-- CREATE CATEGORIES TABLE

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CREATE PRODUCTS TABLE

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_products_categories
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

              
			-- STEP 2: DATA MANIPULATION (CRUD OPERATIONS)
            
-- INSERT (CREATE)
-- Insert Categories

INSERT INTO categories (category_name, description)
VALUES
('Electronics', 'Gadgets, devices, and electronic accessories'),
('Home Appliances', 'Appliances for home, kitchen, and living rooms'),
('Books & Stationery', 'Books, notebooks, and office supplies'),
('Apparel', 'Clothing, footwear, and accessories');

-- Insert Products

INSERT INTO products (product_name, category_id, price, stock_quantity)
VALUES
('Noise Cancelling Headphones', 1, 59.99, 120),
('Samsung 55-inch Smart TV', 1, 499.00, 30),
('Dell Inspiron 15 Laptop', 1, 1199.50, 15),
('LG Microwave Oven 20L', 2, 85.00, 45),
('Executive Office Chair', 2, 150.00, 20),
('Learning SQL Book', 3, 29.99, 200),
('Gel Pens (Pack of 10)', 3, 4.50, 500),
('Men''s Cotton Polo T-Shirt', 4, 19.99, 150);

-- Display Records

SELECT * FROM categories;
SELECT * FROM products;

-- UPDATE (MODIFY DATA)

-- Update Product ID = 1

UPDATE products
SET
    price = 54.99,
    stock_quantity = 140
WHERE product_id = 1;

-- Increase price by 10% for Electronics products

UPDATE products
SET price = price * 1.10
WHERE category_id = 1;

-- View Updated Records

SELECT * FROM products;

-- DELETE (REMOVE DATA)

-- Delete Product ID = 8

DELETE FROM products
WHERE product_id = 8;

-- Delete Category ID = 4
-- Related products will also be deleted because of ON DELETE CASCADE

DELETE FROM categories
WHERE category_id = 4;

-- View Remaining Records

SELECT * FROM categories;
SELECT * FROM products;
 
-- STEP 3: CATEGORY-WISE PRODUCT REPORTS

-- REPORT 1: COMPLETE PRODUCT CATALOG

SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.price,
    p.stock_quantity,
    (p.price * p.stock_quantity) AS total_inventory_value
FROM products AS p
INNER JOIN categories AS c
ON p.category_id = c.category_id
ORDER BY c.category_name, p.product_name;

-- REPORT 2: CATEGORY SUMMARY REPORT

SELECT
    c.category_id,
    c.category_name,
    COUNT(p.product_id) AS total_products,
    ROUND(AVG(p.price), 2) AS average_price,
    SUM(p.stock_quantity) AS total_stock_count,
    SUM(p.price * p.stock_quantity) AS total_category_value
FROM categories AS c
LEFT JOIN products AS p
ON c.category_id = p.category_id
GROUP BY
    c.category_id,
    c.category_name
ORDER BY total_category_value DESC;

-- REPORT 3: LOW-STOCK INVENTORY ALERT

SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.stock_quantity
FROM products AS p
INNER JOIN categories AS c
ON p.category_id = c.category_id
WHERE p.stock_quantity < 25
ORDER BY p.stock_quantity ASC;
