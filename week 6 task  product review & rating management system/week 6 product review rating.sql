USE ecoms_db;

-- Remove old reviews
DROP TABLE IF EXISTS reviews;
-- Remove old products to start fresh
DROP TABLE IF EXISTS Product;


-- Create Product table
CREATE TABLE Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);


-- Create Reviews table
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_date DATE DEFAULT (CURRENT_DATE),

    -- Customer relationship
    CONSTRAINT fk_reviews_customers
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    -- Product relationship
    CONSTRAINT fk_reviews_products
        FOREIGN KEY (product_id)
        REFERENCES Product(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- Add products
INSERT INTO Product (product_name, price)
VALUES
    ('Gaming Laptop', 4250.00),
    ('Smartphone Pro', 1850.00),
    ('Wireless Headphones', 520.00);

SELECT * FROM Product;

-- Add customer reviews
INSERT INTO reviews
    (customer_id, product_id, rating, review_text, review_date)
VALUES
    (1, 1, 5, 'Excellent performance, highly recommended!', '2026-08-25'),
    (2, 2, 4, 'Good battery life, but a bit heavy.', '2026-08-26'),
    (3, 1, 5, 'Best laptop I have ever purchased.', '2026-08-27'),
    (4, 3, 3, 'Average product, expected better sound quality.', '2026-08-28'),
    (5, 2, 4, 'Good value for money.', '2026-08-29'),
    (1, 3, 2, 'Not satisfied with the build quality.', '2026-08-30'),
    (2, 1, 5, 'Amazing speed and display!', '2026-08-31');

SELECT * FROM reviews;

-- Update a review
UPDATE reviews
SET rating = 5,
    review_text = 'Very good product. I am completely satisfied with the quality.'
WHERE review_id = 4;


-- Delete a review
DELETE FROM reviews
WHERE review_id = 6;


-- Display all reviews
SELECT * FROM reviews;

-- Report 1 – Product Rating Analysis
SELECT
    p.product_name,
    COUNT(r.review_id) AS total_reviews,
    ROUND(AVG(r.rating), 2) AS average_rating
FROM Product p
JOIN reviews r
    ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name;

-- Report 2 – Highly Rated Products
SELECT
    p.product_name,
    ROUND(AVG(r.rating), 2) AS average_rating
FROM Product p
JOIN reviews r
    ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
HAVING AVG(r.rating) > 4;

-- Report 3 – Rating Distribution
SELECT
    rating,
    COUNT(review_id) AS number_of_reviews
FROM reviews
GROUP BY rating
ORDER BY rating DESC;
