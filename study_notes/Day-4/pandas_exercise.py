import pandas as pd 

# create a DataFrame manually
#important:all lists should have the same length
# dictionary keys become the column names
#lists become the column values

data = {
    'Days': ['Mon', 'Tues', 'Wed'], 
    'Date': [2,3,4]
    }

df=pd.DataFrame(data)
print(df)

#SERIES: A Series is essentially a labeled list
ages = pd.Series([22, 25, 31])
print(ages)

ages = pd.Series(
    [22, 25, 31],
    index=["Alice", "Bob", "Charlie"]
)

print(ages)

#read excel
df_excel = pd.read_excel("/filepath/file_name.xlsx")
print(df_excel.head())


#Reading a specific sheet
#if an Excel file has multiple sheets, we can specify which one to load:
excel_df = pd.read_excel(
    "/filepath/file_name.xlsx",
    sheet_name="COCA COLA CO"
)

'''To get the sheet names -> 
excel_file = pd.ExcelFile("/filepath/file_name.xlsx")
print(excel_file.sheet_names)
'''

#read csv
df_csv = pd.read_csv("/filepath/nba.csv")
print(df_csv.head())
print(df_csv.info())
