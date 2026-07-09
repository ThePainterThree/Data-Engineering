import numpy as np

#4. Combined Practice Set 
#Problem 1: Simple function and return (Beginner)
# Write a function tax_amount(subtotal, tax_rate=0.05) that returns just the tax amount (not total).
# Input: subtotal=2000
# Expected output: 100.0

def tax_amount(subtotal, tax_rate):
    return subtotal * tax_rate

print(tax_amount(2000, 0.05))     

#Problem 2: Utility function (Beginner)
# Write a function format_amount(amount) that returns string with two decimal places.
# Input: format_amount(123.456)
# Expected output: "123.46"

def format_amount(amount):
    return f"{amount:.2f}"

print(format_amount(123.456))

#Problem 3: Parameters and named args (Intermediate)
# Define compute_total(subtotal, tax_rate=0.05, discount_pct=0) 
# to return final amount.
# Test: compute_total(1000, discount_pct=10)
# Expected output: 945.0

def compute_total(subtotal, tax_rate=0.05, discount_pct=0):
  discount = subtotal * (discount_pct / 100)
  subtotal_with_discount = subtotal - discount
  tax = subtotal_with_discount * tax_rate
  return subtotal_with_discount + tax


print(compute_total(1000, discount_pct=10 ))


#Problem 4: NumPy array creation and basic ops (Intermediate)
# Create a NumPy array of daily_sales = [100, 150, 200, 50, 300]
# Compute total sales and average sales.
# Expected output:
# Total: 800
# Average: 160.0

daily_sales = np.array([100, 150, 200, 50, 300])
print("Total sum:", daily_sales.sum())
avg = np.mean(daily_sales)
print(avg)


# Problem 5: Array filtering and aggregation (Advanced)
# Given sensor = np.array([0.2, -0.1, 0.5, 1.2, -0.4, 0.7])
# Filter to keep only positive readings and compute mean.
# Expected output: positive readings: [0.2 0.5 1.2 0.7], mean: 0.65

sensor = np.array([0.2, -0.1, 0.5, 1.2, -0.4, 0.7])
filtered_numbers = sensor[sensor > 0]
#print(filtered_numbers)
avg_sensor = round(np.mean(filtered_numbers), 2)
print(avg_sensor)


# Problem 6: Reusable utility + NumPy (Advanced)
# Write a function normalize(arr) that returns array / arr.sum() using NumPy.
# Input: np.array([10, 30, 60])
# Expected output: [0.1, 0.3, 0.6]
# Hints: use return values, avoid printing inside utilities unless for debugging.
#To normalize => to scale values so they add up to 1.
arr = np.array([10,30,60])

def normalize(arr):
    return arr / arr.sum()
   
result = normalize(arr)
#print(result)
