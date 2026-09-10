 TASK 6 - Product Review and Rating Management

USE ecoms_db;

-- Remove old reviews
DROP TABLE IF EXISTS reviews;
-- Remove old products to start fresh
DROP TABLE IF EXISTS Product;


-- Create Product table

<img width="720" height="373" alt="image" src="https://github.com/user-attachments/assets/9c5b98a6-5e87-48c2-b7b8-a0ac2333bcda" />


-- Create Reviews table

<img width="966" height="425" alt="image" src="https://github.com/user-attachments/assets/23fe9ede-389e-4b4f-a5eb-0f169bb5e3d6" />


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

<img width="449" height="139" alt="image" src="https://github.com/user-attachments/assets/c30b5cfd-0b9d-48a3-955b-d24061895292" />

-- Report 2 – Highly Rated Products

<img width="349" height="132" alt="image" src="https://github.com/user-attachments/assets/a8c0ed4d-a610-4caf-9b12-25c9aafebdff" />

-- Report 3 – Rating Distribution

<img width="306" height="106" alt="image" src="https://github.com/user-attachments/assets/4200054a-20d1-4b4f-aa53-75721ad98b81" />


ER DIAGRAM:

<img width="683" height="983" alt="task 6 ER diagram" src="https://github.com/user-attachments/assets/16a8451d-4e24-424a-9b76-63985c5e6bcc" />

 ----------------------------------------x-------------------x-------------------x-----------------------------x-----------------x-------------x---------------------------
