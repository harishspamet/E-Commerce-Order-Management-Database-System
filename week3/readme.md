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
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_products_categories
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
-- Create Seller and Inventory Management System table
CREATE TABLE sellers (
    seller_id INT AUTO_INCREMENT PRIMARY KEY,
    store_name VARCHAR(120) NOT NULL UNIQUE,
    contact_email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20),
    city VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE inventory (
    item_id INT AUTO_INCREMENT PRIMARY KEY,

    product_id INT NOT NULL,
    seller_id INT NOT NULL,

    sku VARCHAR(50) NOT NULL UNIQUE,
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    stock_quantity INT NOT NULL DEFAULT 0
        CHECK (stock_quantity >= 0),
    reorder_level INT NOT NULL DEFAULT 10
        CHECK (reorder_level >= 0),
    last_restocked TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_inventory_seller
        FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
-- INSERT (CREATE)
-- Insert Categories
INSERT INTO categories
(category_name, description)
VALUES
('Electronics', 'Electronic devices and accessories'),
('Home Appliances', 'Home and kitchen appliances'),
('Books & Stationery', 'Books and stationery products'),
('Apparel', 'Clothing and fashion products'),
('Furniture', 'Home and office furniture');
SELECT * FROM categories;

-- Insert Products
INSERT INTO products
(product_name, category_id, price)
VALUES
('Noise Cancelling Headphones', 1, 59.99),
('Samsung 55-inch Smart TV', 1, 499.00),
('Dell Inspiron 15 Laptop', 1, 1199.50),
('LG Microwave Oven 20L', 2, 85.00),
('Washing Machine 7KG', 2, 399.99),
('Learning SQL Book', 3, 29.99),
('Gel Pens Pack of 10', 3, 4.50),
('Mens Cotton Polo T-Shirt', 4, 19.99),
('Executive Office Chair', 5, 150.00),
('Bluetooth Speaker', 1, 45.00);
SELECT * FROM products;

-- Insert sellers
INSERT INTO sellers
(store_name, contact_email, phone_number, city)
VALUES
('Chennai Electronics',
 'chennai.electronics@gmail.com',
 '9876543210',
 'Chennai'),
('Smart Home Store',
 'smarthome@gmail.com',
 '9876543211',
 'Chennai'),
('City Book House',
 'citybookhouse@gmail.com',
 '9876543212',
 'Chennai'),
('Fashion World',
 'fashionworld@gmail.com',
 '9876543213',
 'Chennai'),
('Office Furniture Hub',
 'officefurniture@gmail.com',
 '9876543214',
 'Chennai');
 SELECT * FROM sellers;
 
 -- Insert inventory
 INSERT INTO inventory
(product_id, seller_id, sku, unit_price, stock_quantity, reorder_level)
VALUES
(1, 1, 'ELEC-001', 59.99, 120, 20),
(2, 1, 'ELEC-002', 499.00, 30, 10),
(3, 1, 'ELEC-003', 1199.50, 15, 5),
(4, 2, 'HOME-001', 85.00, 45, 10),
(5, 2, 'HOME-002', 399.99, 5, 10),
(6, 3, 'BOOK-001', 29.99, 200, 30),
(7, 3, 'BOOK-002', 4.50, 500, 50),
(8, 4, 'APP-001', 19.99, 0, 10),
(9, 5, 'FURN-001', 150.00, 20, 5),
(10, 1, 'ELEC-004', 45.00, 8, 10);

-- VIEW SELLER + PRODUCT + STOCK
SELECT
    s.store_name,
    p.product_name,
    i.stock_quantity,
    i.unit_price
FROM inventory i
JOIN sellers s
    ON i.seller_id = s.seller_id
JOIN products p
    ON i.product_id = p.product_id;


-- AVAILABLE PRODUCTS
SELECT
    p.product_name,
    s.store_name,
    i.stock_quantity
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
JOIN sellers s
    ON i.seller_id = s.seller_id
WHERE i.stock_quantity > 0;


-- UNAVAILABLE PRODUCTS
SELECT
    p.product_name,
    s.store_name,
    i.stock_quantity
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
JOIN sellers s
    ON i.seller_id = s.seller_id
WHERE i.stock_quantity = 0;

-- LOW STOCK PRODUCTS
SELECT
    p.product_name,
    i.stock_quantity,
    i.reorder_level
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
WHERE i.stock_quantity <= i.reorder_level;

-- INVENTORY STATUS REPORT
SELECT
    p.product_name,
    s.store_name,
    i.stock_quantity,
    CASE
        WHEN i.stock_quantity = 0 THEN 'UNAVAILABLE'
        WHEN i.stock_quantity <= i.reorder_level THEN 'LOW STOCK'
        ELSE 'AVAILABLE'
    END AS status
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
JOIN sellers s
    ON i.seller_id = s.seller_id;

-- INVENTORY VALUE
SELECT
    p.product_name,
    i.stock_quantity,
    i.unit_price,
    (i.stock_quantity * i.unit_price) AS inventory_value
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id;
    
-- SELLER-WISE REPORT
SELECT
    s.store_name,
    COUNT(i.item_id) AS total_products,
    SUM(i.stock_quantity) AS total_stock
FROM sellers s
JOIN inventory i
    ON s.seller_id = i.seller_id
GROUP BY s.store_name;

-- CATEGORY-WISE REPORT
SELECT
    c.category_name,
    COUNT(i.item_id) AS total_products,
    SUM(i.stock_quantity) AS total_stock
FROM categories c
JOIN products p
    ON c.category_id = p.category_id
JOIN inventory i
    ON p.product_id = i.product_id
GROUP BY c.category_name;

--  TOTAL PRODUCTS
SELECT COUNT(*) AS total_products
FROM products;

--  TOTAL STOCK
SELECT SUM(stock_quantity) AS total_stock
FROM inventory;

-- TOTAL INVENTORY VALUE
SELECT
    SUM(stock_quantity * unit_price) AS total_inventory_value
FROM inventory;

--  RESTOCK PRODUCT
UPDATE inventory
SET
    stock_quantity = stock_quantity + 10,
    last_restocked = CURRENT_TIMESTAMP
WHERE product_id = 5;

-- REDUCE STOCK AFTER SALE
UPDATE inventory
SET stock_quantity = stock_quantity - 5
WHERE product_id = 1
AND stock_quantity >= 5;

-- FINAL REPORT
SELECT
    s.store_name AS seller,
    p.product_name,
    i.stock_quantity,
    i.unit_price,
    CASE
        WHEN i.stock_quantity = 0 THEN 'UNAVAILABLE'
        WHEN i.stock_quantity <= i.reorder_level THEN 'LOW STOCK'
        ELSE 'AVAILABLE'
    END AS status
FROM inventory i
JOIN sellers s
    ON i.seller_id = s.seller_id
JOIN products p
    ON i.product_id = p.product_id
ORDER BY s.store_name;
