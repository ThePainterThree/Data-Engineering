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