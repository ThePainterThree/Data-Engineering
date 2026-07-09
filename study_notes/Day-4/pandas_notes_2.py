import pandas as pd 

'''pandas part 2'''
df_csv = pd.read_csv("file.csv")

#17 Applying functions
#Apply a function to a column
df_csv["age_category"] = df_csv["age"].apply(
    lambda x: "adult" if x >= 18 else "minor"
)


#18 Dates and times
#Convert column to datetime
df_csv["date"] = pd.to_datetime(df_csv["date"])

#Extract year
df_csv["year"] = df_csv["date"].dt.year

#Extract month
df_csv["month"] = df_csv["date"].dt.month

#Filter by date
df_csv[df_csv["date"] > "2024-01-01"]


#19 Combining DataFrames
# stack rows
#assuning we have two CVS files:
df1 = pd.read_csv("file_name_1.csv")
df2 = pd.read_csv("file_name_2.csv")

combined = pd.concat([df1, df2])

#Join like SQL
merged = pd.merge(df1, df2, on="id")

#left join
merged = pd.merge(df1, df2, on="id", how="left")


#20 Pivot tables
#Create summary tables
pivot = df_csv.pivot_table(
    values="sales",
    index="city",
    columns="month",
    aggfunc="sum"
)

#21 Exporting data
#Save to CSV:
df_csv.to_csv("cleaned_data.csv", index=False)

#save to excel 
df_csv.to_excel("cleaned_data.xlsx", index=False)


#22. Common pandas workflow

'''1-Load data'''
df = pd.read_csv("file.csv")

'''2 inspect data'''
#check the first rows. why? 
#verifies the file loaded correctly
#shows column names
#gives a quick idea of the data
df.head()

#Shows the structure of the DataFrame. why?
#It tells you:
# number of rows
# number of columns
# data types
# missing values
# memory usage
df.info()

#Produces statistics for numeric columns. why is this important?
#Useful for finding:
# unusually large values
# negative values
# spread of the data
# averages
df.describe()

'''3- clean data'''
#Removes every row containing at least one missing value
# dropna() returns a new DataFrame, either replaces the old or create a new
# better practice to keep the original data available, like this:
#when to use? 
clean_df = df.dropna()
#fills with zeros instead of dropping rows with missing values
clean_zero = df.fillna(0)
#df.dropna(inplace=True) -> changes the df without creating a new one.

#transforms all data into lowercase for uniformisation
df.columns = df.columns.str.lower()

'''4- filter data'''
# this ecxample keeps only rows where sales are greater than 100
#the original DataFrame (df) is unchanged
# creates a new DataFrame called df_filtered
df_filtered = df[df["sales"] > 100]

'''5 - analyze data'''
#explanation step by step:
#4.1 groupby("region") -> groups together all rows with the same region
#4.2 ["sales"] -> within each group, only look at the sales column (like a russian doll)
#4.3 .sum() -> adds/sums up the values in each group. basically, group by Region and Sum the Sales
# step 4.3 works with other aggregation functions like: .mean , .max, .min, .count
# also a bit more complex, all at one go:
# df.groupby("region")["sales"].agg(["sum", "mean", "max", "count"])
df_filtered.groupby("region")["sales"].sum()

'''6 - export data'''
#Saves the DataFrame as a CSV file. why index=FAlse ?
# use index=False because the index is an internal pandas label rather than part of your data
df_filtered.to_csv("result.csv", index=False)

#"Show", "Find", "Filter", use boolean indexing:
df[df["Column"] == "str_value"]

# "Average", "Count", "Sum", "Maximum by group", use groupby().
df[df["Column"] == "string_value"]
#if other data type, like int, remove quotes