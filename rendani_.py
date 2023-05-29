#!/usr/bin/env python
# coding: utf-8

# In[5]:


import pandas as pd
import pyodbc
import re

# Connection details
server = 'canvas-graduates.database.windows.net'
database = 'graduatesDB'
username = 'graduates23'
password = 'CanGrad2023'
driver = '{ODBC Driver 17 for SQL Server}'

# Establish a connection to the database
conn = pyodbc.connect('DRIVER=' + driver + ';SERVER=' + server + ';DATABASE=' + database + ';UID=' + username + ';PWD=' + password)

# SQL query to select the table data
sql_query = 'SELECT * FROM Recent_dealers'

# Execute the SQL query and fetch the results into a Pandas DataFrame
df = pd.read_sql(sql_query, conn)

# Close the database connection
#conn.close()

# Save the DataFrame to a CSV file
#df.to_csv('Recent_dealers.csv', index=False)


# Read the CSV file into a pandas DataFrame
#df = pd.read_csv("Recent_dealers.csv")
# Car make list
car_makes = [
    "Abarth", "GoNow", "Meiya", "Rolls-Royce", "London", "STUDEBAKER", "Alfa Romeo", "Geely", "MG",
    "Changan", "AC", "Shelby", "Aston Martin", "GWM", "MINI", "Datsun", "Jinbei", "TESLA", "Audi",
    "Honda", "Nissan", "Mercedes-Maybach", "BAW", "Asia", "BMW", "Hyundai", "Noble", "Triumph",
    "Willys", "Nash", "Bentley", "Hummer", "Opel", "AMC Rambler", "Austin-Healey", "Caterham",
    "Cadillac", "Infiniti", "Peugeot", "Austin", "Ariel", "Millennium", "CAM", "Isuzu", "Porsche",
    "Buick", "BAIC", "GM", "Chana", "Iveco", "Proton", "DKW", "Oldsmobile", "Goggomobil", "Chevrolet",
    "Jaguar", "Renault", "Hillman", "Haval", "Middleton Roberts", "Chery", "Jeep", "Rover", "KCC",
    "JAC", "AMC", "Chrysler", "JMC", "Maxus", "Lynx", "Packard", "Rambler", "CMC", "Kia", "Saab",
    "MGA", "Puma", "Alvis", "Citroen", "Lamborghini", "SEAT", "MGB", "Secma", "Ineos", "Mitsubishi",
    "Lancia", "Smart", "Morris", "De Tomaso", "Delorean", "Dacia", "Lada", "SsangYong", "Pontiac",
    "Lola", "Lagonda", "Daewoo", "Land Rover", "Subaru", "Range Rover", "Leyland", "GSM", "Daihatsu",
    "L D V", "Suzuki", "Valiant", "GMC", "Holden", "Daimler", "Lexus", "Tata", "Vauxhall", "Jensen",
    "Harper", "DFSK", "Lotus", "Toyota", "Willys Jeep", "Plymouth", "Soyat", "Dodge", "Maserati",
    "TVR", "Morgan", "International", "DeSoto", "FAW", "Mahindra", "Volkswagen", "Birkin", "Mercury",
    "OMODA", "Ferrari", "Maybach", "Volvo", "Golden Journey", "DAF", "Hayden", "Fiat", "Mazda",
    "Zotye", "Sunbeam", "Pagani", "Foton", "Mercedes-Benz", "ZX Auto", "Backdraft", "Bajaj", "Ford",
    "Mercedes-AMG", "McLaren", "KTM", "HUMBER", "VW"
]

# Function to search for car make in the dealer name
def find_car_make(dealer):
    for car_make in car_makes:
        pattern = r'\b{}\b'.format(re.escape(car_make))
        if re.search(pattern, dealer, re.IGNORECASE):
            return car_make
    return None

# Apply the function to create a new column with the car make found
df["CarMake"] = df["dealer"].apply(find_car_make)

# Sort the DataFrame by the car make column
df.sort_values(by="CarMake", inplace=True)


# Establish a connection to the database
conn = pyodbc.connect('DRIVER=' + driver + ';SERVER=' + server +
                      ';PORT=1433;DATABASE=' + database +
                      ';UID=' + username + ';PWD=' + password)

# Create a cursor object to interact with the database
cursor = conn.cursor()
    
# Create the table if it doesn't exist
cursor.execute("""
    IF OBJECT_ID('dealers', 'U') IS NULL
    CREATE TABLE dealers (
        DealerName VARCHAR(100),
        CarMake VARCHAR(50)
    )
""")

# Iterate over the DataFrame rows and insert data into the table
for _, row in df.iterrows():
    dealer_name = row['dealer']
    car_make = row['CarMake']
    cursor.execute("INSERT INTO dealers (DealerName, CarMake) VALUES (?, ?)",
                   dealer_name, car_make)

# Commit the changes and close the connection
conn.commit()
conn.close()

# Print a success message
print("Data has been saved to the database table.")


# In[ ]:




