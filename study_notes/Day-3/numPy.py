import numpy as np

#what is the difference between print and return?
#Print, prints the value. Return saves the value.

# To get calculated values out of functions -> aggregated metric

'''
parameter -> acts as a placeholder for a value
argument -> the actual value passed to the func when called  
 ''' 

#Differences between methods and functions:
'''Function:
- is a standalone block of code
- is called by its name. 
- doesn't belong to a specific object
'''

'''Method:
- is function that belongs to an object
- is called using the dot (.) notation on an object
- always belongs to a specific object or class
'''

#create a func Mini calculator that adds, substracts, multiply, divide
#2 inputs from user x and y

x = float(input("Enter your first number: "))
y = float(input("Enter your second number: "))
choice = input("Choose (add, subtract, multiply, divide): ")
    
def mini_calculator(choice, x, y):
    if choice == "add":
        return x + y
    elif choice == "subtract":
        return x- y
    elif choice == "multiply":
        return x * y
    elif choice == "divide":
        return x / y 
    else:
        return "Invalid choice."
    
print (mini_calculator(choice, x, y))


#Alternative - calculator exercise 
# # create functions
def add(a,b):
    return a+b

def subtract(a,b):
    return a-b

def multiply(a,b):
    return a*b

def divide(a,b):
    return a/b

# # take the numbers from the user
num1 = float(input("enter first number:"))
num2 = float(input("enter second number"))

# # givve user the options to chose from
print("choose an option : ")
print("1. Add")
print("2. Subtract")
print("3. Multiply")
print("4. Divide")

# # the user gives an input for the choice
choice = int(input("enter your choice: ")) 

# # from the options above, call the specific function
if choice == '1':
    result = add(num1,num2)
    
if choice == '2' :
    result = subtract(num1,num2)
    
if choice == '3':
    result = multiply(num1,num2)

if choice == '4':
    result = divide(num1,num2)
    
print (f"The answer is: {result}")



# Create a function that calculates salary after 15 % tax 
def salary_after_taxes(salary, tax_percentage):
    tax = salary * tax_percentage
    return salary - tax

print(salary_after_taxes(1000, 0.15))



#create a function that calcs salary according to tax class
# salary > 50.000 == tax is  20%
# salary > 35.000 and < 50k == tax is 15%
# salary < 35.000 == tax is 12%

def salary_taxed_by_classification(salary):
    if salary > 50000:
       tax_percentage = 0.20
       print("20% tax")
    elif salary >= 35000 and salary <= 50000:
       tax_percentage = 0.15
       print("15% tax")
    else:
       tax_percentage = 0.12
       print("12% tax")

    tax = salary * tax_percentage
    return salary - tax

salary = float(input("Enter your salary: "))
print(salary_taxed_by_classification(salary))



'''NumPy Array -> requires the numpy package, Usually stores one data type (all ints, all floats, etc.)
Faster for numerical calculations, optimized for math and large datasets '''

'''List = Built into Python, Can store different data types, flexible, not optimized for math'''	
    
numbers = np.array([1, 2, 3, 4, 5])

print(numbers)
print(numbers[0])

numbers = np.array([1, 2, 3])

print(numbers + 1)
# [2 3 4]

print(numbers * 2)
# [2 4 6]

np.array([...])
np.zeros(5)
np.ones((2,3))
print(np.arange(10, 0, -1))

#Accessing the values: print(arr [r][c])
arr = np.array([[10, 20, 30],
                [40, 50, 60],
                [70, 80, 90]])

print(arr[0, 1])# row 0, col 1
print(arr[2][-1]) # row 1, col 2

print(arr[-1, -1]) # last row, last col

a = np.array([10,12,14,17,18,23,45,15,78])
#accessing values inside the array
print(a[2:6])      # elements 2,3,4,5
print(a[:4])       # first four
print(a[::2])      # every second element

#Reshape method = arrange them into 3 rows and 3 columns
m = a.reshape(3,3)
print(m)

# slice the array
print(m[0:2, 1:3]) # first two rows, cols 1 and 2

data = np.array([[10, 20, 30],
                  [40, 50, 60],
                  [70, 80, 90],
                  [20, 30, 80]])

print("Total sum:", data.sum())

#axis = 0 (result will beColumn )
#axis = 1 ( result will be on row basis)
#print("Column-wise mean:", data.mean(axis=0))
#print("Row-wise max:", data.max(axis=1))
# print("Overall min:", np.min(data))

