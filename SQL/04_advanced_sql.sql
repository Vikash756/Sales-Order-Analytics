-- 04 - ADVANCED SQL
-- Purpose: Demonstrate subqueries, CTE, CASE and window functions.

-- Subquery: orders above average
SELECT order_id, customer_id, total_amount
FROM orders
WHERE total_amount > (SELECT AVG(total_amount) FROM orders)
ORDER BY total_amount DESC;

-- Nested subquery: customers above average customer revenue
SELECT c.customer_id, c.name AS customer_name,
       SUM(o.total_amount) AS customer_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING SUM(o.total_amount) > (
    SELECT AVG(customer_revenue)
    FROM (
        SELECT customer_id, SUM(total_amount) AS customer_revenue
        FROM orders GROUP BY customer_id
    ) AS customer_sales
)
ORDER BY customer_revenue DESC;

-- CTE: customers with revenue above 1,000,000
WITH customer_sales AS (
    SELECT c.customer_id, c.name AS customer_name,
           SUM(o.total_amount) AS revenue
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.name
)
SELECT customer_id, customer_name, revenue
FROM customer_sales
WHERE revenue > 1000000
ORDER BY revenue DESC;

-- CASE: order value tiers
SELECT order_id, customer_id, total_amount,
CASE
    WHEN total_amount > 200000 THEN 'High Value'
    WHEN total_amount >= 100000 THEN 'Medium Value'
    ELSE 'Low Value'
END AS order_category
FROM orders
ORDER BY total_amount DESC;

-- CASE: count orders in each tier
SELECT
CASE
    WHEN total_amount > 200000 THEN 'High Value'
    WHEN total_amount >= 100000 THEN 'Medium Value'
    ELSE 'Low Value'
END AS order_category,
COUNT(*) AS order_count
FROM orders
GROUP BY 1
ORDER BY order_count DESC;

-- RANK: customer revenue ranking
SELECT c.customer_id, c.name AS customer_name,
       SUM(o.total_amount) AS revenue,
       RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS revenue_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY revenue_rank;

-- ROW_NUMBER: unique customer revenue position
SELECT c.customer_id, c.name AS customer_name,
       SUM(o.total_amount) AS revenue,
       ROW_NUMBER() OVER (ORDER BY SUM(o.total_amount) DESC) AS revenue_row_number
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY revenue_row_number;

-- DENSE_RANK: ranking without gaps for ties
SELECT c.customer_id, c.name AS customer_name,
       SUM(o.total_amount) AS revenue,
       DENSE_RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS revenue_dense_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY revenue_dense_rank;

-- LAG: previous customer's revenue
WITH customer_sales AS (
    SELECT c.customer_id, c.name AS customer_name,
           SUM(o.total_amount) AS revenue
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.name
)
SELECT customer_id, customer_name, revenue,
       LAG(revenue) OVER (ORDER BY revenue DESC) AS previous_customer_revenue
FROM customer_sales
ORDER BY revenue DESC;

-- LEAD: next customer's revenue
WITH customer_sales AS (
    SELECT c.customer_id, c.name AS customer_name,
           SUM(o.total_amount) AS revenue
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.name
)
SELECT customer_id, customer_name, revenue,
       LEAD(revenue) OVER (ORDER BY revenue DESC) AS next_customer_revenue
FROM customer_sales
ORDER BY revenue DESC;
