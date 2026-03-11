-- TODO: 
-- This query will return a table with two columns: order_status and Amount. 
-- The first one will have the different order status classes 
-- and the second one the total amount of each.
/*
-- 1. Check what we have on the tables
SELECT * 
FROM olist_orders
LIMIT 10;
*/

-- 2. Group by order_status and count the amount of each
SELECT
  order_status,
  COUNT(*) AS Amount
FROM olist_orders
GROUP BY order_status;