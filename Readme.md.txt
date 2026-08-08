# Retail Analytics Case Study using SQL

## 📌 Project Overview

This project analyzes retail sales transactions, customer profiles, and
product inventory data using SQL to generate actionable business insights.

The analysis focuses on:

- Data cleaning and validation
- Product performance analysis
- Customer segmentation
- Customer behavior analysis
- Inventory analysis
- Sales and revenue trends

---

## 🎯 Business Problem

The retail company has experienced stagnant growth and declining customer
engagement. The objective is to use sales, customer, and product data to
identify sales trends, understand customer behavior, improve customer
segmentation, and support inventory decisions.

---

## 🎯 Objectives

- Clean and validate retail datasets using SQL.
- Identify high- and low-performing products.
- Segment customers based on purchase frequency.
- Analyze repeat purchases and customer loyalty.
- Identify high-value customers.
- Analyze sales and purchasing trends.
- Generate actionable business recommendations.

---

## 🗂️ Datasets

### 1. Sales Transactions
Contains:
- Transaction ID
- Customer ID
- Product ID
- Quantity Purchased
- Transaction Date
- Price

### 2. Customer Profiles
Contains:
- Customer ID
- Age
- Gender
- Location
- Join Date

### 3. Product Inventory
Contains:
- Product ID
- Product Name
- Category
- Stock Level
- Price

---

## 🧹 Data Cleaning

The following data quality checks were performed:

- Duplicate transaction detection and removal
- NULL value identification
- Blank value identification
- Missing customer information handling
- Product price consistency validation
- Data type/date validation

---

## 📊 Analysis Performed

### Product Performance
- Total units sold by product
- Total revenue by product
- Highest-selling products
- Lowest-selling products
- Category-wise sales

### Customer Segmentation
Customers were segmented based on total orders:

| Total Orders | Segment |
|--------------|---------|
| 0 | No Orders |
| 1–10 | Low |
| 11–30 | Mid |
| >30 | High Value |

### Customer Behavior
- Repeat purchase analysis
- Total customer spending
- Purchase frequency
- Average order value
- High-value customers
- Purchase span
- Monthly purchasing trends

### Inventory
- Stock-level analysis
- Low-stock product identification
- Inventory planning based on product demand

---

## 💡 Key Business Insights

- High-value customers represent an important revenue source and should
  be prioritized through loyalty programs and personalized offers.
- Low-engagement customers provide opportunities for reactivation through
  targeted promotions.
- High-performing products should receive greater inventory allocation
  to reduce the risk of stock-outs.
- Low-performing products should be evaluated for pricing, promotions,
  or potential discontinuation.
- Sales trends can help the business identify seasonal demand and improve
  inventory and marketing planning.
- Regional and category-level analysis can support targeted marketing
  and resource allocation.

---

## 🛠️ Tools & Technologies

- MySQL
- SQL
- GitHub

### SQL Concepts Used

- SELECT
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- JOIN
- LEFT JOIN
- CASE
- CTEs
- Subqueries
- Aggregate Functions
- Window Functions
- Date Functions
- Data Cleaning

---

## 📁 Project Structure

```text
retail-analytics-sql/
│
├── data/
├── sql/
├── documentation/
└── README.md