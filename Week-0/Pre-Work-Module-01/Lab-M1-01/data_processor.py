import json
import csv
import os

#Step 3: Implement Data Reading Function
def read_orders(file_path):
    try:
        with open(file_path, "r") as file:
            orders = json.load(file)
            return orders
        
    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
        return []
    except json.JSONDecodeError:
        print(f"Error: Invalid JSON in file '{file_path}'.")
        return []
    except Exception as e:
        print(f"Unexpected error: {e}")
        return []

#Step 4: Implement Data Cleaning Functions
#removes leading/trailing whitespace and converts to title case  
def clean_customer_name(name):
    return name.strip().title()

#checks if required fields exist in order
def validate_order(order):
    required_fields = ["order_id", "customer_name", "product", "quantity", "price","order_date"]

    for field in required_fields:
        if field not in order:
            return False
        
    #validates that quantity is a positive integer  
    try:
        quantity = int(order["quantity"])
    except ValueError:
        return False
    
    if quantity <= 0:
        return False

    #validates that price is a valid positive float
    try:
        price = float(order["price"])
    except ValueError:
        return False
    
    if price <= 0:
        return False
    
    #returns True if valid, otherwise the previous checks return False
    return True

def normalize_order(order):
    order["customer_name"] = clean_customer_name(order["customer_name"])
    order["quantity"] = int(order["quantity"])
    order["price"] = float(order["price"])
    return order

#Step 5: Remove Duplicates
def remove_duplicates(orders):
    #track order_ids
    seen_ids = set()
    unique_order_list = []

    for order in orders:
        if order["order_id"] not in seen_ids:
            seen_ids.add(order["order_id"])
            unique_order_list.append(order)
    return unique_order_list

#Step 6: Process All Orders    
def process_orders(orders):
    valid_orders = [order for order in orders if validate_order(order)]
    normalized_orders = [normalize_order(order) for order in valid_orders]    
    unique_orders_cleaned = remove_duplicates(normalized_orders)
    return unique_orders_cleaned

#Step 7: Calculate Summary Statistics
def calculate_summary(orders):
    #total number of orders
    total_orders = len(orders)
   
   #calculate total revenue
    total_revenue = 0
    for order in orders:
       total_revenue += order["quantity"] * order["price"]

    ''' 
    "Find the most ordered product." 
    Meaning the product with highest quantity sold? 
    '''
    #create dictionary container to store product and quantity  
    product_quantities = {}

    for order in orders:
        product = order["product"]
        quantity = order["quantity"]

        if product in product_quantities:
            product_quantities[product] += quantity
        else:
            product_quantities[product] = quantity
            
    #Calculate the most ordered product considering quantity
    count_quantity = 0
    most_ordered_product = ""

    for product in product_quantities:
        if product_quantities[product] > count_quantity:
            count_quantity = product_quantities[product]
            most_ordered_product = product 

    return {
        "total_orders": total_orders,
        "total_revenue": total_revenue,
        "most_ordered_product": most_ordered_product 
    }

#Step 8: Write Output Files
#Create a function write_csv
def write_csv(orders, file_path):
    try:
        with open(file_path, "w", newline="") as file:
            writer = csv.writer(file)
            #headers
            writer.writerow([
                "order_id",
                "customer_name",
                "product",
                "quantity",
                "price",
                "order_date"
                ])
            
            #rows
            for order in orders:
                writer.writerow([
                    order["order_id"],
                    order["customer_name"],
                    order["product"],
                    order["quantity"],
                    order["price"],
                    order["order_date"]
                 ])
            
    except Exception as e:
        print(f"Error: {e}")

#Create a function write_summary 
def write_summary(summary, file_path):
    try: 
        with open(file_path, "w") as f:
            f.write("Order Report\n\n")
            f.write(f"Total Orders:{summary['total_orders']}\n")
            f.write(f"Total Revenue:{summary['total_revenue']}\n")
            f.write(f"Most Ordered Product:{summary['most_ordered_product']}\n")

    except Exception as e:
        print(f"Error: {e}")

def main():
    #input and output file paths
    input_file = "data/orders.json"
    output_csv = "output/cleaned_orders.csv"
    output_summary_txt = "output/summary.txt"

    #Calls read_orders() to load data
    print("Reading orders")
    orders = read_orders(input_file)

    '''added exiting logic because I realised that if json file_path is incorrect
    the program continues to run'''
    if not orders:
        print("No orders to process.")
        return 

    print("Processing orders")
    clean_orders = process_orders(orders)

    print("Creating order summary")
    summary = calculate_summary(clean_orders)
    
    print("Writing CSV file")
    write_csv(clean_orders, output_csv)

    print("Writing summary")
    write_summary(summary, output_summary_txt)

    print("Completed")

if __name__ == "__main__":
    main()