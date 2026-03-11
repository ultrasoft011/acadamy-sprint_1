-- TODO: 
-- This query will return a table with the top 10 least revenue categories 
-- in English, the number of orders and their total revenue. 
-- It will have different columns: 
--      Category, that will contain the top 10 least revenue categories; 
--      Num_order, with the total amount of orders of each category; 
--      Revenue, with the total revenue of each category.

-- HINT: 
-- All orders should have a delivered status and the Category and actual delivery date should be not null.
-- For simplicity, if there are orders with multiple product categories, consider the full order's payment_value in the summation of revenue of each category

SELECT
  tr.product_category_name_english AS Category,
  COUNT(DISTINCT oi.order_id) AS Num_order,
  ROUND(SUM(pay.total_payment), 2) AS Revenue
FROM olist_orders o
JOIN olist_order_items oi
  ON oi.order_id = o.order_id
JOIN olist_products p
  ON p.product_id = oi.product_id
JOIN product_category_name_translation tr
  ON tr.product_category_name = p.product_category_name
JOIN (
  SELECT order_id, SUM(payment_value) AS total_payment
  FROM olist_order_payments
  GROUP BY order_id
) pay
  ON pay.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND p.product_category_name IS NOT NULL
  AND tr.product_category_name_english IS NOT NULL
GROUP BY tr.product_category_name_english
ORDER BY Revenue ASC
LIMIT 10;