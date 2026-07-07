--Step 1: Set Up Enhanced Database
-- Add more historical data to orders
INSERT INTO orders VALUES
(9, 1, 2, '2023-12-01', 1, 25.50, 'completed'),
(10, 2, 1, '2023-12-15', 1, 999.99, 'completed'),
(11, 3, 4, '2024-01-05', 1, 299.99, 'completed'),
(12, 4, 3, '2024-01-20', 2, 159.98, 'completed'),
(13, 5, 5, '2024-02-01', 1, 199.99, 'completed');
 
-- Create customer_segments table
CREATE TABLE customer_segments (
    segment_id INTEGER PRIMARY KEY,
    segment_name TEXT,
    min_spend DECIMAL(10, 2),
    max_spend DECIMAL(10, 2)
);
 
INSERT INTO customer_segments VALUES
(1, 'Bronze', 0, 500),
(2, 'Silver', 500, 1000),
(3, 'Gold', 1000, 5000),
(4, 'Platinum', 5000, 999999);
 
-- Create order_history view (for time-series analysis)
-- This will be used in window function examples

--Step 2: Scalar Subqueries Write queries using scalar subqueries.
-- Recap: a scalar subquery == query inside another query that returns ONE value (one row, one column) 
--and then that value is used ion the outer query to calculate, compare or display something.

--Compare to average: Find all orders where total_amount is greater than the average order amount
--Use a scalar subquery to calculate the average
SELECT *
FROM orders
WHERE total_amount >
(
    SELECT AVG(total_amount)
    FROM orders
);

--Single value lookup: For each order, show the customer's registration date
--Use a scalar subquery in SELECT
SELECT
    order_id, customer_id,total_amount,
    (
        SELECT registration_date
        FROM customers
        WHERE customers.customer_id = orders.customer_id
    ) AS registration_date
FROM orders;

--Conditional filtering: Find products priced above the average product price
--Use scalar subquery in WHERE clause
SELECT *
FROM products
WHERE price >
(
    SELECT AVG(price)
    FROM products
);

--Step 3: Inline Subqueries (Derived Tables) Write queries using inline subqueries:
--Subquery in FROM:Find the top 3 customers by total spending
--Use a subquery to calculate spending first, then select top 3
SELECT customer_id, customer_name, total_spent
FROM (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        SUM(o.total_amount) AS total_spent
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
) AS customer_spending
ORDER BY total_spent DESC
LIMIT 3;

--Multiple derived tables:compare customer spending to category averages
--Join multiple subqueries
SELECT
    customer_totals.customer_id,
    customer_totals.customer_name,
    customer_totals.category_id,
    customer_totals.customer_category_spend,
    category_averages.avg_category_spend
FROM (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        p.category_id,
        SUM(o.total_amount) AS customer_category_spend
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN products p
        ON o.product_id = p.product_id
    GROUP BY c.customer_id, p.category_id
) AS customer_totals
JOIN (
    SELECT
        p.category_id,
        AVG(o.total_amount) AS avg_category_spend
    FROM orders o
    JOIN products p
        ON o.product_id = p.product_id
    GROUP BY p.category_id
) AS category_averages
    ON customer_totals.category_id = category_averages.category_id;

--Complex filtering:Find customers who spent more than the average of all customers
--Use subquery to calculate average, then filter
--recap HAVING: condition checker for groups
--recap WHERE checks indicidual rows 
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING SUM(o.total_amount) >
(
    SELECT AVG(total_spent)
    FROM (
        SELECT
            SUM(total_amount) AS total_spent
        FROM orders
        GROUP BY customer_id
    )
);

--Step 4: Correlated Subqueries Write queries using correlated subqueries:
--recap:a correlated subquery runs once for every row in the outer query. Unlike the scalar that only runs once.
--Row-by-row comparison:For each customer, find orders that are above their personal average order amount
--Use correlated subquery referencing outer query
-- o = the current order from the outer query.
-- o2 = all the orders used to calculate the customer's average.
SELECT o.order_id, o.customer_id,o.total_amount
FROM orders o
WHERE o.total_amount > (
    SELECT AVG(innerOrders.total_amount)
    FROM orders innerOrders
    WHERE innerOrders.customer_id = o.customer_id
);

--Existence checks:Find customers who have placed at least one order in the last 30 days
--Use EXISTS with correlated subquery
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name
FROM customers c
WHERE EXISTS (
    SELECT o.order_id
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.order_date BETWEEN date('now', '-30 days') AND date('now')
);

--Ranking within groups:For each category, find products priced above the category average
--Use correlated subquery with category grouping
SELECT p.product_id, p.product_name, p.category_id, p.price
FROM products p
WHERE p.price > (
    SELECT AVG(p2.price)
    FROM products p2
    WHERE p2.category_id = p.category_id
);

--Step 5: Common Table Expressions (CTEs) Rewrite complex queries using CTEs:
--recap: CTE = Common Table Expression -> is a temporary named result set.
--recap: CTE's Only exists for the duration of one SQL query.

--Simple CTE: Calculate customer total spending using a CTE
--Then use the CTE to find high-value customers
--the first line creates a temporary table named cte_customer_spending
WITH cte_customer_spending AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        --it calculates how much each customer has spent
        SUM(o.total_amount) AS total_spent
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
)
SELECT
    customer_id,
    customer_name,
    total_spent
FROM cte_customer_spending
WHERE total_spent > 500
ORDER BY total_spent DESC;

--Multiple CTEs: Create CTEs for: customer spending, product sales, category revenue
--Join these CTEs to create a comprehensive report
--Recursive CTE (if supported):

--If your database supports it, create a recursive CTE
--Otherwise, document how you would use it

--CTE for readability: Take a complex query from previous steps
--Rewrite it using CTEs to improve readability

--Step 6: Window Functions - Ranking Write queries using ranking window functions:
--ROW_NUMBER: Assign row numbers to orders within each customer
--Order by order_date

--RANK:Rank customers by total spending
--Handle ties appropriately

--DENSE_RANK:rank products by total sales quantity
--Compare RANK vs DENSE_RANK results

--Top N per group:Find the top 2 orders for each customer
--Use ROW_NUMBER with PARTITION BY