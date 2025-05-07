USE `coffeshop`;

SELECT * FROM coffeshop;

-- EDA

-- Overview
SELECT
	ROUND(SUM(total_sales),2) AS `Total Revenue ($)`,
    ROUND(SUM(total_profit),2) AS `Total Profit ($)`,
    ROUND((SUM(total_profit)/SUM(total_sales)) * 100,2) AS `Profit To Sales Ratio (%)` ,
    COUNT(DISTINCT order_id) AS `Total Order`,
    ROUND(SUM(total_sales) / COUNT(DISTINCT order_id),2) AS `Average Order Value ($)`,
    COUNT(DISTINCT customer_id) AS `Unique Customer`
FROM coffeshop;	

-- Product Performance

-- BEST PERFORMANCE
SELECT
	product_id,
	COUNT(product_id) AS `Total Terjual`,
    SUM(total_profit) AS `Total Profit`
FROM coffeshop
GROUP BY 1 ORDER BY 3 DESC LIMIT 5;

-- WORST PERFORMANCE
SELECT
	product_id,
	COUNT(product_id) AS `Total Terjual`,
    SUM(total_profit) AS `Total Profit`
FROM coffeshop
GROUP BY 1 ORDER BY 3 ASC LIMIT 5;

WITH top_product AS (
	SELECT
	product_id,
	COUNT(product_id) AS `Total Terjual`,
    SUM(total_profit) AS `Total Profit`
FROM coffeshop
GROUP BY 1 ORDER BY 3 DESC
LIMIT 5
),
bottom_product AS (
SELECT
	product_id,
	COUNT(product_id) AS `Total Terjual`,
    SUM(total_profit) AS `Total Profit`
FROM coffeshop
GROUP BY 1 ORDER BY 3 ASC
LIMIT 5
),
top_bottom AS (
SELECT * FROM top_product
UNION ALL
SELECT * FROM bottom_product
)
SELECT DISTINCT
	tb.product_id,
    ROUND(tb.`Total Profit`,2) AS total_profit,
    tb.`Total Terjual`,
    ROUND(c.profit_per_unit,2) AS profit_per_unit
FROM top_bottom AS tb JOIN coffeshop AS c
ON tb.product_id = c.product_id
ORDER BY 2 DESC;

-- Coffee Type
SELECT
	coffee_type,
    COUNT(coffee_type) AS total_sold,
    ROUND(SUM(total_sales),2) AS total_sales
FROM coffeshop
GROUP BY 1 ORDER BY 2 DESC;

-- Roast Type
SELECT
	roast_type,
    COUNT(coffee_type) AS total_sold,
    ROUND(SUM(total_sales),2) AS total_sales
FROM coffeshop
GROUP BY 1 ORDER BY 2 DESC;


-- Average Price Per Unit
SELECT
	ROUND(AVG(price_per_unit),2) AS avg_price
FROM coffeshop;


WITH clasification_by_avg AS (
	SELECT 
	product_id,
    price_per_unit,
    CASE
		WHEN price_per_unit > (SELECT AVG(price_per_unit) FROM coffeshop) THEN 'Above Average Price'
        WHEN price_per_unit < (SELECT AVG(price_per_unit) FROM coffeshop)	THEN 'Under Average Price'
        ELSE 'Average' 
    END AS `clasification`,
    total_sales,
    total_profit
FROM coffeshop
)
SELECT
	clasification,
    COUNT(clasification) AS total_transaction,
	ROUND(SUM(total_sales)) AS total_revenue,
    ROUND(SUM(total_profit)) AS total_profit
FROM clasification_by_avg
GROUP BY 1 ORDER BY 2;

-- By Country
SELECT
	country,
	ROUND(SUM(total_sales),2) AS total_revenue
FROM coffeshop
GROUP BY country ORDER BY 2 DESC;

-- Time Series
SELECT
	order_month,
    order_year,
	ROUND(SUM(total_sales),2)
FROM coffeshop
GROUP BY order_month, order_year ORDER BY order_year, order_month ASC;


SELECT
	order_month,
	ROUND(SUM(total_sales),2) AS total_sales
FROM coffeshop
GROUP BY order_month ORDER BY order_month ASC;

-- Loyalty Analysis
SELECT
	loyalty_card,
	COUNT(DISTINCT customer_id) AS total_customer,
    ROUND(SUM(total_sales),2) AS total_revenue,
    ROUND(SUM(total_sales) / COUNT(DISTINCT order_id),2) AS `Average Order Value`
FROM coffeshop
GROUP BY loyalty_card;

-- TOP 10 Customers
SELECT
	customer_id,
    customer_name,
    loyalty_card,
    SUM(total_sales) AS total_sales
FROM coffeshop
GROUP BY customer_id, customer_name,loyalty_card
ORDER BY 4 DESC LIMIT 10;
	
	



 