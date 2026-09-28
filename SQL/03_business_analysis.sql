-- 03 - BUSINESS ANALYSIS
-- Purpose: Calculate the main KPIs and dashboard business insights.

-- Total revenue
SELECT SUM(total_amount) AS total_revenue FROM orders;

-- Total orders
SELECT COUNT(*) AS total_orders FROM orders;

-- Total customers
SELECT COUNT(*) AS total_customers FROM customers;

-- Average Order Value
SELECT AVG(total_amount) AS average_order_value FROM orders;

-- Monthly revenue
SELECT DATE_TRUNC('month', order_date)::date AS month,
       SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;

-- Revenue by category
SELECT p.category, SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- Top 10 products
SELECT p.product_name, SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;

-- Top 10 customers
SELECT c.customer_id, c.name AS customer_name,
       SUM(o.total_amount) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY revenue DESC
LIMIT 10;

-- Orders by status
SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY order_count DESC;

-- Sales by city
SELECT c.city, SUM(o.total_amount) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY revenue DESC;

-- Orders above average order value
SELECT order_id, customer_id, total_amount
FROM orders
WHERE total_amount > (SELECT AVG(total_amount) FROM orders)
ORDER BY total_amount DESC;
