# Blinkit-sales-analysis-
SQL-based sales analysis of Blinkit grocery data — data cleaning, KPI calculation, and performance analysis by outlet, item type, and fat content using MySQL.' 

A SQL-based analysis of Blinkit grocery sales data, covering data cleaning, KPI calculation, and multi-dimensional performance analysis using MySQL.

##  Project Overview

This project analyzes grocery sales data from Blinkit to uncover sales performance patterns across item types, fat content categories, outlet types, outlet sizes, and outlet locations. The goal was to clean a raw retail dataset, calculate key business KPIs, and generate granular insights that could inform stocking, pricing, and outlet-level decisions.

##  Dataset

- **Source:** BlinkIT Grocery Data (`BlinkIT_Grocery_Data.csv`)
- **Records:** 8,523 items
- **Fields:** Item identifier, item type, item weight, item fat content, item visibility, outlet identifier, outlet establishment year, outlet size, outlet location type, outlet type, total sales, rating

## Tools Used

- **MySQL** — data cleaning, transformation, and analysis
- **SQL techniques:** CTEs, window functions (`ROW_NUMBER()`, `COUNT() OVER()`), CASE statements, multi-column GROUP BY, aggregate functions

##  Data Cleaning

- Renamed all columns to a consistent `snake_case` format for readability and query ease
- Standardized inconsistent category labels in `item_fat_content` (e.g. `"LF"`, `"low fat"` → `"Low Fat"`; `"reg"` → `"Regular"`)
- Identified 1,463 missing values in `item_weight` (out of 8,523 records)
- Compared mean (12.86) vs. median (11) item weight to choose an imputation strategy, and imputed missing values using the median to avoid skew from outliers
- Verified no remaining nulls across all key columns before analysis

##  Key KPIs

| Metric | Value |
|---|---|
| Total Sales | ₹1.20M |
| Average Sales per Item | ₹140.99 |
| Total Orders (Items) | 8,523 |
| Average Rating | 3.97 / 5 |

## Analysis Performed

- **Sales by Fat Content** — total sales, average sales, order volume, and average rating for Low Fat vs. Regular items
- **Sales by Item Type** — performance ranking across all product categories
- **Fat Content by Outlet Location** — how the Low Fat / Regular sales split varies by outlet location type
- **Sales by Outlet Establishment Year** — trend of total sales by the year each outlet was established
- **Sales Share by Outlet Size** — percentage contribution of Small, Medium, and High outlets to total net sales
- **Performance by Outlet Location Type** — sales, order volume, and rating by Tier 1/2/3 location
- **Performance by Outlet Type** — sales, average sales, order volume, and rating across Grocery Store, Supermarket Type 1/2/3

## Key Insights

- Insight 1:Average rating of 3.97 for overall stores indicates a positive signal of customer preference towards blinkit stores.
- Insight 2:In terms of total sales, Low fat items have completely outperformed regular items by around 45 % as compared to the overall sales from blinkit stores.
- Insight 3:•	Tier -3 and Tier -2 locations have turned out to be more attractive market in terms total sales as compared to Tier-1 in both low fat and regular category items.
- Insight 4:•	Fruit and vegetables, Snack items and household items are the clear winners in the category contributing to 40.73 % of the total revenue generated from the overall blinkit stores.
- Insight 5:•	Medium and small sized stores have outperformed as compared to the high sized stores which have contributed 79,28 % revenue as comparted to the total overall revenue generated from all blinkit stores.

##  Files in this Repository

| File | Description |
|---|---|
| `Blinkit_sales_analysis.sql` | Full SQL script — data cleaning, KPI queries, and granular analysis |
| `BlinkIT_Grocery_Data.csv` | Raw dataset used for analysis |
| `Sql_blinkit_analysis_report.docx` | Written report summarizing methodology and findings |
| `Blinkit_Analysis.pptx` | Presentation deck summarizing the analysis |

##  How to Reproduce

1. Create a MySQL database named `blinkit`
2. Import `BlinkIT_Grocery_Data.csv` into a table
3. Run `Blinkit_sales_analysis.sql` sequentially — it handles renaming, cleaning, null imputation, and all analytical queries
