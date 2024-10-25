#!/usr/bin/env python
# coding: utf-8

import requests
from bs4 import BeautifulSoup
import random
import pyodbc
import re
import time
import datetime
import os
import math
from datetime import datetime
import subprocess
import sys
from git import Repo
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry
# URL of the Autotrader website
base_url = "https://www.autotrader.co.za"


# Define the number of retries and backoff factor
# retries = Retry(total=5, backoff_factor=0.5)

# # Create a session with retry mechanism
# session = requests.Session()
# session.mount("https://", HTTPAdapter(max_retries=retries))

# # Make the request with the session
# response = session.get(url)

MIN_YEAR = 1990


# Define table and column names
table_name = 'Autotrader_dataset'
column_names = ['[Car_ID]', '[Title]', '[Price]', '[Car Type]', '[Registration Year]', '[Mileage]',
                '[Transmission]', '[Fuel Type]', '[Dealership]','[Suburb]', '[Introduction date]',
                '[End date]', '[Engine position]', '[Engine detail]', '[Engine capacity (litre)]',
                '[Cylinder layout and quantity]', '[Fuel capacity]', '[Fuel consumption (average) **]',
                '[Fuel range (average)]', '[Power maximum (detail)]', '[Torque maximum]',
                '[Maximum/top speed]', '[CO2 emissions (average)]', '[Acceleration 0-100 km/h]',
                '[Last Updated]', '[Previous Owners]', '[Service History]', '[Colour]', '[Body Type]',  'latest_version', 'Time_stamp', 'First_Entry_Timestamp']

column_n = ['Car_ID','Title', 'Price', 'Car Type', 'Body Type','Registration Year', 'Mileage', 'Transmission',
                'Fuel Type', 'Dealership', 'Introduction date', 'End date','Suburb',
                'Engine position', 'Engine detail', 'Engine capacity (litre)', 'Cylinder layout and quantity',
                'Fuel capacity', 'Fuel consumption (average) **', 'Fuel range (average)',
                'Power maximum (detail)', 'Torque maximum', 'Maximum/top speed', 'CO2 emissions (average)',
                'Acceleration 0-100 km/h', 'Last Updated', 'Previous Owners', 'Service History', 'Colour', 'latest_version', 'Time_stamp','First_Entry_Timestamp']


# define the connection details
server = 'web-development.database.windows.net'
database = 'graduates'
username = 'Canvas'
password = 'Dut950505'
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

# Combine column names with data types
column_data_types = ['VARCHAR(MAX)'] * len(column_names)

column_data_types[column_names.index('latest_version')] = 'INT DEFAULT 1'


# Construct the CREATE TABLE query

create_table_query = f"IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = '{table_name}') \
                       CREATE TABLE {table_name} ({', '.join(['{0} {1}'.format(name, data_type) for name, data_type in zip(column_names, column_data_types)])})"
# Execute the CREATE TABLE query
cursor.execute(create_table_query)
# Commit the changes 
conn.commit()

# List to store the links for each car
car_links = []
cars_data = []

# List to store the details for each car
vehicle_details = []

# List to store the specifications for each car
specifications = []

# Function to get the last scraped page and year
def get_last_scraped_page_and_year():
     # Check if the table exists
    table_exists_query = "SELECT 1 FROM sys.tables WHERE name = 'page_tracker'"
    cursor.execute(table_exists_query)
    result = cursor.fetchone()
   
    

    if result is not None:
        
        cursor.execute("SELECT last_year FROM page_tracker")
        reg_year =  cursor.fetchone()[0]
        query = f"SELECT COUNT(*) FROM {table_name} WHERE [Registration Year] = ?"
        cursor.execute(query, reg_year)
        total_count = cursor.fetchone()[0]
        listings_per_page = 20
        last_page = math.ceil(total_count / listings_per_page)
        # Table exists, fetch the last scraped page and year from the table
        cursor.execute("SELECT last_page, last_year FROM page_tracker")
        
        return last_page, cursor.fetchone()[1] 
            
    else:
            # Table doesn't exist, create a new table and start from page 1 and the current year
            create_table_query = '''
                CREATE TABLE page_tracker (
                    last_page INT,
                    last_year INT
                )
            '''
            cursor.execute(create_table_query)
            last_page = 1
            last_year = datetime.now().year
            
            # Insert the initial values into the table
            insert_query = 'INSERT INTO page_tracker (last_page, last_year) VALUES (?, ?)'
            cursor.execute(insert_query, (last_page, last_year))
            cursor.execute("SELECT last_page, last_year FROM page_tracker")
            
            result = cursor.fetchone() 
            conn.commit()
            return result[0], result[1]

            # Commit the changes to the database
            
# Function to update the last scraped page and year
def update_last_scraped_page_and_year(page, year):
    # Update the last scraped page and year in the database
    update_query = 'UPDATE page_tracker SET last_page = ?, last_year = ?'
    cursor.execute(update_query, (page, year))
    conn.commit()

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
                    # Add 'Time_stamp' and 'Latest' columns to the dictionary
  
    return car_data
# Function to get the last page for a specific year
def get_last_page(year):
    response = requests.get(f"https://www.autotrader.co.za/cars-for-sale?year={year}-to-{year}", timeout=5)
        
    home_page = BeautifulSoup(response.content, 'lxml')
   
    total_listings_element = home_page.find('span', class_='e-results-total')
    total_listings = int(total_listings_element.text.replace(' ', ''))
    
    # Determine the number of pages based on the number of listings per page (e.g., 24 listings per page)
    listings_per_page = 20
    last_page = math.ceil(total_listings / listings_per_page)
    
    return last_page


# Set the desired execution time to one hour (3600 seconds)

execution_time = time.time() + 3600


# Starting page number and year
start_page, start_year = get_last_scraped_page_and_year()
year = start_year
#last page for all total listings for a specific year 
end_page = get_last_page(year)


# Loop through each page of cars on the Autotrader website
#for page in range(num_iterations):
for page in range(start_page, end_page + 1):

    response = requests.get(f"https://www.autotrader.co.za/cars-for-sale?pagenumber={page}&sortorder=PriceLow&year={year}-to-{year}&priceoption=RetailPrice", timeout=5)
    
    # If you have finished scraping all pages for a specific year, 
    # move to the next year and reset the last scraped page to 1
    if page == end_page:
        page = 1
        year -= 1
        update_last_scraped_page_and_year(page, year)  # Reset to the first page
    if year <= MIN_YEAR and page > end_page: 
        sys.exit("Reached scraped the whole website")  
        


   
    home_page = BeautifulSoup(response.content, 'lxml')
    
    
    # Find all the car listings on the page 
    cars_containers = home_page.find_all('div', attrs={'class': re.compile(r'b-result-tile .*')})
    # Loop through each car listing

    for each_div in cars_containers:
        # Find the link to the car listing   
        for link in each_div.find_all('a', href=True):
            if time.time() >= execution_time: 
                update_last_scraped_page_and_year(page, year) 
                execution_time += 3600
                time.sleep(120)
                
            try:
                found_link = (base_url + link['href'])
                # Extract the car ID using regular expression
                Car_ID = re.search(r'/(\d+)\?', found_link).group(1)
               
            except:
                 continue

            # Get the HTML content of the car listing page
            res = requests.get(found_link, timeout=5)
            soup = BeautifulSoup(res.content, 'lxml')
            
            ul_tag = soup.find('ul', class_='b-breadcrumbs')

            if ul_tag:
                # Find the <a> tag within the <li> tag at position 3
                a_tag = ul_tag.find_all('li')[2].find('a')

                if a_tag:
                    # Extract the text within the <a> tag
                    location = a_tag.get_text(strip=True)                   
                else:
                   pass
            
            try: 
                title_element = soup.find('h1', class_='e-listing-title').text.strip()
                dealer_name = soup.find('a', attrs={'class': 'e-dealer-link'} ).text
            except:
                 continue
            price = soup.find('div', attrs={'class': 'e-price'}).text.strip()
            icons = soup.find('ul', class_='b-icons m-large m-icon').find_all('li')
            
            car_type = icons[0].text.strip()
            if car_type == 'New Car': 
                mileage = '0'
                registration_year = icons[1].text.strip().split()[0]
                transmission = icons[2].text.strip()
                fuel_type = icons[3].text.strip()
            elif car_type == "Certified":
                car_type = icons[1].text.strip()
                mileage = icons[4].text.strip()
                registration_year = icons[2].text.strip().split()[0]
                transmission = icons[3].text.strip()
                fuel_type = icons[5].text.strip()

            else:
                mileage = icons[2].text.strip()

                registration_year = icons[1].text.strip().split()[0]
                transmission = icons[3].text.strip()
                fuel_type = icons[4].text.strip()
            
            
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
            
            car_data['Car_ID'] = Car_ID
            car_data['Suburb'] = location
            car_data['Time_stamp'] = str(datetime.now())
            
            

            # Check if the Car_ID exists
            check_query = f"SELECT latest_version FROM {table_name} WHERE Car_ID = ?"
            cursor.execute(check_query, (Car_ID))
            result = cursor.fetchone()
        
            if result is not None:
                  # If Car_ID exists, increment the Latest value
                cursor.execute(f"UPDATE {table_name} SET Latest_version =  Latest_version + 1 \
                               WHERE Car_ID = ? ", Car_ID)   
            else:
               
                # If Car_ID doesn't exist, set the Latest value to 1
                cursor.execute(f"UPDATE {table_name} SET Latest_version = 1\
                               WHERE Car_ID = ? ", Car_ID)
                
            # Check if the Car_ID exists
            check_query = f"SELECT First_Entry_Timestamp FROM {table_name} WHERE Car_ID = ?"
            cursor.execute(check_query, (Car_ID))
            result = cursor.fetchone()
            if result is not None and result[0] is not None:
                # Car_ID exists, do not modify 'First_Entry_Timestamp'
                pass
            else:
                # Car_ID does not exist, add current timestamp to 'First_Entry_Timestamp'
                car_data['First_Entry_Timestamp'] = car_data['Time_stamp']
          

                           

            # Check if all values in car_data have corresponding column names [the one we want only]
            matching_keys = [key for key in car_data.keys() if key in column_n]
         
            # Get the corresponding values for the matching keys
            matching_values = [car_data[key] for key in matching_keys]

            placeholders = ', '.join(['?'] * len(matching_keys))
            column_names_with_brackets = ', '.join('"' + key + '"'  for key in matching_keys)
           
            if result:
                update_query = f"""
                    UPDATE {table_name}
                    SET {', '.join([f'"{key}" = ?' for key in matching_keys])}
                    WHERE Car_ID = ?;
                """
                matching_values.append(Car_ID)  # Append Car_ID for the WHERE clause
                cursor.execute(update_query, matching_values)
            else:
                # If Car_ID doesn't exist, set the Latest value to 1
                insert_query = f"""
                    INSERT INTO {table_name} (
                        {column_names_with_brackets}
                    )
                    VALUES (
                        {placeholders}
                    );
                """
                cursor.execute(insert_query, matching_values)
            
            conn.commit()


          
conn.close()    
