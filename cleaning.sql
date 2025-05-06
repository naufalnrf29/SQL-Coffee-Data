USE `coffeshop`;

-- ========================================
-- 1. Check for Duplicate Records
-- ========================================
WITH search_duplicate AS (
  SELECT 
    *,
    ROW_NUMBER() OVER (
      PARTITION BY order_id, customer_id, customer_name, country, loyalty_card,
                   product_id, coffee_type, roast_type, price_per_unit, 
                   profit_per_unit, quantity
    ) AS row_num
  FROM coffeshop
)
SELECT * 
FROM search_duplicate
WHERE row_num > 1;

-- ========================================
-- 2. Check for NULL Values
-- ========================================
SELECT * FROM coffeshop
WHERE 
  order_id IS NULL OR
  order_date IS NULL OR
  customer_id IS NULL OR
  customer_name IS NULL OR
  country IS NULL OR 
  loyalty_card IS NULL OR
  product_id IS NULL OR 
  coffee_type IS NULL OR
  roast_type IS NULL OR
  price_per_unit IS NULL OR
  profit_per_unit IS NULL OR
  quantity IS NULL;

-- ========================================
-- 3. Normalize Date Format and Extract Year & Month
-- ========================================
-- Add new column with DATE data type
ALTER TABLE coffeshop ADD COLUMN `date` DATE;

-- Convert string to DATE format (MM/DD/YYYY)
UPDATE coffeshop 
SET `date` = STR_TO_DATE(order_date, '%m/%d/%Y');

-- Add columns for year and month
ALTER TABLE coffeshop ADD COLUMN order_year INT;
ALTER TABLE coffeshop ADD COLUMN order_month INT;

-- Populate year and month columns
UPDATE coffeshop 
SET 
  order_year = YEAR(`date`),
  order_month = MONTH(`date`);

-- Drop the original order_date string column
ALTER TABLE coffeshop DROP COLUMN order_date;

-- ========================================
-- 4. Standardize Categorical Data
-- ========================================
-- Check distinct values before updating
SELECT DISTINCT country FROM coffeshop;
SELECT DISTINCT loyalty_card FROM coffeshop;
SELECT DISTINCT coffee_type FROM coffeshop;
SELECT DISTINCT roast_type FROM coffeshop;

-- All Standart Btw


Update coffee_type for consistency
UPDATE coffeshop
SET coffee_type = CASE
  WHEN coffee_type = 'Rob' THEN 'Robusta' 
  WHEN coffee_type = 'Ara' THEN 'Arabica' 
  WHEN coffee_type = 'Lib' THEN 'Liberica' 
  WHEN coffee_type = 'Exc' THEN 'Excelsa' 
END;

-- Update roast_type for consistency
UPDATE coffeshop
SET roast_type = CASE
  WHEN roast_type = 'M' THEN 'Medium' 
  WHEN roast_type = 'L' THEN 'Light' 
  WHEN roast_type = 'D' THEN 'Dark' 
END;

-- ========================================
-- 5. Detect Potential Outliers
-- ========================================
-- Price should not be zero or negative; quantity should not be negative
SELECT * FROM coffeshop
WHERE
  price_per_unit <= 0 OR
  quantity < 0;

-- ========================================
-- 6. Create Derived Metrics (Total Sales and Profit)
-- ========================================
ALTER TABLE coffeshop
ADD COLUMN total_sales FLOAT,
ADD COLUMN total_profit FLOAT;

-- Calculate total sales and profit
UPDATE coffeshop 
SET total_sales = quantity * price_per_unit;

UPDATE coffeshop 
SET total_profit = quantity * profit_per_unit;

-- Final Check
SELECT * FROM coffeshop;

