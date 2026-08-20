-- CREATING BLINKIT DATABASE 
CREATE DATABASE blinkit;

-- IMPORTING THE DATA USING IMPORT TABLE WIZARD 
USE blinkit;

SHOW TABLES;

DROP TABLE IF EXISTS bgroceries;

SHOW TABLES;

SELECT * FROM blinkit;

-- CHECKING DATA TYPES 
DESCRIBE blinkit;

-- Data Cleaning  
SELECT * FROM blinkit;

ALTER TABLE blinkit 
RENAME COLUMN `Item Fat Content` TO item_fat_content;

ALTER TABLE blinkit 
RENAME COLUMN `Item Identifier` TO item_identifier,
RENAME COLUMN `Item Type` TO item_type,
RENAME COLUMN `Outlet Establishment Year` TO outlet_establishment_year,
RENAME COLUMN `Outlet Identifier` TO outlet_identifier,
RENAME COLUMN `Outlet Location Type` TO outlet_location_type,
RENAME COLUMN `Outlet Size` TO outlet_size,
RENAME COLUMN `Outlet Type` TO outlet_type,
RENAME COLUMN `Item Visibility` TO item_visibility,
RENAME COLUMN `Item Weight` TO item_weight,
RENAME COLUMN `Total Sales` TO total_sales;

-- CHECKING THE DATA COLUMNS 
SELECT * FROM blinkit;

-- FIXING IRREGULAR COLUMN ENTRIES IN ITEM_FAT_CONTENT 
UPDATE blinkit 
SET item_fat_content = 
CASE 
	WHEN item_fat_content IN ("LF","low fat") THEN "Low Fat"
    WHEN item_fat_content = "reg" THEN "Regular"
	ELSE item_fat_content 
	END
WHERE item_fat_content IS NOT NULL 
LIMIT 8523;

-- Checking whether the execution worked 
SELECT DISTINCT item_fat_content 
FROM blinkit;

-- Checking missing values 
SELECT 
	SUM(CASE WHEN item_fat_content IS NULL THEN 1 ELSE 0 END) AS null_item_fat,
    SUM(CASE WHEN item_identifier IS NULL THEN 1 ELSE 0 END) AS null_item_identifier,
    SUM(CASE WHEN item_type IS NULL THEN 1 ELSE 0 END) AS null_item_type,
    SUM(CASE WHEN outlet_establishment_year IS NULL THEN 1 ELSE 0 END) AS null_establishment,
    SUM(CASE WHEN outlet_identifier IS NULL THEN 1 ELSE 0 END) AS null_outlet_identifier,
    SUM(CASE WHEN outlet_location_type IS NULL THEN 1 ELSE 0 END) AS null_location_type,
    SUM(CASE WHEN outlet_size IS NULL THEN 1 ELSE 0 END) AS null_outlet_size,
    SUM(CASE WHEN item_visibility IS NULL THEN 1 ELSE 0 END) AS null_item_visibility,
    SUM(CASE WHEN item_weight IS NULL THEN 1 ELSE 0 END) AS null_item_weight,
    SUM(CASE WHEN total_sales IS NULL THEN 1 ELSE 0 END) AS null_total_sales,
    SUM(CASE WHEN Rating IS NULL THEN 1 ELSE 0 END) AS null_ratings 
FROM 
	blinkit; -- null_item_weight - 1463 records 
    
-- 1463 records out of 8523 records are null. 
-- Instead of replacing it with zero or N/A 
-- Lets check average item weight 
SELECT 
	ROUND(AVG(item_weight),2) AS avg_weight 
FROM 
	blinkit; -- 12.86 
    
-- Computing median weight for clarification 
WITH median_item_weight AS ( 
SELECT 
	item_weight, 
    ROW_NUMBER() OVER(ORDER BY item_weight) AS rn,
    COUNT(*) OVER() AS total_rows 
FROM 
	blinkit)
SELECT 
	AVG(item_weight) AS median_weight 
FROM 
	median_item_weight 
WHERE rn IN ( 
	FLOOR((total_rows+1)/2),
    CEIL((total_rows+1)/2)); -- 11 is median weight 
    
-- CHECKING AVG , MIN AND MAX OF ITEM WEIGHT 
SELECT 
	ROUND(AVG(item_weight),2) AS avg_weight, -- 12.86
    MIN(item_weight) AS minimum_weight, -- 4.55
    MAX(item_weight) AS max_weight -- 21.35 
FROM 
	blinkit;
    
-- IMPUTING NULL VALUES OF ITEM WEIGHT WITH MEDIAN VALUE 
UPDATE blinkit 
SET item_weight = 11 
WHERE item_weight IS NULL
LIMIT 8523;


-- CHECKING IF ANY NULL VALUES EXISTS 
SELECT 
	SUM(CASE WHEN item_weight IS NULL THEN 1 ELSE 0 END) AS null_item_weight 
FROM blinkit;

-- KPI Requirements 
-- 1. Total Sales in millions 
SELECT 
	CONCAT_WS(" ",CAST(SUM(total_sales)/1000000 AS DECIMAL(10,2)),"M") AS total_net_sales 
FROM 
	blinkit; -- 1.20 Million 
    
-- 2. Average sales 
SELECT 
	CAST(AVG(total_sales) AS DECIMAL(10,2)) AS average_sales 
FROM 
	blinkit; -- 140.99 
    
-- 3 Total Orders ( Number of items ) 
SELECT * FROM blinkit;
SELECT 
	COUNT(item_type) AS total_orders 
FROM 
	blinkit; -- 8523 Items 
    
-- 4. Average ratings across all stores 
SELECT 
	CAST(AVG(Rating) AS DECIMAL(10,2)) AS avg_rating 
FROM 
	blinkit; -- 3.97 
    
-- GRANULAR REQUIREMENTS 
-- - PERFORMANCE ANALYSIS  BY FAT CONTENT 
SELECT * FROM blinkit;

SELECT 
	item_fat_content, 
    CAST(SUM(total_sales) AS DECIMAL(10,2)) AS total_sales,
    CAST(AVG(total_sales) AS DECIMAL(10,2)) AS avg_sales,
    COUNT(*) AS total_orders,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS avg_rating
FROM 
	blinkit 
GROUP BY 
	item_fat_content
ORDER BY 
	total_sales DESC;
    
-- PERFORMANCE ANALYSIS BY ITEM TYPE 
SELECT 
	item_type,
    CAST(SUM(total_sales) AS DECIMAL(10,2)) AS total_sales,
    CAST(AVG(total_sales) AS DECIMAL(10,2)) AS avg_sales,
    COUNT(*) AS total_orders,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS avg_rating 
FROM 
	blinkit
GROUP BY 
	item_type 
ORDER BY 
	total_sales DESC;
    
-- FAT CONTENT BY OUTLET FOR TOTAL SALES 
SELECT 
	outlet_location_type,
    item_fat_content,
    CAST(SUM(total_sales) AS DECIMAL(10,2)) AS total_sales 
FROM 
	blinkit
GROUP BY 
    outlet_location_type,item_fat_content
ORDER BY 
    total_sales DESC;


SELECT 
	outlet_location_type,
    ROUND(SUM(CASE
			WHEN item_fat_content = "Regular" THEN total_sales ELSE 0 END),2) AS Regular_total_sales,
	ROUND(SUM(CASE 
			WHEN item_fat_content = "Low Fat" THEN total_sales ELSE 0 END),2) AS Low_Fat_total_sales,
	ROUND(AVG(CASE 
			WHEN item_fat_content = "Regular" THEN total_sales ELSE 0 END),2) AS Regular_avg_sales,
	ROUND(AVG(CASE
			WHEN item_fat_content = "Low Fat" THEN total_sales ELSE 0 END),2) AS low_fat_avg_sales
FROM	
	blinkit
GROUP BY 
	outlet_location_type
ORDER BY     
	outlet_location_type;

-- Total sales by outlet establishment 
SELECT 
	outlet_establishment_year,
    CAST(SUM(total_sales) AS DECIMAL(10,2)) AS total_sales 
FROM 
	blinkit 
GROUP BY 
	outlet_establishment_year
ORDER BY 
	outlet_establishment_year ASC;
    
-- PERCENTAGE OF SALES BY OUTLET SIZE 
SELECT * FROM blinkit;

WITH blinkit_total_sales AS ( 
SELECT 
	ROUND(SUM(total_sales),2) AS total_sales_net 
FROM 
	blinkit ) , outlet_total_sales AS (
SELECT 
	outlet_size ,ROUND(SUM(total_sales),2) AS outlet_sales , total_sales_net
FROM 
	blinkit 
JOIN blinkit_total_sales
GROUP BY outlet_size,total_sales_net)
SELECT *,ROUND((outlet_sales/total_sales_net)*100,2) AS "%_sales" FROM outlet_total_sales;

-- PERFORMANCE METRICS FOR OUTLET LOCATION TYPE  
SELECT 
	outlet_location_type,
    CAST(SUM(total_sales) AS DECIMAL(10,2)) AS location_sales,
    COUNT(*) AS location_wise_total_orders,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS location_avg_rating 
FROM 
	blinkit 
GROUP BY 
	outlet_location_type
ORDER BY 
	location_sales DESC,
    location_wise_total_orders DESC,
    location_avg_rating DESC;
    
-- ALL METRICS BY OUTLET TYPE 

SELECT 
	outlet_type,
    CAST(SUM(total_sales) AS DECIMAL(10,2)) AS total_sales,
    CAST(AVG(total_sales) AS DECIMAL(10,2)) AS avg_sales,
    COUNT(*) AS total_orders,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS avg_rating 
FROM 
	blinkit 
GROUP BY 
	outlet_type 
ORDER BY 
	total_sales DESC,
    avg_sales DESC,
    total_orders DESC,
    avg_rating DESC;
    
    