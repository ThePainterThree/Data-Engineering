-- 1-List all distinct products sold, along with their total quantity sold.

SELECT product, SUM(quantity) AS total_quantity_sold
FROM samples.bakehouse.sales_transactions
GROUP BY product
ORDER BY total_quantity_sold DESC;

-- 2-Find the top 5 franchises by total revenue.

SELECT franchiseID, SUM(totalPrice) AS total_revenue
FROM samples.bakehouse.sales_transactions
GROUP BY franchiseID
ORDER BY total_revenue DESC
LIMIT 5;

-- 3 -Count the number of customers per city.

SELECT product, SUM(quantity) AS total_quantity_sold
FROM samples.bakehouse.sales_transactions
GROUP BY product
ORDER BY total_quantity_sold DESC;

SELECT franchiseID, SUM(totalPrice) AS total_revenue
FROM samples.bakehouse.sales_transactions
GROUP BY franchiseID
ORDER BY total_revenue DESC
LIMIT 5;

-- 3. Count the number of customers per city
SELECT c.city, COUNT(DISTINCT t.customerID) AS customer_count
FROM samples.bakehouse.sales_transactions t
JOIN samples.bakehouse.sales_customers c ON t.customerID = c.customerID
GROUP BY c.city
ORDER BY customer_count DESC;

-- 4. Find the average transaction amount per product

SELECT product,
  AVG(totalPrice) AS avg_transaction_amount,
  COUNT(*) AS transaction_count
FROM samples.bakehouse.sales_transactions
GROUP BY product
ORDER BY avg_transaction_amount DESC;

-- 5. Find month-over-month total sales trend (use date_trunc on the transaction date).
SELECT
  date_trunc('month', dateTime) AS month,
  SUM(totalPrice) AS total_sales
FROM samples.bakehouse.sales_transactions
GROUP BY month
ORDER BY month;

-- 6. Join sales_transactions with sales_returns to find the return rate (returns/total sales) per product.
-- There is no return sales table

-- 7. Identify the top 3 best-selling products per franchise using a window function (RANK() or ROW_NUMBER()).
WITH product_sales AS ( 
    SELECT franchiseID, product,
    SUM(totalPrice) AS total_sales,
    ROW_NUMBER() OVER (PARTITION BY franchiseID ORDER BY SUM(totalPrice) DESC) AS product_rank
    FROM bakehouse.sales_transactions
    GROUP BY franchiseID, product
)
SELECT franchiseID, product, total_sales, product_rank
FROM product_sales
WHERE product_rank <= 3
ORDER BY franchiseID, product_rank;

-- 8. Find customers who made purchases but never left a review (anti-join between sales_customers and media_customer_reviews).
-- the reviews table does not have the key required to connect reviews to customers id (unsure if new_id corresponds to customer_id. most likely not.)

SELECT DISTINCT cust.customerID, cust.first_name, cust.last_name, cust.email_address
FROM bakehouse.sales_customers cust
INNER JOIN bakehouse.sales_transactions trans ON cust.customerID = trans.customerID
LEFT JOIN bakehouse.media_customer_reviews reviews ON cust.customerID = reviews.new_id
WHERE reviews.new_id IS NULL
ORDER BY cust.customerID;

-- 9. Calculate the average review rating per product and compare it against sales volume — is there a correlation?
-- not possible to do without the product column in review table

-- 10. Compute a running (cumulative) total of sales per franchise ordered by date, using a window function.
SELECT 
    franchiseID,
    transactionID,
    dateTime,
    totalPrice,
    SUM(totalPrice) OVER (
        PARTITION BY franchiseID
        ORDER BY dateTime, transactionID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM samples.bakehouse.sales_transactions
ORDER BY franchiseID, dateTime, transactionID;

-- 11. Segment customers into spend tiers (e.g., High/Medium/Low) using NTILE() or CASE WHEN on total lifetime spend.

WITH customer_spending AS (
    SELECT customerID, SUM(totalPrice) AS total_spend
    FROM samples.bakehouse.sales_transactions
    GROUP BY customerID
),
customer_tiers AS (
  SELECT customerID, total_spend,
    NTILE(3) OVER (ORDER BY total_spend DESC) AS tier_number
FROM customer_spending
)
SELECT customerID, total_spend,
  CASE WHEN tier_number = 1 THEN 'High'
     WHEN tier_number = 2 THEN 'Medium'
     WHEN tier_number = 3 THEN 'Low'
     ELSE 'Unknown'
     END AS tier
FROM customer_tiers
ORDER BY total_spend DESC;

-- 12. Find each franchise's month with the highest sales ("best month") using QUALIFY + ROW_NUMBER().

WITH monthly_sales AS (
    SELECT
        franchiseID,
        DATE_TRUNC('month', dateTime) AS sales_month,
        SUM(totalPrice) AS total_monthly_sales
    FROM samples.bakehouse.sales_transactions
    GROUP BY franchiseID, DATE_TRUNC('month', dateTime)
)
SELECT franchiseID, sales_month,total_monthly_sales
FROM monthly_sales
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY franchiseID
    ORDER BY total_monthly_sales DESC, sales_month
) = 1
ORDER BY franchiseID;

-- 13. Detect suppliers whose products have above-average return rates compared to the overall average.
-- no available return sales table to complete this question

