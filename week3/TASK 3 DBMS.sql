-- Seller and Inventory Management System

-- Create Seller table

create table sellers (
seller_id INT Primary Key Auto_Increment,
store_name VARCHAR(120) NOT NULL UNIQUE,
contact_email VARCHAR(100) NOT NULL UNIQUE,
phone_number VARCHAR(20),
city VARCHAR(50),
created_at TIMESTAMP DEFAULT current_timestamp
);

-- inventory Table
create table Inventory(
item_id INT Primary Key Auto_Increment,
item_name VARCHAR(150) NOT NULL,
seller_id INT NOT NULL,
sku VARCHAR(50) UNIQUE,
unit_price DECIMAL(10, 2) NOT NULL,
stock_quantity INT NOT NULL DEFAULT 0,
reorder_level INT DEFAULT 10,
last_restocked TIMESTAMP DEFAULT current_timestamp,

CONSTRAINT fk_sellers_inventory
        FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
