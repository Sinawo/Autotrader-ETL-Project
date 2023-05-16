import requests
from bs4 import BeautifulSoup
import pandas as pd
import pyodbc
import json

# URL of the Autotrader website
base_url = "https://www.autotrader.co.za"

# User agent for the HTTP request headers
header = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36'
}

# Define table and column names
table_name = 'staging_table2'
column_names = ['Title', 'Price', 'Car Type', 'Registration Year', 'Mileage',\
                 'Transmission', 'Fuel Type', 'Dealership', 'Introduction date',\
                 '[End date]', 'Service interval distance', 'Engine position', \
                'Engine detail', 'Engine capacity (litre)', 'Cylinder layout and quantity',\
                 'Fuel capacity', 'Fuel consumption (average) **', 'Fuel range (average)',\
                'Power maximum (detail)', 'Torque maximum','Maximum/top speed', 'CO2 emissions (average)' \
                ,'Acceleration 0-100 km/h', \
                'Last Updated', 'Previous Owners', 'Service History', 'Colour', 'Body Type'
               
                
                
                ]




# define the connection details
server = 'canvas-graduates.database.windows.net'
database = 'graduatesDB'
username = 'graduates23'
password = 'CanGrad2023'
driver = '{ODBC Driver 17 for SQL Server}'

# create a connection
conn = pyodbc.connect(
                      f'SERVER={server};'
                      f'DATABASE={database};'
                      f'UID={username};'
                      f'PWD={password};'
                      f'DRIVER={driver};')

# create a cursor
cursor = conn.cursor()




# Check if the table already exists
if cursor.tables(table=table_name, tableType='TABLE').fetchone():
    print('Table already exists')
else:
    # Create the table with dynamic column names
    create_query = 'CREATE TABLE {0} ({1})'.format(table_name, ','.join(['[{0}] NVARCHAR(MAX)'.format(col) for col in column_names]))
    cursor.execute(create_query)
    cursor.commit()
    print('Table created')

# List to store the links for each car
car_links = []
all_cars_data = []
# List to store the details for each car
vehicle_details = []

# List to store the specifications for each car
specifications = []

# Function to convert a list to a dictionary
def Convert(lst):
    res_dct = {lst[i]: lst[i + 1] for i in range(0, len(lst), 2)}
    return res_dct

# Loop through each page of cars on the Autotrader website
for page in range(1):
    
    # Get the HTML content of the page
    response = requests.get(f"https://www.autotrader.co.za/cars-for-sale?pagenumber={page}")
    print(response.status_code)
    home_page = BeautifulSoup(response.content, 'lxml')
    
    # Find all the car listings on the page
    cars_containers = home_page.find_all('div', attrs={'class': 'e-featured-tile-container'})
    
    # Loop through each car listing
    for each_div in cars_containers:
        
        # Find the link to the car listing
        for link in each_div.find_all('a', href=True):
            found_link = (base_url + link['href'])
            
            # Get the HTML content of the car listing page
            r = requests.get(found_link, timeout=10)
            soup = BeautifulSoup(r.content, 'lxml')
            
            # Extract the basic details of the car
            title_element = soup.find('h1', class_='e-listing-title').text.strip()
            price = soup.find('div', attrs={'class': 'e-price'}).text.strip()
            icons = soup.find('ul', class_='b-icons m-large m-icon').find_all('li')
            car_type = icons[0].text.strip()
            if car_type == 'New Car': 
                mileage = '0'
                registration_year = icons[1].text.strip().split()[0]
                transmission = icons[2].text.strip()
                fuel_type = icons[3].text.strip()
            else:
                mileage = icons[2].text.strip().split()[0]

                registration_year = icons[1].text.strip().split()[0]
                transmission = icons[3].text.strip()
                fuel_type = icons[4].text.strip()
            dealer_name = soup.find('a', attrs={'class': 'e-dealer-link'} ).text
            
            # Create a dictionary to store the details of the car
            car_data = {
                'Title': title_element,
                'Price': price,
                'Car Type': car_type,
                'Registration Year': registration_year,
                'Mileage': mileage,
                'Transmission': transmission,
                'Fuel Type': fuel_type,
                'Dealership': dealer_name
            }
            
            # Find the engine details section of the car listing page
            engine_details = soup.find_all('span' , attrs={'class': 'col-6'})

            #the keys to use to appload data 
            keys = []
            values = []
            
            # Loop through each detail in the engine details section and add it to the dictionary
            i = 2
            for detail in (engine_details):
                if i % 2 == 0 and i <= 30:
                    
                    key = detail.text
                    keys.append(detail.text)
                else:
                    value = detail.text
                    values.append(detail.text)
                    car_data[key] = value
                i = i + 1
            
            # Print the details of the car

            vehicle_details = soup.find_all('div' , attrs={'class': 'col-6'})
            i = 2
            for detail in (vehicle_details):
                if i % 2 == 0 and i <= 12:
                    key = detail.text
                    keys.append(detail.text)
                else:
                    value = detail.text
                    values.append(detail.text)
                    car_data[key] = value
                i = i + 1

            
            # Print the details of the car
            
            column_names_to_add = list(car_data.keys())
            query_values = list(car_data.values())
            
            print(column_names_to_add)
            print(query_values)

            # Check if all keys exist in the column names
            valid_keys = [key for key in keys if key in column_names_to_add]

            # Construct the SQL query dynamically
            query = "INSERT INTO staging_table2 ({}) VALUES ({})".format(
                ', '.join('[' + key + ']' for key in column_names_to_add),
                ', '.join(['?'] * (len(column_names_to_add)))
)
            # Add any additional keys to a dictionary
            # extra_details = {}
            # for key in car_data.keys():
            #     if key not in column_names:
            #         extra_details[key] = car_data[key]

            # # Convert the extra details dictionary to JSON
            # extra_details_json = json.dumps(extra_details)

            # # Add the JSON string to the values list
            # values.append(extra_details_json)
           

            # print(keys)


            # Execute the query with the values as parameters
            cursor.execute(query, query_values)
            # Commit the changes
            # commit the changes
            conn.commit()

            # close the connection
            conn.close()
                        # Add the details of the car to the list of all car details
        