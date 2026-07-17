import sqlite3
#basic py notes:
# connection = opening a conversation with the database.
# cursor = the tool you use to ask the database to do something.
# execute() = send one SQL command.
# executemany() = send the same SQL command many times with different data.
# commit() = save your changes permanently.

#1 - set up and open connection with database
connection = sqlite3.connect("query_performance.db") 
cursor = connection.cursor() 

cursor.execute("DROP TABLE IF EXISTS orders") 

# 2-Create the table
cursor.execute("""
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    amount_gbp REAL NOT NULL,
    status TEXT NOT NULL
)
""")

#...and populate the table
orders = [
    (
        order_id,
        ((order_id - 1) % 500) + 1,       
        10 + (order_id % 90),          
        "Dispatched" if order_id % 2 == 0 else "Confirmed"
    )
    for order_id in range(1, 5001)
]

print(orders[:5])

#3-Insert all orders
cursor.executemany("""
INSERT INTO orders (order_id, customer_id, amount_gbp, status)
VALUES (?, ?, ?, ?)
""", orders)

connection.commit() 
query = """ 
SELECT order_id, amount_gbp 
FROM orders 
WHERE customer_id = 101 
""" 

# 4.Check the plan before the index 
cursor.execute(f"EXPLAIN QUERY PLAN {query}") 
print("Before index:") 
for row in cursor.fetchall(): 
 print(row) 

# 5-Create the index 
cursor.execute(""" 
CREATE INDEX idx_orders_customer_id 
ON orders(customer_id) 
""") 

connection.commit() 

# 6Check the plan after the index 
cursor.execute(f"EXPLAIN QUERY PLAN {query}") 
print("\nAfter index:") 
for row in cursor.fetchall(): 
 print(row) 

connection.close() 

