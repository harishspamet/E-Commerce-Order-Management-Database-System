## 📊 Week 14: Business Intelligence and AI Data Preparation

### 1. Analytical & Window Functions
Implemented advanced SQL to generate business insights:

<img width="1356" height="124" alt="image" src="https://github.com/user-attachments/assets/854e814a-f5b9-4dec-9ee3-b187f7a452b2" />

- **Sales Performance:** Monthly revenue and Average Order Value (AOV).
- **Ranking (Window Functions):** 
  - `RANK()` to find the best-selling products.
  - `DENSE_RANK()` to identify top-spending customers.
  - `ROW_NUMBER()` to generate chronological order sequences.

### 2. Customer Segmentation
Used `CASE` statements to categorize customers based on spending and frequency:
- **Premium / High Value:** Spending > ₹1,00,000 or > 10 orders.
- **Regular:** Spending > ₹20,000 or > 3 orders.
- **Low Value:** Less frequent or lower-spending customers.

### 3. AI Dataset Preparation & Feature Extraction
Engineered a clean, ML-ready dataset using `LEFT JOIN`, `IFNULL`, and aggregations.
- **Features Extracted:** Customer ID, Total Purchases, Total Spending, Average Order Value, Purchase Frequency, and Last Purchase Date.
- Handled missing data (nulls) to ensure the dataset is ready for machine learning algorithms.

---
