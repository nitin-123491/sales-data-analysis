-- Sales Data Analysis Project
-- MySQL 8+

CREATE DATABASE IF NOT EXISTS sales_analysis;
USE sales_analysis;

CREATE TABLE sales_data (
    Order_ID VARCHAR(20) PRIMARY KEY,
    Date DATE,
    Product VARCHAR(50),
    Category VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    Customer VARCHAR(50),
    Quantity INT,
    Unit_Price DECIMAL(12,2),
    Sales DECIMAL(14,2),
    Profit DECIMAL(14,2)
);

-- Import sales_data.csv into the table using MySQL Workbench Table Data Import Wizard.

-- 1. Total sales
SELECT ROUND(SUM(Sales),2) AS Total_Sales FROM sales_data;

-- 2. Total profit
SELECT ROUND(SUM(Profit),2) AS Total_Profit FROM sales_data;

-- 3. Total quantity sold
SELECT SUM(Quantity) AS Total_Quantity FROM sales_data;

-- 4. Number of orders
SELECT COUNT(*) AS Total_Orders FROM sales_data;

-- 5. Sales by product
SELECT Product, ROUND(SUM(Sales),2) AS Total_Sales
FROM sales_data
GROUP BY Product
ORDER BY Total_Sales DESC;

-- 6. Profit by product
SELECT Product, ROUND(SUM(Profit),2) AS Total_Profit
FROM sales_data
GROUP BY Product
ORDER BY Total_Profit DESC;

-- 7. Top 5 products by sales
SELECT Product, ROUND(SUM(Sales),2) AS Total_Sales
FROM sales_data
GROUP BY Product
ORDER BY Total_Sales DESC
LIMIT 5;

-- 8. Sales by category
SELECT Category, ROUND(SUM(Sales),2) AS Total_Sales
FROM sales_data
GROUP BY Category
ORDER BY Total_Sales DESC;

-- 9. Sales by city
SELECT City, ROUND(SUM(Sales),2) AS Total_Sales
FROM sales_data
GROUP BY City
ORDER BY Total_Sales DESC;

-- 10. Sales by state
SELECT State, ROUND(SUM(Sales),2) AS Total_Sales
FROM sales_data
GROUP BY State
ORDER BY Total_Sales DESC;

-- 11. Monthly sales
SELECT DATE_FORMAT(Date, '%Y-%m') AS Month,
       ROUND(SUM(Sales),2) AS Total_Sales
FROM sales_data
GROUP BY Month
ORDER BY Month;

-- 12. Monthly profit
SELECT DATE_FORMAT(Date, '%Y-%m') AS Month,
       ROUND(SUM(Profit),2) AS Total_Profit
FROM sales_data
GROUP BY Month
ORDER BY Month;

-- 13. Average order value
SELECT ROUND(AVG(Sales),2) AS Average_Order_Value
FROM sales_data;

-- 14. Top 10 customers
SELECT Customer, ROUND(SUM(Sales),2) AS Total_Sales
FROM sales_data
GROUP BY Customer
ORDER BY Total_Sales DESC
LIMIT 10;

-- 15. Profit margin by category
SELECT Category,
       ROUND(SUM(Profit),2) AS Profit,
       ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Profit_Margin_Percent
FROM sales_data
GROUP BY Category
ORDER BY Profit_Margin_Percent DESC;

-- 16. Products with quantity sold above average
SELECT Product, SUM(Quantity) AS Total_Quantity
FROM sales_data
GROUP BY Product
HAVING SUM(Quantity) > (SELECT AVG(product_qty)
                        FROM (
                            SELECT SUM(Quantity) AS product_qty
                            FROM sales_data
                            GROUP BY Product
                        ) t)
ORDER BY Total_Quantity DESC;

-- 17. Best city-product combination
SELECT City, Product, ROUND(SUM(Sales),2) AS Total_Sales
FROM sales_data
GROUP BY City, Product
ORDER BY Total_Sales DESC
LIMIT 10;

-- 18. Highest profit orders
SELECT Order_ID, Product, City, ROUND(Sales,2) AS Sales, ROUND(Profit,2) AS Profit
FROM sales_data
ORDER BY Profit DESC
LIMIT 10;

-- 19. Low-profit orders (profit margin < 5%)
SELECT Order_ID, Product, Sales, Profit,
       ROUND(Profit/Sales*100,2) AS Margin_Percent
FROM sales_data
WHERE Sales > 0 AND Profit/Sales < 0.05
ORDER BY Margin_Percent;

-- 20. Running monthly sales total
WITH monthly AS (
    SELECT DATE_FORMAT(Date, '%Y-%m') AS Month,
           SUM(Sales) AS Monthly_Sales
    FROM sales_data
    GROUP BY Month
)
SELECT Month,
       ROUND(Monthly_Sales,2) AS Monthly_Sales,
       ROUND(SUM(Monthly_Sales) OVER (ORDER BY Month),2) AS Running_Sales
FROM monthly
ORDER BY Month;
