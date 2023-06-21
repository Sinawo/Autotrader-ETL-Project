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
import csv 
from pathlib import Path
# URL of the Autotrader website
base_url = "https://www.autotrader.co.za"

MIN_YEAR = 1990
csv_file_path = 'scraped_data.csv'
# Define table and column names
table_name = 'Autotrader_dataset'
column_names = ['[Car_ID]', '[Title]', '[Price]', '[Car Type]', '[Registration Year]', '[Mileage]',
                '[Transmission]', '[Fuel Type]', '[Dealership]','[Suburb]', '[Introduction date]',
                '[End date]', '[Engine position]', '[Engine detail]', '[Engine capacity (litre)]',
                '[Cylinder layout and quantity]', '[Fuel capacity]', '[Fuel consumption (average) **]',
                '[Fuel range (average)]', '[Power maximum (detail)]', '[Torque maximum]',
                '[Maximum/top speed]', '[CO2 emissions (average)]', '[Acceleration 0-100 km/h]',
                '[Last Updated]', '[Previous Owners]', '[Service History]', '[Colour]', '[Body Type]', 'First_Entry_Timestamp',  'latest_version', 'Time_stamp']

column_n = ['Car_ID','Title', 'Price', 'Car Type', 'Body Type','Registration Year', 'Mileage', 'Transmission',
                'Fuel Type', 'Dealership', 'Introduction date', 'End date','Suburb',
                'Engine position', 'Engine detail', 'Engine capacity (litre)', 'Cylinder layout and quantity',
                'Fuel capacity', 'Fuel consumption (average) **', 'Fuel range (average)',
                'Power maximum (detail)', 'Torque maximum', 'Maximum/top speed', 'CO2 emissions (average)',
                'Acceleration 0-100 km/h', 'Last Updated', 'Previous Owners', 'Service History', 'Colour','First_Entry_Timestamp' 'latest_version', 'Time_stamp']

# List to store the links for each car
car_links = []
cars_data = []

# List to store the details for each car
vehicle_details = []

# List to store the specifications for each car
specifications = []

# Function to get the last scraped page and year
def get_last_scraped_page_and_year():
    if os.path.exists("last_page.txt"):
        with open("last_page.txt", "r") as file:
            last_page, last_year = map(int, file.read().split(','))
            return last_page, last_year
    else:
        return 1, datetime.datetime.now().year  # Default values if the file doesn't exist


# Function to update the last scraped page and year
def update_last_scraped_page_and_year(page, year):
    with open("last_page.txt", "w") as file:
        file.write(f"{page},{year}")

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
    response = requests.get(f"https://www.autotrader.co.za/cars-for-sale?year={year}-to-{year}")
    print('Trying to get last page: ', response.status_code)  
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
last_page = get_last_page(year)
# Loop through each page of cars on the Autotrader website
#for page in range(num_iterations):
for page in range(start_page, last_page + 1):

    response = requests.get(f"https://www.autotrader.co.za/cars-for-sale?pagenumber={page}&sortorder=PriceLow&year={year}-to-{year}&priceoption=RetailPrice")
    
    # If you have finished scraping all pages for a specific year, 
    # move to the next year and reset the last scraped page to 1
    if page == last_page:
        page = 1
        year -= 1
        update_last_scraped_page_and_year(page, year)  # Reset to the first page

    print(response.status_code)
    home_page = BeautifulSoup(response.content, 'lxml')
    
    
    # Find all the car listings on the page 
    cars_containers = home_page.find_all('div', attrs={'class': re.compile(r'b-result-tile .*')})
    # Loop through each car listing

    for each_div in cars_containers:
        # Find the link to the car listing   
        for link in each_div.find_all('a', href=True):
            if time.time() >= execution_time: 
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
                'Car_ID': Car_ID,
                'Title': title_element,
                'Price': price,
                'Car Type': car_type,
                'Registration Year': registration_year,
                'Mileage': mileage,
                'Transmission': transmission,
                'Fuel Type': fuel_type,
                'Dealership': dealer_name,
                'Suburb' : location
            }
            
            # Find the engine details section of the car listing page
            engine_details = soup.find_all('span' , attrs={'class': 'col-6'})
            vehicle_details = soup.find_all('div' , attrs={'class': 'col-6'})

            car_data = Add_Key_Values(engine_details, car_data)
            car_data = Add_Key_Values(vehicle_details, car_data)
            
            
            
            # car_data['Time_stamp'] = str(datetime.datetime.now())

            # Check if all values in car_data have corresponding column names [the one we want only]
            matching_keys = [key for key in car_data.keys() if key in column_n]
         
            # Get the corresponding values for the matching keys
            matching_values = [car_data[key] for key in matching_keys]

            placeholders = ', '.join(['?'] * len(matching_keys))
            column_names_with_brackets = ', '.join('"' + key + '"'  for key in matching_keys)

            # Check if the CSV file exists or not
            csv_file_exists = Path(csv_file_path).is_file()
            # Write the data to the CSV file
            
            with open(csv_file_path, 'a', newline='') as file:
                writer = csv.writer(file)
                # Write the header row if the CSV file doesn't exist
                if not csv_file_exists:
                    writer.writerow(column_names)
                # Write the data row
                writer.writerow(matching_values)
           
             


          
