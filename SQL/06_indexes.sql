-- 06 - INDEXES & QUERY PERFORMANCE
-- Purpose: Improve searches by customer_id and order_date,
--          then verify index usage with EXPLAIN ANALYZE.

CREATE INDEX idx_orders_customer_id
ON orders(customer_id);

CREATE INDEX idx_orders_order_date
ON orders(order_date);

-- Verify customer_id index usage
EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE customer_id = 90;

-- Verify order_date index usage for October 2025
EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE order_date >= '2025-10-01'
  AND order_date < '2025-11-01';
