-- 02 - DATA QUALITY
-- Purpose: Verify imported row counts, NULLs, duplicate IDs and FK validity.

SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_products FROM products;
SELECT COUNT(*) AS total_orders FROM orders;
SELECT COUNT(*) AS total_order_items FROM order_items;
SELECT COUNT(*) AS total_payments FROM payments;

-- Check required customer fields
SELECT COUNT(*) AS total_rows, COUNT(customer_id) AS customer_ids,
       COUNT(name) AS names, COUNT(email) AS emails, COUNT(city) AS cities
FROM customers;

-- Check required order fields
SELECT COUNT(*) AS total_rows, COUNT(order_id) AS order_ids,
       COUNT(customer_id) AS customer_ids, COUNT(order_date) AS order_dates,
       COUNT(status) AS statuses, COUNT(total_amount) AS total_amounts
FROM orders;

-- Duplicate checks: a result row means a duplicate exists.
SELECT customer_id, COUNT(*) AS duplicate_count
FROM customers GROUP BY customer_id HAVING COUNT(*) > 1;

SELECT product_id, COUNT(*) AS duplicate_count
FROM products GROUP BY product_id HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*) AS duplicate_count
FROM orders GROUP BY order_id HAVING COUNT(*) > 1;

SELECT order_item_id, COUNT(*) AS duplicate_count
FROM order_items GROUP BY order_item_id HAVING COUNT(*) > 1;

SELECT payment_id, COUNT(*) AS duplicate_count
FROM payments GROUP BY payment_id HAVING COUNT(*) > 1;

-- Foreign-key validity checks: a result row means an invalid reference exists.
SELECT o.order_id, o.customer_id
FROM orders o LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT oi.order_item_id, oi.order_id
FROM order_items oi LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT oi.order_item_id, oi.product_id
FROM order_items oi LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT p.payment_id, p.order_id
FROM payments p LEFT JOIN orders o ON p.order_id = o.order_id
WHERE o.order_id IS NULL;
