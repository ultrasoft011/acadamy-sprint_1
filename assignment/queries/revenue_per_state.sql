-- TODO: 
-- This query will return a table with two columns: customer_state and Revenue. 
-- The first one will have the letters that identify the top 10 states 
-- with most revenue and the second one the total revenue of each.

-- HINT: 
-- All orders should have a delivered status and the actual delivery date should be not null. 
/*
-- 1. Check what we have on the tables

SELECT *
FROM olist_order_payments
LIMIT 10;

-- 2. JOIN orders, customers and payments to get a new table with order_id, customer_state and payment_value
SELECT
  o.order_id,
  c.customer_state
FROM olist_orders o
JOIN olist_customers c
  ON c.customer_id = o.customer_id
LIMIT 10;

-- 3. Deliveries that were actually delivered and have a delivered date
SELECT
  o.order_id,
  c.customer_state
FROM olist_orders o
JOIN olist_customers c
  ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
LIMIT 10;

-- 4. Add the payment value too
SELECT
  o.order_id,
  c.customer_state,
  p.payment_value
FROM olist_orders o
JOIN olist_customers c
  ON c.customer_id = o.customer_id
JOIN olist_order_payments p
  ON p.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
LIMIT 10;
*/
-- 5. revenue per state: group by customer_state and sum the payment_value, order by revenue and limit to 10
SELECT
  c.customer_state,
  ROUND(SUM(p.payment_value), 2) AS Revenue
FROM olist_orders o
JOIN olist_customers c
  ON c.customer_id = o.customer_id
JOIN olist_order_payments p
  ON p.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY Revenue DESC
LIMIT 10;