CREATE DATABASE retail_analytic_db;
USE retail_analytic_db;
SHOW TABLES;

SELECT * FROM customer_profiles;
SELECT * FROM product_inventory;
SELECT * FROM sales_transaction;

-- DATA CLEANING 

ALTER TABLE customer_profiles
RENAME COLUMN ï»¿CustomerID TO CustomerID;

ALTER TABLE product_inventory
RENAME COLUMN ï»¿ProductID TO ProductID;


ALTER TABLE sales_transaction
RENAME COLUMN ï»¿TransactionID TO TransactionID;

-- Removing duplicates sales transaction if any.

SELECT TransactionID,
COUNT(*) FROM sales_transaction
GROUP BY TransactionID
HAVING COUNT(*)>1;

-- There are 2 duplicate records in the sale transaction.

CREATE TABLE sales_transaction_unique
SELECT DISTINCT * FROM sales_transaction;

SELECT * FROM sales_transaction_unique;

-- Discrepancies in the price of the same product in sales transaction table and product inventory table.

SELECT st.TransactionID,st.Price AS TransactionPrice,pi.ProductID,pi.Price AS ProductPrice
FROM sales_transaction_unique st
JOIN product_inventory pi
ON st.ProductID=pi.ProductID
WHERE pi.Price<>st.Price;

-- -- Update the sales_transaction_unique table to match the product inventory price.

UPDATE sales_transaction_unique st
SET st.Price=(SELECT pi.Price FROM product_inventory pi WHERE st.ProductID=pi.ProductID)
WHERE st.ProductID IN (SELECT pi.ProductID FROM product_inventory pi WHERE pi.Price<>st.Price);

-- Identifying the null/blank values

SELECT COUNT(*) FROM customer_profiles
WHERE Location ="";

-- Replacing all the blank values in Location with 'Unknown'
UPDATE customer_profiles
SET Location = 'Unknown'
WHERE Location ='';

 -- Checking NUll values in the customer_profiles
SELECT
    COUNT(*) AS TotalRows,
    SUM(CustomerID IS NULL) AS Null_CustomerID,
    SUM(Gender IS NULL) AS Null_Gender,
    SUM(Age IS NULL) AS Null_Age,
    SUM(Location IS NULL) AS Null_Location,
    SUM(JoinDate IS NULL) AS Null_JoinDate
FROM customer_profiles;

-- Checking Missing or null values in product inventory

SELECT 
COUNT(*) AS Total_Rows,
SUM(ProductName IS NULL) AS NULL_Poduct_name,
SUM(Category IS NULL) AS NULL_Category,
SUM(StockLevel IS NULL) AS NULL_Level,
SUM(Price IS NULL) AS NULL_Price
FROM product_inventory;

SELECT 
SUM(TRIM(ProductName)='') AS Missing_PName,
SUM(TRIM(Category)='') AS Missing_Category
FROM product_inventory;

-- Checking missing or null values sales_transaction_unique table

SELECT 
COUNT(*) AS Total_Rows,
SUM(QuantityPurchased IS NULL) AS NULL_QtyPurchased,
SUM(TransactionDate IS NULL) AS NULL_Trans_Date,
SUM(Price IS NULL) AS NULL_Price
FROM sales_transaction_unique ;

-- Data Analysis
-- 1. Product Performance Variability

-- Total sales and quantity sold per product

SELECT pi.ProductID,pi.ProductName,
SUM(QuantityPurchased) AS Total_Unit_Sold,ROUND(SUM(QuantityPurchased*st.Price),2) AS Total_Sales
FROM sales_transaction_unique st
JOIN product_inventory pi
ON pi.ProductID=st.ProductID
GROUP BY pi.ProductID,pi.ProductName
ORDER BY Total_Sales DESC;

-- Highest Quantity Sold
SELECT
ProductID,
SUM(QuantityPurchased) QuantitySold
FROM sales_transaction_unique
GROUP BY ProductID
ORDER BY QuantitySold DESC;

-- Location wise sales

SELECT
Location,
ROUND(SUM(QuantityPurchased*Price),2) Revenue
FROM customer_profiles cp
JOIN sales_transaction_unique st
ON cp.CustomerID=st.CustomerID
GROUP BY Location
ORDER BY Revenue DESC;
-- Helps identify high-performing geographic markets for targeted marketing and inventory planning.
-- OBSERVATIONS: Product_17 is the Highest Selling product with total sales amount of 9450 and 'Product_139' is the lowest selling product with total sales amout of 484.1

-- Customer Segmentation based on their purchase frequency.

SELECT * FROM sales_transaction_unique;
WITH CustomerTransaction AS(
SELECT CustomerID,
COUNT(*) AS TotalOrders
FROM sales_transaction_unique
GROUP BY CustomerID)
SELECT CustomerID,TotalOrders,
CASE
WHEN TotalOrders = 0 THEN 'No Orders'
WHEN TotalOrders BETWEEN 1 AND 10 THEN 'Low'
WHEN TotalOrders BETWEEN 11 AND 30 THEN 'Mid'
ELSE 'High Value'
END AS CustomerSegment
FROM CustomerTransaction
ORDER BY TotalOrders DESC;

-- Gender wise Spending 
SELECT
Gender,
ROUND(SUM(QuantityPurchased*Price),2) Revenue
FROM customer_profiles cp
JOIN sales_transaction_unique st
ON cp.CustomerID=st.CustomerID
GROUP BY Gender;

-- Identifies customer demographics contributing the highest revenue.

-- Customer Behaviour
-- Identify high-value customers based on the number of orders and total spending.
SELECT CustomerID, COUNT(*) AS TotalOrders, ROUND(SUM(QuantityPurchased*Price),2) AS TotalSpent
FROM sales_transaction_unique
GROUP BY CustomerID
HAVING TotalOrders>10 AND TotalSpent>1000
ORDER BY TotalSpent DESC;

-- Low-value customers
SELECT CustomerID, COUNT(*) AS TotalOrders, ROUND(SUM(QuantityPurchased*Price),2) AS TotalSpent
FROM sales_transaction_unique
GROUP BY CustomerID
HAVING TotalOrders < 6 AND TotalSpent>100
ORDER BY TotalSpent DESC;

-- Repeat Purchase Pattern
 
 -- Identifies repeat customers who are more likely to be loyal.
SELECT
    CustomerID,ProductID,
    COUNT(*) AS TotalOrders
FROM sales_transaction_unique
GROUP BY CustomerID,ProductID
HAVING COUNT(*) > 1
ORDER BY TotalOrders DESC;

WITH TransactionDate_tb AS (
SELECT CustomerID, STR_TO_DATE(TransactionDate,'%d/%m/%y')AS TransactionDate
FROM sales_transaction_unique)
SELECT CustomerID,MIN(TransactionDate) AS FirstPurchase,MAX(TransactionDate),
MAX(TransactionDate)-MIN(TransactionDate) AS DaysBetweenPurchases
FROM TransactionDate_tb
GROUP BY CustomerID
HAVING(MAX(TransactionDate)-MIN(TransactionDate))>0
ORDER BY DaysBetweenPurchases DESC;

-- This query helps identify repeat customers.
-- Higher DaysBetweenPurchases → Customer has been purchasing over a longer period, indicating long-term engagement.
-- 0 days → Customer purchased only on a single day.

-- Monthly Purchase Trend
SELECT
    YEAR(TransactionDate) AS Year,
    MONTH(TransactionDate) AS Month,
    COUNT(*) AS Orders
FROM sales_transaction_unique
GROUP BY YEAR(TransactionDate), MONTH(TransactionDate)
ORDER BY Year, Month;

-- Average Order VALUES
SELECT
CustomerID,
ROUND(
SUM(Price*QuantityPurchased)/COUNT(*),2
) AS AvgOrderValue
FROM sales_transaction_unique
GROUP BY CustomerID;

-- Customers with high average order values tend to purchase premium products.

-- Top 10 Customers
SELECT
CustomerID,
ROUND(SUM(Price*QuantityPurchased),2) AS Revenue
FROM sales_transaction_unique
GROUP BY CustomerID
ORDER BY Revenue DESC
LIMIT 10;
-- Top customers should receive loyalty rewards and personalized offers.
-- Identifies seasonal buying patterns

-- Inventory analysis
SELECT
ProductID,
ProductName,
StockLevel
FROM product_inventory
ORDER BY StockLevel;
-- Products with very low stock and high demand should be restocked immediately to avoid stock-outs.

-- Category-wise Sales
SELECT
Category,
SUM(QuantityPurchased) AS UnitsSold,
ROUND(SUM(st.Price*QuantityPurchased),2) AS Revenue
FROM sales_transaction_unique st
JOIN product_inventory pi
ON st.ProductID=pi.ProductID
GROUP BY Category
ORDER BY Revenue DESC;

-- This identifies which product categories contribute the highest revenue.
