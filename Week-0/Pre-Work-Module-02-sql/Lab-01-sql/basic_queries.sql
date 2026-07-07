-- ============================================
-- Basic SQL Queries Lab
-- Student: Patricia Moutinho
-- Date: 05-07-2026
-- ============================================

-- Step 2 Basic SELECT Queries
--Select all customers:
SELECT *
FROM customers;

--Retrieve only customer_id, first_name, last_name, and email from customers
SELECT customer_id, first_name, last_name, email
FROM customers;

--Retrieve customer names with aliases:
SELECT 
    customer_id AS ID,
    first_name AS "First Name",
    last_name AS "Last Name"
FROM customers;

-- Step 3 Filtering with WHERE
-- Find all customers from 'USA'
SELECT customer_id,country
FROM customers
WHERE country = 'USA';

-- Find all completed orders with total_amount greater than 100
SELECT order_id, total_amount
FROM orders
WHERE status = 'Completed Order' 
    AND total_amount > 100;

--Filter with IN: Find all products in 'Electronics' or 'Furniture' categories
SELECT product_id, product_name, category
FROM products
WHERE category IN ('Electronics', 'Furniture');

--Filter with LIKE: Find all customers whose email contains '@email.com'
SELECT *
FROM customers
WHERE email LIKE '%@email.com';

--Filter with date range: Find all orders placed in February 2024
SELECT *
FROM orders
WHERE order_date BETWEEN '2024-02-01' AND '2024-02-29';

--Step 4: Handling NULL Values
--Find all customers with NULL email addresses
SELECT *
FROM customers
WHERE email IS NULL;

--Exclude NULL values:
SELECT *
FROM customers
WHERE email IS NOT NULL;

-- Find all customers with non-NULL registration dates
SELECT *
FROM customers
WHERE registration_date IS NOT NULL;

-- Find NULL in orders: find all orders where status is NULL 
SELECT *
FROM orders
WHERE status IS NULL;

--Use COALESCE: Select all orders and display 'Unknown' if status is NULL
SELECT 
    order_id,
    COALESCE(status, 'Unknown') AS status
FROM orders
WHERE status IS NULL;

--Step 5: Using SQL Functions - Text Cleaning
--LOWER function: Select all customer emails in lower case
SELECT LOWER(email)
FROM customers;

--UPPER function:Select all customer cities in uppercase
SELECT UPPER(city)
FROM customers;

--TRIM function:Select product names with leading/trailing spaces removed (if any)
SELECT TRIM(product_name) AS clean_name
FROM products;

--CONCAT function:Create a full name by concatenating first_name and last_name with a space
SELECT first_name || " " || last_name AS full_name
FROM customers;

--Step 6: Using SQL Functions - Data Type Conversion Write queries using CAST/CONVERT:
-- Convert to string: Convert customer_id to TEXT in your SELECT
SELECT CAST(customer_id AS TEXT) AS customer_id_to_string
FROM customers;

--Convert to number:Ensure total_amount is displayed as DECIMAL with 2 decimal places
SELECT CAST(total_amount AS DECIMAL(10,2)) AS total_amount_to_decimal
FROM orders;

--Date formatting:Select order_date and format it as a string (if your database supports it)
SELECT CAST(order_date AS TEXT) AS order_date
FROM orders;

--Step 7: Combining Functions Write more complex queries combining multiple functions:
--Clean email format: Select customer emails in lowercase and trimmed
SELECT LOWER(TRIM(email)) AS clean_email
FROM customers;

--Customer display format:Create a formatted customer display: "Last Name, First Name (Email)" using CONCAT
SELECT last_name || ", " || first_name || " (" || email || " )" AS customer_formatted

--Calculate and format:Select orders with a calculated field showing "Quantity x Price = Total" as a formatted string


--Step 8: Sorting and Limiting Results Write queries with ORDER BY and LIMIT:
--Sort customers:Select all customers ordered by last_name alphabetically
SELECT *
FROM customers
ORDER BY last_name ASC;

--Sort by multiple columns:Select orders ordered by order_date (descending) then by total_amount (descending)
SELECT *
FROM orders
ORDER BY order_date DESC, total_amount DESC;

--Limit results:Select the top 3 most expensive orders
SELECT *
FROM orders
ORDER BY total_amount DESC
LIMIT 3;