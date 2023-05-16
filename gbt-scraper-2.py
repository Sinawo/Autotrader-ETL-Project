import requests
from bs4 import BeautifulSoup
import pandas as pd
import pyodbc
import json
import re
import sqlite3

# URL of the Autotrader website
base_url = "https://www.autotrader.co.za"


# Define table and column names
table_name = 'staging_table2'
column_names = ['[Title]', '[Price]', '[Car Type]', '[Registration Year]', '[Mileage]',
                '[Transmission]', '[Fuel Type]', '[Dealership]', '[Introduction date]',
                '[End date]', '[Engine position]', '[Engine detail]', '[Engine capacity (litre)]',
                '[Cylinder layout and quantity]', '[Fuel capacity]', '[Fuel consumption (average) **]',
                '[Fuel range (average)]', '[Power maximum (detail)]', '[Torque maximum]',
                '[Maximum/top speed]', '[CO2 emissions (average)]', '[Acceleration 0-100 km/h]',
                '[Last Updated]', '[Previous Owners]', '[Service History]', '[Colour]', '[Body Type]']

column_n = ['Title', 'Price', 'Car Type', 'Registration Year', 'Mileage', 'Transmission',
                'Fuel Type', 'Dealership', 'Introduction date', '[End date]',
                'Engine position', 'Engine detail', 'Engine capacity (litre)', 'Cylinder layout and quantity',
                'Fuel capacity', 'Fuel consumption (average) **', 'Fuel range (average)',
                'Power maximum (detail)', 'Torque maximum', 'Maximum/top speed', 'CO2 emissions (average)',
                'Acceleration 0-100 km/h', 'Last Updated', 'Previous Owners', 'Service History', 'Colour', 'Body Type']

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
# Construct the CREATE TABLE query
columns = ', '.join(column_names)  # Join the column names

create_table_query = f"CREATE TABLE IF NOT EXISTS {table_name} (Car_ID INTEGER PRIMARY KEY, {columns})"



# Execute the CREATE TABLE query
cursor.execute(create_table_query)

# Commit the changes and close the connection
# conn.commit()

# List to store the links for each car
car_links = []
cars_data = []

# List to store the details for each car
vehicle_details = []

# List to store the specifications for each car
specifications = []

# Function to convert a list to a dictionary
def Convert(lst):
    res_dct = {lst[i]: lst[i + 1] for i in range(0, len(lst), 2)}
    return res_dct

def Add_Key_Values(list, dictionary):
    #the keys to use to appload data 
    keys = []
    values = []           
    i = 2
    for detail in (list):
                if i % 2 == 0:
                    key = detail.text
                    keys.append(detail.text)
                else:
                    value = detail.text
                    values.append(detail.text)
                    car_data[key] = value
                i = i + 1
    return car_data

# Loop through each page of cars on the Autotrader website
for page in range(1):
    
    # Get the HTML content of the page
    response = requests.get(f"https://www.autotrader.co.za/cars-for-sale?pagenumber={page}")
    print(response.status_code)
    home_page = BeautifulSoup(response.content, 'lxml')
    # Extract the car ID using regular expression
    
    # Find all the car listings on the page
    cars_containers = home_page.find_all('div', attrs={'class': 'e-featured-tile-container'})
    
    # Loop through each car listing
    for each_div in cars_containers:
        
        # Find the link to the car listing
        for link in each_div.find_all('a', href=True):
            found_link = (base_url + link['href'])
            Car_ID = re.search(r'/(\d+)\?', found_link).group(1)
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
                mileage = icons[2].text.strip()[0]

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
            vehicle_details = soup.find_all('div' , attrs={'class': 'col-6'})

            car_data = Add_Key_Values(engine_details, car_data)
            car_data = Add_Key_Values(vehicle_details, car_data)
           
            
            # Check if all values in car_data have corresponding column names
            matching_keys = [key for key in car_data.keys() if key in column_n]

            # Get the corresponding values for the matching keys
            matching_values = [car_data[key] for key in matching_keys]
           

            # Construct the INSERT query
            placeholders = ', '.join(['?'] * len(matching_keys))
            insert_query = f"""INSERT OR IGNORE INTO {table_name} ("Car ID", {', '.join('"' + key + '"' for key in matching_keys)}) VALUES (?, {placeholders})"""
            matching_values.insert(0, Car_ID)


            insert_query = f"""INSERT INSERT OR IGNORE INTO {table_name} ({', '.join('"' + key + '"' for key in matching_keys)}) VALUES ({placeholders})"""

            # Execute the INSERT query with the matching values
            cursor.execute(insert_query, matching_values)
                        
            # Print the details of the car            
            
            conn.commit()

            # close the connection
            conn.close()
        