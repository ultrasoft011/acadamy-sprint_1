-- TODO: 
-- This query will return a table with two columns: State and Delivery_Difference. 
-- The first one will have the letters that identify the states, 
-- and the second one the average difference between the estimated delivery date 
-- and the date when the items were actually delivered to the customer.

-- HINTS:
-- 1. You can use the julianday function to convert a date to a number.
-- 2. You can use the CAST function to convert a number to an integer.
-- 3. You can use the STRFTIME function to convert a order_delivered_customer_date to a string removing hours, minutes and seconds.
-- 4. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL 

/*
EN:
- We want to know, per customer state, how many days early/late the delivery was on average.
- "Estimated delivery date" is the expected date.
- "Delivered customer date" is the real date when the customer received the package.
- We calculate: estimated_date - delivered_date (in days).
  * Positive value  => delivered earlier than estimated (because delivered date is smaller)
  * Negative value  => delivered later than estimated
- We only use orders that were actually delivered and have a delivered date.

ES:
- Queremos saber, por estado del cliente, cuántos días antes o después se entregó el pedido en promedio.
- La "fecha estimada" es la fecha que se esperaba entregar.
- La "fecha real de entrega" es cuando realmente llegó al cliente.
- Calculamos: fecha_estimada - fecha_entregada (en días).
  * Valor positivo  => llegó antes de lo estimado
  * Valor negativo  => llegó después de lo estimado
- Solo usamos pedidos que están en estado 'delivered' y que tienen fecha real de entrega (no NULL).
*/

-- 1. Check what we have on the tables
/*
SELECT *
FROM olist_orders
LIMIT 10;

SELECT *
FROM olist_customers
LIMIT 10;

-- 2. JOIN orders and customers to get a new table with order_id, customer_id and customer_state
SELECT
  o.order_id,
  o.customer_id,
  c.customer_state
FROM olist_orders o
JOIN olist_customers c
  ON c.customer_id = o.customer_id
LIMIT 10;

-- 3. Deliveries that were actually delivered and have a delivered date
SELECT
  o.order_id,
  c.customer_state,
  o.order_status,
  o.order_delivered_customer_date
FROM olist_orders o
JOIN olist_customers c
  ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
LIMIT 10;

-- 4. Add the estimated delivery date too
SELECT
  o.order_id,
  c.customer_state,
  o.order_estimated_delivery_date,
  o.order_delivered_customer_date
FROM olist_orders o
JOIN olist_customers c
  ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL;


-- 5. Calculate the difference between estimated date and delivered date
SELECT
  o.order_id,
  c.customer_state,
  o.order_estimated_delivery_date,
  o.order_delivered_customer_date,
  julianday(STRFTIME('%Y-%m-%d', o.order_estimated_delivery_date)) -
  julianday(STRFTIME('%Y-%m-%d', o.order_delivered_customer_date)) AS delivery_difference
FROM olist_orders o
JOIN olist_customers c
  ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
LIMIT 10;
*/

-- 6. Finally, we need to calculate the average delivery difference per state
SELECT
  c.customer_state AS State,
  CAST(
    AVG(
      julianday(date(o.order_estimated_delivery_date)) -
      julianday(date(o.order_delivered_customer_date))
    ) AS INTEGER
  ) AS Delivery_Difference
FROM olist_orders o
JOIN olist_customers c
  ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY Delivery_Difference ASC, State ASC;