-- 05 - VIEWS
-- Purpose: Create a reusable customer revenue view for analysis/Power BI.

CREATE VIEW customer_revenue_view AS
SELECT c.customer_id, c.name AS customer_name,
       SUM(o.total_amount) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- Check the view
SELECT * FROM customer_revenue_view
ORDER BY revenue DESC;

-- High-value customers from the view
SELECT customer_id, customer_name, revenue
FROM customer_revenue_view
WHERE revenue > 1000000
ORDER BY revenue DESC;
