import numpy as np

#Lab 1: Simple Greeting Function
def greet(name):
    return f"Hello, {name}"
 
print(greet("Priya"))
print(greet("Alice"))

#Lab 2: Add Two Numbers
def add_numbers(a, b):
    return a + b

result = add_numbers(15, 27)
print(result)


#Lab 3: BMI Calculator (Function with Return)
def calculate_bmi(weight_kg, height_m):
    BMI = weight_kg / (height_m ** 2)
    return round((BMI), 2)

print(calculate_bmi(60, 1.68))


#Lab 4: Billing Calculator with Default Arguments

def calculate_total(amount, tax_rate=0.05):
    tax = amount * tax_rate
    return amount + tax

print(f"Total: {calculate_total(100):.2f}")
print(f"Total: {calculate_total(200, 0.12):.2f}")


#Lab 5: Function Naming and Docstring — Discount Calculator
#Create a function apply_discount(price, discount_percent) that returns the discounted price. 
#Add a one-line docstring describing what the function does.
def apply_discount(price, discount_percent):
    '''returns the price after applying the discount percentage'''
    discount = price * (discount_percent /100)
    return price - discount

print(apply_discount(250, 10))
#help(apply_discount)


#Lab 6: Reusable Utility — Normalize Names
def normalize_name(name):
    clean_str = " ".join(name.strip().split())
    return clean_str.title()

print(normalize_name("BOB mcDONALD"))


#Lab 7: Function Returning Multiple Values — Basic Stats
def basic_stats(numbers):
    count = len(numbers)
    total = sum(numbers)
    
    if count > 0:
        mean = total / count
    else:
        mean = None

    return count, total, mean

'''printing happens outside the function = func is reusable'''
count, total, mean  = basic_stats([10, 20, 30])
print("Count:", count)
print("Total:", total)
print("Mean:", mean)


#Lab 8: Apply Function to a List of Amounts — apply_tax
def apply_tax(amounts, tax_rate=0.1):
    new_list_taxed = []
    for amount in amounts:
        new_list_taxed.append(amount + (amount * tax_rate))
    return new_list_taxed

amounts = [100, 200, 350]
result = apply_tax(amounts, 0.05)
print(result)

#Lab 9: Function with Optional Argument and Simple Validation
def process_score(score, max_score=100):
    if score > max_score | score < 0:
        return None
    
    percentage= (score / max_score) * 100
    return round(percentage, 1)

print(process_score(85))
print(process_score(150))

#Lab 10: NumPy — Create Arrays
py_list = [10, 20, 30, 40, 50]
arr = np.array(py_list)
print(arr)
print(arr.dtype)

   
#Lab 11: Array Indexing and Slicing 
arr = np.array([10, 20, 30, 40, 50])
first_element = arr[0]
last_element = arr[-1]
#Slice from index 1 to 3 (inclusive of start, exclusive of end)
slice_1_to_3 = arr[1:3]
 
print("First:", first_element)
print("Last:", last_element)
print("Slice 1:3->", slice_1_to_3)


#Lab 12: Array Filtering (Boolean Masks) 
sales = np.array([120, 250, 90, 400, 60])
high_sales = sales[sales > 100]
print(high_sales)