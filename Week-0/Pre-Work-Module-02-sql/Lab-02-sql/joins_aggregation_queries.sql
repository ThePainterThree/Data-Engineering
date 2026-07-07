-- ============================================
-- Lab M2.02 - SQL Joins and Aggregation
-- Student: Patricia Moutinho
-- Date: 05-07-2026
-- ============================================
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS categories;

-- Step 1: Set Up Extended Database
-- Create customers table
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    city TEXT,
    country TEXT,
    registration_date DATE
);
 
-- Create products table
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT,
    category TEXT,
    price DECIMAL(10, 2),
    stock_quantity INTEGER
);
 
-- Create orders table
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    product_id INTEGER,
    order_date DATE,
    quantity INTEGER,
    total_amount DECIMAL(10, 2),
    status TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Create categories table
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT,
    description TEXT
);
 
-- Create order_items table (many-to-many relationship)
CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    unit_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
 
-- Add category_id to products table
ALTER TABLE products ADD COLUMN category_id INTEGER;
UPDATE products SET category_id = 1 WHERE category = 'Electronics';
UPDATE products SET category_id = 2 WHERE category = 'Furniture';
 
 -- Insert sample data
INSERT INTO customers VALUES
(1, 'John', 'Doe', 'john.doe@email.com', 'New York', 'USA', '2023-01-15'),
(2, 'Jane', 'Smith', 'JANE.SMITH@EMAIL.COM', 'London', 'UK', '2023-02-20'),
(3, 'Bob', 'Johnson', 'bob@email.com', 'Toronto', 'Canada', '2023-03-10'),
(4, 'Alice', 'Brown', NULL, 'Sydney', 'Australia', '2023-04-05'),
(5, 'Charlie', 'Wilson', 'charlie.wilson@email.com', 'Berlin', 'Germany', NULL);
 
INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 999.99, 50),
(2, 'Mouse', 'Electronics', 25.50, 200),
(3, 'Keyboard', 'Electronics', 79.99, 150),
(4, 'Monitor', 'Electronics', 299.99, 75),
(5, 'Desk Chair', 'Furniture', 199.99, 30);
 
INSERT INTO orders VALUES
(1, 1, 1, '2024-01-15', 1, 999.99, 'completed'),
(2, 1, 2, '2024-01-16', 2, 51.00, 'completed'),
(3, 2, 3, '2024-02-01', 1, 79.99, 'pending'),
(4, 3, 1, '2024-02-10', 1, 999.99, 'completed'),
(5, 2, 4, '2024-02-15', 2, 599.98, 'completed'),
(6, 4, 2, '2024-03-01', 5, 127.50, 'completed'),
(7, 1, 5, '2024-03-05', 1, 199.99, 'pending'),
(8, 3, 3, '2024-03-10', 3, 239.97, NULL);

-- Insert categories
INSERT INTO categories VALUES
(1, 'Electronics', 'Electronic devices and accessories'),
(2, 'Furniture', 'Office and home furniture');
 
-- Insert order_items
INSERT INTO order_items VALUES
(1, 1, 1, 1, 999.99),
(2, 1, 2, 2, 25.50),
(3, 2, 3, 1, 79.99),
(4, 3, 1, 1, 999.99),
(5, 4, 4, 2, 299.99),
(6, 5, 2, 5, 25.50),
(7, 6, 5, 1, 199.99),
(8, 7, 3, 3, 79.99);

/*
Step 2: Understanding Relationships
Documented foreign keys: 
- orders.customer_id REFERENCES customers.customer_id
- orders.product_id REFERENCES products.product_id
- order_items.order_id REFERENCES orders.order_id
- order_items.product_id REFERENCES products.product_id
*/

--Step 3: INNER JOIN Queries - Write queries using INNER JOIN:
--Join customers and orders: Select customer name and order details for all orders
SELECT  customers.first_name, customers.last_name,
        orders.order_id, orders.order_date, orders.quantity, orders.total_amount, orders.product_id, orders.status
FROM customers
INNER JOIN orders
    ON customers.customer_id = orders.customer_id;

--Join multiple tables: Select customer name, product name, and order quantity
--Join: customers → orders → order_items → products
SELECT  c.first_name, c.last_name, 
        oi.quantity,
        p.product_name
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id;

--Join with categories: Select product name and category name for all products
SELECT p.product_name, cat.category_name
FROM products p
INNER JOIN categories cat
ON p.category_id = cat.category_id;

--Step 4: LEFT JOIN Queries Write queries using LEFT JOIN:
--Find customers without orders: Select all customers and their orders (including customers with no orders)
SELECT c.customer_id, o.order_id
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL; 

--Find products never ordered:Select all products and show which ones have never been ordered
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi
    ON oi.product_id = p.product_id
WHERE oi.order_item_id IS NULL;

--Complete customer order history: Select all customers with their order counts (including customers with 0 orders)
SELECT  c.customer_id, c.first_name, c.last_name,
        COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

--Step 5: RIGHT JOIN and FULL OUTER JOIN 
--SQLite doesn't support RIGHT JOIN or FULL OUTER JOIN directly. If using SQLite:

--Simulate RIGHT JOIN: 
--Use LEFT JOIN with reversed table order to achieve RIGHT JOIN behavior
--Find all orders that don't have customer information 
SELECT  o.order_id, o.customer_id, 
        c.first_name, c.last_name
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

--Simulate FULL OUTER JOIN:
--Use UNION to combine LEFT and RIGHT joins
--Show all customers and all orders, matching where possible
SELECT  c.customer_id, c.first_name, c.last_name,
        o.order_id
FROM customers c 
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
UNION
SELECT  c.customer_id, c.first_name, c.last_name,
        o.order_id
FROM orders o 
LEFT JOIN customers c
    ON o.customer_id = c.customer_id;

--Step 6: Basic Aggregation Functions Write queries using aggregation functions:
--Count records: Count total number of customers
SELECT COUNT(customer_id) AS total_customers
FROM customers;

--Count total number of orders
SELECT COUNT(order_id) AS total_orders
FROM orders;

--Count orders per customer
SELECT  c.customer_id,
        COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

--Sum values: Calculate total revenue from all orders, Calculate total quantity of products ordered
SELECT  SUM(total_amount) AS total_revenue,
        SUM(quantity) AS total_quantity_products_ordered
FROM orders;

--Average values: Calculate average order amount
SELECT AVG(total_amount) AS avg_order_amount
FROM orders;

--Calculate average quantity per order
SELECT AVG(quantity) AS avg_quantity_per_order
FROM orders;
 
--Minimum/Maximum values:Find the most expensive order
SELECT MAX(total_amount) AS most_expensive_order
FROM orders;

--Find the least expensive order
SELECT MIN(total_amount) AS least_expensive_order
FROM orders;

--Find the earliest and latest order dates
SELECT  MIN(order_date) AS earliest_order,
        MAX(order_date) AS latest_order
FROM orders;

--Step 7: GROUP BY Queries Write queries using GROUP BY
--Group by single column: Count orders per customer
SELECT  customer_id,
        COUNT(order_id) AS number_of_orders
FROM orders
GROUP BY customer_id;

--Calculate total revenue per customer
SELECT  customer_id,
        SUM(total_amount) AS total_revenue
FROM orders
GROUP BY customer_id;

--Count products per category
SELECT  category,
        COUNT(product_id) AS count_products
FROM products
GROUP BY category;

--group by multiple columns:
--Calculate total revenue per customer per year (if you have year data)
-- There is no separate year column since all sample orders are from 2024.
SELECT customer_id,
       SUM(total_amount) AS total_revenue
FROM orders
GROUP BY customer_id;

--Count orders per customer per status
SELECT customer_id,
       status,
       COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id, status;

--Group with joins:
--Calculate total revenue per category
SELECT cat.category_name,
       SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM categories cat
INNER JOIN products p
    ON cat.category_id = p.category_id
INNER JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY cat.category_name;

--Count orders per country
SELECT c.country,
       COUNT(o.order_id) AS order_count
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.country;

--Step 8: HAVING Clause Write queries using HAVING to filter grouped results:
--Filter aggregated results:Find customers who have placed more than 2 orders
SELECT  customer_id,
        COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 2;

--Find categories with total revenue greater than 1000
SELECT  cat.category_name,
        SUM(oi.quantity * oi.unit_price) AS total_revenue 
FROM categories cat
INNER JOIN products p
    ON cat.category_id = p.category_id
INNER JOIN order_items oi 
    ON p.product_id = oi.product_id
GROUP BY cat.category_name
HAVING SUM(oi.quantity * oi.unit_price) > 1000;

--Find customers with average order amount greater than 500
SELECT customer_id,
       AVG(total_amount) AS avg_order_amount
FROM orders
GROUP BY customer_id
HAVING AVG(total_amount) > 500;

--Combine WHERE and HAVING:Find customers from 'USA' who have placed more than 1 order
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COUNT(o.order_id) AS order_count
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
WHERE c.country = 'USA'
GROUP BY c.customer_id,
         c.first_name,
         c.last_name
HAVING COUNT(o.order_id) > 1;

--Find products ordered more than 3 times in completed orders
SELECT p.product_name,
       COUNT(oi.order_item_id) AS times_ordered
FROM products p
INNER JOIN order_items oi
    ON p.product_id = oi.product_id
INNER JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id,
         p.product_name
HAVING COUNT(oi.order_item_id) > 3;

--Step 9: Write complex queries combining joins, aggregation, and grouping:
-- Customer order summary:
--For each customer, show: name, total orders, total spent, average order amount
--Include customers with no orders (show 0)
SELECT c.customer_id, c.first_name, c.last_name,
       COUNT(o.order_id) AS total_orders,
       COALESCE(SUM(o.total_amount), 0) AS total_spent,
       COALESCE(AVG(o.total_amount), 0) AS avg_order_amount
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name,c.last_name;

--Product performance: For each product, show: name, category, total quantity sold, total revenue
--Order by total revenue descending
SELECT  p.product_name, 
        cat.category_name,
        SUM(oi.quantity) AS total_quantity,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
INNER JOIN categories cat
    ON p.category_id = cat.category_id
INNER JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name,
        cat.category_name
ORDER BY total_revenue DESC;

-- Category analysis:
-- Show each category with:
-- Number of products
--Total revenue generated
-- Average product price
SELECT cat.category_name,
       COUNT(p.product_id) AS number_of_products,
       COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_revenue,
       AVG(p.price) AS average_product_price
FROM categories cat
LEFT JOIN products p
    ON cat.category_id = p.category_id
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY cat.category_id, cat.category_name;

--Customer segmentation:Categorize customers as 
--'High Value' (total spent > 1000)
--'Medium Value' (500-1000)
-- 'Low Value' (< 500)
--Count customers in each segment
SELECT customer_segment,
       COUNT(customer_id) AS customer_count
FROM (
    SELECT c.customer_id,
           CASE
               WHEN COALESCE(SUM(o.total_amount), 0) > 1000 THEN 'High Value'
               WHEN COALESCE(SUM(o.total_amount), 0) BETWEEN 500 AND 1000 THEN 'Medium Value'
               ELSE 'Low Value'
           END AS customer_segment
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
) AS customer_totals
GROUP BY customer_segment;

