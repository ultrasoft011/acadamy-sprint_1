-- TODO: 
-- This query will return a table with the differences between the real 
-- and estimated delivery times by month and year. 
-- It will have different columns: 
--      month_no, with the month numbers going FROM 01 to 12; 
--      month, with the 3 first letters of each month (e.g. Jan, Feb); 
--      Year2016_real_time, with the average delivery time per month of 2016 (NaN if it doesn't exist); 
--      Year2017_real_time, with the average delivery time per month of 2017 (NaN if it doesn't exist); 
--      Year2018_real_time, with the average delivery time per month of 2018 (NaN if it doesn't exist); 
--      Year2016_estimated_time, with the average estimated delivery time per month of 2016 (NaN if it doesn't exist); 
--      Year2017_estimated_time, with the average estimated delivery time per month of 2017 (NaN if it doesn't exist) and 
--      Year2018_estimated_time, with the average estimated delivery time per month of 2018 (NaN if it doesn't exist).

-- HINTS:
-- 1. You can use the julianday function to convert a date to a number.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL
-- 3. Take distinct order_id.

-- 1. First, we need to check the data to understand how to calculate the real and estimated delivery times.
/*
SELECT
  order_id,
  order_status,
  order_purchase_timestamp,
  order_delivered_customer_date,
  order_estimated_delivery_date
FROM olist_orders
LIMIT 10;


-- 2. The deliveries that are delivered that have a non-null order_delivered_customer_date are the ones we need.

SELECT
  order_id,
  order_purchase_timestamp,
  order_delivered_customer_date,
  order_estimated_delivery_date
FROM olist_orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
LIMIT 10;

-- 3. We can extract the year and month from the order_purchase_timestamp to group the data by month and year.
SELECT
  order_id,
  STRFTIME('%Y', order_purchase_timestamp) AS yr,
  STRFTIME('%m', order_purchase_timestamp) AS month_no
FROM olist_orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
LIMIT 10;

-- 4. calculated real time and estimated time in days using the julianday function to convert the dates to numbers and then subtracting them.
SELECT
  order_id,
  STRFTIME('%Y', order_purchase_timestamp) AS yr,
  STRFTIME('%m', order_purchase_timestamp) AS month_no,

  julianday(STRFTIME('%Y-%m-%d', order_delivered_customer_date)) -
  julianday(STRFTIME('%Y-%m-%d', order_purchase_timestamp)) AS real_time_days,

  julianday(STRFTIME('%Y-%m-%d', order_estimated_delivery_date)) -
  julianday(STRFTIME('%Y-%m-%d', order_purchase_timestamp)) AS estimated_time_days
FROM olist_orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
LIMIT 10;


-- 5. Finally, we can calculate the average real time and estimated time by month and year using the AVG function and grouping by month and year.
SELECT
  STRFTIME('%Y', order_purchase_timestamp) AS yr,
  STRFTIME('%m', order_purchase_timestamp) AS month_no,
  AVG(
    julianday(STRFTIME('%Y-%m-%d', order_delivered_customer_date)) -
    julianday(STRFTIME('%Y-%m-%d', order_purchase_timestamp))
  ) AS avg_real_time,
  AVG(
    julianday(STRFTIME('%Y-%m-%d', order_estimated_delivery_date)) -
    julianday(STRFTIME('%Y-%m-%d', order_purchase_timestamp))
  ) AS avg_estimated_time
FROM olist_orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
GROUP BY yr, month_no
ORDER BY yr, month_no;
*/

--6. We can pivot the data to have the years as columns and the months as rows.

SELECT
  STRFTIME('%m', order_purchase_timestamp) AS month_no,
  -- Esto genera el nombre corto del mes (opcional, pero ayuda a la vista)
  CASE STRFTIME('%m', order_purchase_timestamp)
    WHEN '01' THEN 'Jan' WHEN '02' THEN 'Feb' WHEN '03' THEN 'Mar' WHEN '04' THEN 'Apr'
    WHEN '05' THEN 'May' WHEN '06' THEN 'Jun' WHEN '07' THEN 'Jul' WHEN '08' THEN 'Aug'
    WHEN '09' THEN 'Sep' WHEN '10' THEN 'Oct' WHEN '11' THEN 'Nov' ELSE 'Dec' 
  END AS month,

  -- Promedios para 2016
  AVG(CASE WHEN STRFTIME('%Y', order_purchase_timestamp) = '2016' THEN (julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)) END) AS Year2016_real_time,
  -- Promedios para 2017
  AVG(CASE WHEN STRFTIME('%Y', order_purchase_timestamp) = '2017' THEN (julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)) END) AS Year2017_real_time,
  -- Promedios para 2018
  AVG(CASE WHEN STRFTIME('%Y', order_purchase_timestamp) = '2018' THEN (julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)) END) AS Year2018_real_time,

  -- Estimados para 2016
  AVG(CASE WHEN STRFTIME('%Y', order_purchase_timestamp) = '2016' THEN (julianday(order_estimated_delivery_date) - julianday(order_purchase_timestamp)) END) AS Year2016_estimated_time,
  -- Estimados para 2017
  AVG(CASE WHEN STRFTIME('%Y', order_purchase_timestamp) = '2017' THEN (julianday(order_estimated_delivery_date) - julianday(order_purchase_timestamp)) END) AS Year2017_estimated_time,
  -- Estimados para 2018
  AVG(CASE WHEN STRFTIME('%Y', order_purchase_timestamp) = '2018' THEN (julianday(order_estimated_delivery_date) - julianday(order_purchase_timestamp)) END) AS Year2018_estimated_time

FROM olist_orders
WHERE order_status = 'delivered' 
  AND order_delivered_customer_date IS NOT NULL
GROUP BY month_no
ORDER BY month_no;