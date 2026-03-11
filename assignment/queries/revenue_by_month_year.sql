-- TODO: 
-- This query will return a table with the revenue by month and year. 
-- It will have different columns: 
--      month_no, with the month numbers going from 01 to 12; 
--      month, with the 3 first letters of each month (e.g. Jan, Feb); 
--      Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist); 
--      Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and 
--      Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).

-- HINTS:
-- 1. olist_order_payments has multiple entries for some order_id values. 
-- For this query, make sure to retain only the entry with minimal payment_value for each order_id.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL

SELECT
  m.month_no,
  m.month,
  COALESCE(ROUND(SUM(CASE WHEN STRFTIME('%Y', o.order_delivered_customer_date) = '2016' THEN payments.min_p END), 2), 0.0) AS Year2016,
  COALESCE(ROUND(SUM(CASE WHEN STRFTIME('%Y', o.order_delivered_customer_date) = '2017' THEN payments.min_p END), 2), 0.0) AS Year2017,
  COALESCE(ROUND(SUM(CASE WHEN STRFTIME('%Y', o.order_delivered_customer_date) = '2018' THEN payments.min_p END), 2), 0.0) AS Year2018
FROM (
  SELECT '01' AS month_no, 'Jan' AS month UNION ALL
  SELECT '02','Feb' UNION ALL SELECT '03','Mar' UNION ALL SELECT '04','Apr' UNION ALL
  SELECT '05','May' UNION ALL SELECT '06','Jun' UNION ALL SELECT '07','Jul' UNION ALL
  SELECT '08','Aug' UNION ALL SELECT '09','Sep' UNION ALL SELECT '10','Oct' UNION ALL
  SELECT '11','Nov' UNION ALL SELECT '12','Dec'
) m
LEFT JOIN olist_orders o 
  ON m.month_no = STRFTIME('%m', o.order_delivered_customer_date)
  AND o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
LEFT JOIN (
  SELECT order_id, MIN(payment_value) as min_p
  FROM olist_order_payments
  GROUP BY order_id
) payments ON o.order_id = payments.order_id
GROUP BY m.month_no, m.month
ORDER BY m.month_no;