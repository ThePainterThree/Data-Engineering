import pandas as pd 

#What is pandas
#1
'''pandas is a Python library for working with tabular data, like Excel inside Python.'''
'''Main uses:
Load data
Clean data
Filter data
Analyze data
Summarize data
Export data
print(pd.__version__)'''


#2. Core pandas objects
'''pandas has two main data structures: Series and DataFrames'''
'''Series is one column of data.'''
ages = pd.Series([22, 25, 30])

'''DataFrame is a full table. It has rows and columns.'''
df = pd.DataFrame({
    "name": ["Alice", "Bob", "Charlie"],
    "age": [22, 25, 30],
    "city": ["Paris", "Berlin", "Rome"]
})
# | Series                             | DataFrame                                  |
# | ---------------------------------- | ------------------------------------------ |
# | One-dimensional                    | Two-dimensional                            |
# | Like a single column in Excel      | Like an entire Excel spreadsheet           |
# | Has one index                      | Has rows and columns                       |
# | Can hold one data type (typically) | Each column can have a different data type |


#3. Reading CSV files
df_csv = pd.read_csv("file.csv")
#preview first rows
df_csv.head()
#preview last rows
df_csv.tail()

#4 Understanding your data

#Check shape -> checks the number of rows and columns
df_csv.shape

#chcek column names 
df_csv.columns

#get general info
df_csv.info()

#numeric summary
df_csv.describe()


#5 Selecting columns
# Select 1 column
df_csv["column_name"]

#Select multiple columns
df_csv[["column1", "column2"]]


#6 Selecting rows
#Select rows by position
df_csv.iloc[0]

#Select first five rows
df_csv.iloc[0:5]

#Select rows by label/index
df_csv.loc[0]

#7 Filtering data
# Filter rows with a condition
df_csv[df_csv["age"] > 25]

#Multiple conditions
df_csv[(df_csv["age"] > 25) & (df_csv["city"] == "Berlin")]

#Use | for OR
df_csv[(df_csv["city"] == "Berlin") | (df_csv["city"] == "Paris")]


#8 Sorting data
#Sort ascending
df_csv.sort_values("age")

#Sort descending
df_csv.sort_values("age", ascending=False)

#sort by multiple colums
df_csv.sort_values(["city", "age"])

#9 Adding new columns
#Create a new column
df_csv["age_plus_10"] = df_csv["age"] + 10

'''step by step explanation:'''

''' df_csv["age"]'''            #-> returns a Series (column) names "age"

'''df_csv["age"] + 10 '''       # -> adding +10
                                # -> pandas performs vectorized addition, 
                                # meaning it adds 10 to every value in the Series

# | name  | age | age_plus_10 |
# | ----- | --: | ----------: |
# | Alice |  20 |          30 |
# | Bob   |  35 |          45 |
# | Carol |  42 |          52 |


#Create a column using logic
df_csv["is_adult"] = df_csv["age"] >= 18


#10 Renaming columns
df_csv = df_csv.rename(columns={
    "old_name": "new_name"
})


#11 Dropping columns or rows
#Deletes the entire column!! CAREFUL ****
df_csv = df_csv.drop(columns=["column_name"])

#Drops only missing rows with missing values
df_csv = df.dropna(subset=["column_name"])

#Drops entire row by index
df_csv = df_csv.drop(index=0)

#delete duplicates
df = df.drop_duplicates()


#12 Missing values - not applicatble & null
#Check missing values
df_csv.isna().sum()
df_csv.isnull().sum()

#Drop rows with missing values
df_csv.isna().sum()

#Fill missing values
df_csv["age"] = df_csv["age"].fillna(0)

#Fill with avg
df_csv["age"] = df_csv["age"].fillna(df_csv["age"].mean())


#13 Changing data types
#Convert to integer
df_csv["age"] = df_csv["age"].astype(int)

#Convert to float
df_csv["price"] = df_csv["price"].astype(float)

#or to string
df_csv["name"] = df_csv["name"].astype(str)

'''check after the data type, if it all worked as expected'''
df["column_name"].dtype

#14 Working with strings
#Lowercase
df_csv["name"] = df_csv["name"].str.lower()

#uupercase
df_csv["name"] = df_csv["name"].str.upper()

#Check if text contains something
df_csv[df_csv["name"].str.contains("something")]

#Remove extra spaces
df_csv["name"] = df_csv["name"].str.strip()


#15 Grouping data
#Group by one column
df_csv.groupby("city")["age"].mean()

# count rows per group
df_csv.groupby("city").size()

# Multiple aggregations 
df_csv.groupby("city")["age"].agg(["mean", "min", "max"])


#16 value counts
#get percentages
df_csv["city"].value_counts(normalize=True)