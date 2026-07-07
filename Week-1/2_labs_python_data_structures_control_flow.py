#Lab 1: Pass / Fail using if
#Given a student's marks (out of 100), print "Pass" if marks are 40 or above, otherwise print "Fail".
marks = 72

if marks >= 40:
    print("Pass")
else:
    print("Fail")


#Lab 2: Grade using if / elif / else
#Classify a score into grades:
score = 83

def grades(number):
    if number >= 90:
        print("Grade A")
    elif number > 75 and number <= 89:
        print("Grade B")
    elif number > 60 and number <= 74:
        print("Grade C")
    elif number > 40 and number <= 59:
        print("Grade D")
    else:
         print("Fail")
    
grades(score)


#Lab 3: Eligibility check with nested conditions
#A customer is eligible for a loan if:
#age is 21 or older
#AND has_income is True
#If age >= 21 but has_income is False, print "Not eligible: no income"
#If age < 21, print "Not eligible: underage"

age = 25
has_income = True

if age >= 21:
    if has_income:
        print("Eligible for loan")
    else:
        print("Not eligible: no income")

else:
   print("Not eligible: underage")


#Lab 4: For loop over customer names
#Given a list of customer names, print a line "Hello, !" for each customer.

customers = ["Asha", "Ravi", "Meera"]

for customer in customers:
    print(f"Hello, {customer}!")


#Lab 5: While loop — simple counter
count= 0

while count <= 5:
    print(count)
    count += 1


#Lab 6: break and continue in order processing
#You have a list of order amounts (positive and negative). Process orders:
#Skip negative amounts (use continue).
#If an order amount is greater than 10000, stop processing further orders (use break).
#Print "Processed: " for each processed order.

orders = [1500, -50, 300, 12000, 200]
for amount in orders:
    if amount < 0:
        continue
    if amount > 10000:
        break
    print(f"Processed: {amount}")


#Lab 7: List operations — manage order IDs
#Start with order IDs [101, 102, 104]. 
# A new order 103 arrived and should be inserted at the correct position. 
# Remove order 102 later. 
# Finally, print the first two order IDs.
order_ids = [101, 102, 104]

order_ids.insert(2, 103)
order_ids.remove(102)
print(order_ids)

#slice it! list_name[start_index:stop_index]
print(order_ids[:2])

# #alternative to slice method -> create a list 
# first_two_ids = [order_ids[0], order_ids[1]]
# print(first_two_ids)


#Lab 8: Tuples — immutable product record
#A product record is stored as a tuple: (product_id, name, price).
# Unpack the tuple into variables and print them. 
# Then attempt to change price (explain why it's not allowed).
product = (501, "Notebook", 49.99)

#unpacking
product_id, product_name, price = product
print("ID: ", product_id)
print("Name: ", product_name)
print("Price ", price)

#product[2] = 55.90
#Tupples are immutable therefore cannot be changed. 
# Attempting to do so, woill result in an error:
#TypeError: 'tuple' object does not support item assignment


#Lab 9: Sets — remove duplicate order IDs
order_ids = [201, 202, 201, 203, 202, 204]
cleaned_ids_set = set(order_ids)
print(cleaned_ids_set)
print(len(cleaned_ids_set))

    
#Lab 10: Dictionary — single customer record
#Create a customer dictionary with keys: 
# id, name, city. Update the city, 
# then print "Customer - lives in "
customer = {
            "id": 1, 
            "name": "Priya", 
            "city": "Pune"
            }
#print(customer)
customer["city"] = "Mumbai"
#print(customer)
print(f"Customer {customer['id']} - {customer['name']} lives in {customer['city']}")


#Lab 11: Nested dictionaries — customers database
#Create a customers database where keys are customer IDs and values 
# are dictionaries with name and total_orders. 
# Print the name and total_orders for customer id 102.
customers = {
    101: {"name": "Anil", "total_orders": 3},
    102: {"name": "Geeta", "total_orders": 5},
    103: {"name": "Sam", "total_orders": 1}
}
#save the customer in an variable
id_102 = customers[102]
print(f"{id_102['name']} has {id_102['total_orders']} orders")


#Lab 12: Looping through dictionary items and aggregation
#Given a customers dict with total_order_amount per customer,
#compute the total sales across all customers.
sales = {
    "Asha": 1200.50,
    "Rohan": 250.00,
    "Tina": 799.99
}

total_order_amount = 0

for sale in sales.values():
    total_order_amount += sale
print(f"Total sales: {total_order_amount:2f}")


#Lab 13: Find top customer by order amount using loops + dicts
#From a dictionary of customers and their order totals, 
# find the customer with the maximum total
# print "Top customer: with ".

totals = {"Asha": 1200.50, "Rajan": 3200.00, "Leela": 2450.75}

top_customer = " "
highest_total = 0

for customer, amount in totals.items():
    if amount > highest_total:
        highest_total = amount
        top_customer = customer

print(f"Top customer: {top_customer} with {highest_total}")

#Lab 14: While loop simulating balance updates
#Simulate transactions applied to an account balance using a list of transactions. 
# Skip zero-amount transactions (use continue). 
# Stop if balance becomes negative (use break). 
# Print the final balance and whether processing stopped early.
#Processing stopped early due to negative balance.
#Final balance: -50.0

balance = 500.0
transactions = [100.0, -50.0, 0.0, -600.0, 200.0]
#TO DO 


#Solution for Lab 15: Choosing the right data structure — scenario tasks
#For each mini-task, write code that uses an appropriate data structure and print the result:
#a) You have product IDs that must not change — choose an immutable collection. 
# b) You need to check membership quickly and remove duplicates from order IDs. 
#c) You need to maintain insertion order and allow duplicates for transactions.

product_ids = [701, 702, 703]
order_ids = [801, 802, 801, 803]
transactions = [10, -5, 10, 20]

immutable_ids = tuple(product_ids)
unique_order_ids =set(order_ids)
transactions_list = list(transactions)

print("Immutable product IDs:", immutable_ids )
print("Unique order IDs for quick membership:", unique_order_ids)
print("Transactions list (order preserved, duplicates allowed):", transactions_list)


#Lab 16: Final Integrated Lab: Orders mini-ETL
#You are given a list of order records (each record is a dictionary):
# Filter orders with status "delivered".
# Compute total amount per customer for delivered orders.
# Create a set of unique product_ids sold in delivered orders.
# Produce a nested dictionary named report with:
# "totals_by_customer": {customer_name: total_amount}
# "unique_products": set(...)
# "delivered_count": count of delivered orders
# Print the report in a readable manner.

#TO DO on weekend