-- Seller and Inventory Management System

-- Create Sellers table
CREATE TABLE sellers (
    seller_id INT PRIMARY KEY AUTO_INCREMENT,
    store_name VARCHAR(120) NOT NULL UNIQUE,
    contact_email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20),
    city VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE inventory (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(150) NOT NULL,
    seller_id INT NOT NULL,
    sku VARCHAR(50) UNIQUE,
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    reorder_level INT DEFAULT 10 CHECK (reorder_level >= 0),
    last_restocked TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT fk_sellers_inventory
        FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

