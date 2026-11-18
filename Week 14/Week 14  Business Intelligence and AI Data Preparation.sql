USE ecoms_db;

SELECT 
    COUNT(Order_ID) AS Total_Orders,
    SUM(Total_Amount) AS Total_Sales,
    AVG(Total_Amount) AS Average_Order_Value,
    DATE_FORMAT(Order_Date, '%Y-%m') AS Month
FROM Orders
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m');

SELECT 
    p.Product_Name,
    SUM(oi.Quantity) AS Total_Sold,
    RANK() OVER(ORDER BY SUM(oi.Quantity) DESC) AS Sales_Rank
FROM Products p
JOIN Order_Items oi ON p.Product_ID = oi.Product_ID
GROUP BY p.Product_ID, p.Product_Name;

SELECT 
    c.Customer_Name,
    SUM(o.Total_Amount) AS Total_Spent,
    DENSE_RANK() OVER(ORDER BY SUM(o.Total_Amount) DESC) AS Spending_Rank
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name;

SELECT 
    Order_ID, 
    Customer_ID, 
    Order_Date,
    ROW_NUMBER() OVER(ORDER BY Order_Date DESC) AS Order_Sequence
FROM Orders;

SELECT 
    c.Customer_Name,
    COUNT(o.Order_ID) AS Total_Orders,
    IFNULL(SUM(o.Total_Amount), 0) AS Total_Purchase,
    CASE 
        WHEN SUM(o.Total_Amount) >= 100000 OR COUNT(o.Order_ID) >= 10 THEN 'Premium (High Value)'
        WHEN SUM(o.Total_Amount) >= 20000 OR COUNT(o.Order_ID) >= 3 THEN 'Regular'
        ELSE 'Low Value'
    END AS Segment
FROM Customers c
LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name;

SELECT 
    c.Customer_ID,
    30 AS Age,
    COUNT(o.Order_ID) AS Total_Purchases,
    IFNULL(SUM(o.Total_Amount), 0) AS Total_Spending,
    IFNULL(AVG(o.Total_Amount), 0) AS Average_Order_Value,
    COUNT(o.Order_ID) / 12.0 AS Purchase_Frequency_Per_Month,
    'Electronics' AS Preferred_Category,
    MAX(o.Order_Date) AS Last_Purchase_Date
FROM Customers c
LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID;