#Lab 1: Hello Data Engineering (print & comments)
# Python is commonly used in data engineering because it has many libraries for data processing and simple syntax to learn.
hello = "Welcome to Data Engineering with Python"
print(hello)

#Lab 2: Execution Flow with print statements
#Create three print statements in sequence:
step1 = "Step 1: Read data"
step2 = "Step 2: Clean data"
step3 = "Step 3: Write data"

print(step1)
print(step2)
print(step3)

#Lab 3: Variables and assignment
#Create variables for a customer record:
#Print a summary line: "Customer 101: Asha Patel (Active: True)"
customer_name = "Asha Patel"
customer_id = 101
active = True

print(f"Customer {customer_id}: {customer_name} (Active: {active})")

#Lab 4: Data types (int, float, str, bool)
#Given these values, print each value and its type on a separate line: 
int_value = 250
float_value = 99.95
string_value = "Mumbai"
bool_value = False

print(f"Value: {int_value}, Type: {type(int_value)}")
print(f"Value: {float_value}, Type: {type(float_value)}")
print(f"Value: {string_value}, Type: {type(string_value)}")
print(f"Value: {bool_value}, Type: {type(bool_value)}")

#Lab 5: Type casting (int(), float(), str())
#Calculate total marks as float and print: "Total marks: 163.5"
mark1 = "78"
mark2 = "85.5"
total_marks = float(mark1) + float(mark2)
print(f"Total marks: {total_marks}")

#Lab 6: Billing calculator (arithmetic, monetary formatting)
#format total to two decimal places
item_price = 249.99
quantity = 3
tax_rate = 0.05 # 5%

subtotal = item_price * quantity
tax = subtotal * tax_rate
grand_total = subtotal + tax

grand_total_decimal = round(grand_total, 2)
#Or use {grand_total:.2f}to format two decimal places
print(f"Grand Total: {grand_total_decimal}")

#Lab 7: Comparison operators
#Print answers to: Is order1 greater than order2? Are the orders equal?
order1 = 1200
order2 = 999

print("Is order1 > order2?", order1 > order2)
print("Are order1 and order2 equal?", order1 == order2)

#Lab 8: Logical operators
#Determine and print: 
#Is this a high value item (price > 1000 and in_stock is True)?

#Is it either high value or out of stock? (use or with a reversed boolean)
price = 1500
in_stock = True
high_value_and_in_stock = (price > 1000) and in_stock
high_value_or_out_of_stock = (price > 1000) or (not in_stock)

print("High value and available?", high_value_and_in_stock)
print("High value or out of stock?", high_value_or_out_of_stock)

#Lab 9: Input and output (input(), print())
#Write a script that asks the user to enter their name and purchase amount
#Then print:"Receipt — Customer:, Amount: <amount formatted to 2 decimals>"

#name = input("Enter customer name: ")
#amount = float(input("Enter purchase amount: "))

name = "Raj"
amount = float("350.5")
print(f"Receipt — Customer: {name}, Amount: {amount:.2f}")

#Lab 10: f-strings and formatted output
product = "SSD"
price = 12999.5
qty = 2
total_price = price * qty

print(f"Order: {qty} x {product} @ {price} each — Total: {total_price:.2f}")

#Lab 11: Basic debugging — identify and fix errors
name = "Neha"
print(name) 

age = 30
print(f"Age next year: {int(age) + 1}")

value = "123"
num = int(value)
print(num)

#Lab 12: Marks percentage calculator (optional preview: simple if/else)
#Compute percentage (out of 300) and print: "Percentage: 77.33%"
#print "Result: Pass" if percentage >= 35 else "Result: Fail"

m1 = "78"
m2 = "85"
m3 = "69"

total = int(m1) + int(m2) + int(m3)
percentage = (total/300) * 100
print(f"Percentage: {percentage:.2f}%")

if percentage >= 35:
    print("Result: Pass")
else:
    print("Result: Fail")

#Lab 13: Discount calculation and rounding
#calculate discount_amount = original_price * (discount_percent / 100)
#calculate final_price = original_price - discount_amount
#print "Discount: 624.99" "Final Price: 4374.99"

original_price = 4999.99
discount_percent = 12.5
 
discount_amount = original_price * (discount_percent / 100)
final_price = original_price - discount_amount
 
print(f"Discount: {discount_amount:.2f}")
print(f"Final Price: {final_price:.2f}")

#Lab 14: Final Integrated Lab: Student profile + billing (no loops/functions)

name = "Rohan Verma"
s_id = "205"
item = "Textbook"
unit_price = "450.5"
quantity = "2"

student_id = int(s_id)
unit_price = float(unit_price)
quantity = int(quantity)

subtotal = unit_price * quantity
tax_percentage = 0.05
tax = subtotal * tax_percentage
grand_total = subtotal + tax

print(f"Student ID: {student_id}")
print(f"Student Name: {name}")
print(f"Item: {item}")
print(f"Quantity: {quantity}")
print(f"Subtotal: {subtotal:.2f}")
print(f"Tax (5%): {tax:.2f}")
print(f"Grand Total: {grand_total:.2f}")

