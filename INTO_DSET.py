#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import pyodbc
import csv
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin
from concurrent.futures import ThreadPoolExecutor

base_url = "https://www.autotrader.co.za/cars-for-sale?sortorder=Newest&year=2023-to-2023&priceoption=RetailPrice"


# Connection details
server = 'canvas-graduates.database.windows.net'
database = 'graduatesDB'
username = 'graduates23'
password = 'CanGrad2023'
driver = '{ODBC Driver 17 for SQL Server}'

# Table name and column names
table_name = 'CarListings'
column_names = ['Title', 'Price', 'ExpectedPaymentPerMonth', 'NewOld', 'RegistrationYear', 'Transmission',
                'BodyType', 'Rating', 'FuelType', 'LastUpdated', 'ManufacturersColour', 'IntroductionDate',
                'ServiceIntervalDistance', 'EnginePosition', 'EngineDetail', 'EngineCapacity',
                'CylinderLayoutAndQuantity', 'FuelCapacity', 'FuelConsumptionAverage', 'FuelRangeAverage',
                'PowerMaximumDetail', 'TorqueMaximum', 'Acceleration0100kmh', 'MaximumTopSpeed',
                'CO2EmissionsAverage']

# Create the tablepython 
def create_table():
    conn_str = f"DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password}"
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()

    # Drop the table if it already exists
    cursor.execute(f"IF OBJECT_ID('{table_name}', 'U') IS NOT NULL DROP TABLE {table_name}")

    # Create the table
    create_table_query = f"""
        CREATE TABLE {table_name} (
            ID INT IDENTITY(1,1) PRIMARY KEY,
            {', '.join([f'{column} NVARCHAR(MAX)' for column in column_names])}
        )
    """
    cursor.execute(create_table_query)
    conn.commit()
    print("Table created successfully!")

# Insert data into the table
def insert_data_into_table(data):
    conn_str = f"DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password}"
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()

    insert_query = f"""
        INSERT INTO {table_name} ({', '.join(column_names)})
        VALUES ({', '.join(['?' for _ in column_names])})
    """
    cursor.execute(insert_query, tuple(data.values()))
    conn.commit()

# Extract car data
def extract_car_data(tile):
    car_url = tile.find('a', class_='b-featured-result-tile')['href']
    car_url = urljoin(url, car_url)  # Make the URL absolute
    car_response = requests.get(car_url)
    car_soup = BeautifulSoup(car_response.content, 'html.parser')

    # Extract the data from the car page
    title = car_soup.find('h1', class_='e-listing-title').text.strip() if car_soup.find('h1', class_='e-listing-title') else "N/A"
    price = car_soup.find('div', class_='e-price').text.strip() if car_soup.find('div', class_='e-price') else "N/A"
    expected_payment = car_soup.find('a', class_='e-calculator-link').text.strip() if car_soup.find('a', class_='e-calculator-link') else "N/A"
    new_old = car_soup.find('li', class_='e-summary-icon m-type').text.strip() if car_soup.find('li', class_='e-summary-icon m-type') else "N/A"
    registration_year = car_soup.find('li', title='Registration Year').text.strip() if car_soup.find('li', title='Registration Year') else "N/A"
    transmission = car_soup.find('li', title='Transmission').text.strip() if car_soup.find('li', title='Transmission') else "N/A"
    body_type = car_soup.find(text='Body Type').find_next('div').text.strip() if car_soup.find(text='Body Type') else "N/A"
    
    rating = car_soup.find('span', class_='b-price-rating').text.strip() if car_soup.find('span', class_='b-price-rating') else "N/A"
    fuel_type = car_soup.find('li', title='Fuel Type').text.strip() if car_soup.find('li', title='Fuel Type') else "N/A"
    last_updated = car_soup.find(text='Last Updated').find_next('div').text.strip() if car_soup.find(text='Last Updated') else "N/A"
    manufacturers_colour = car_soup.find(text='Manufacturers Colour').find_next('div').text.strip() if car_soup.find(text='Manufacturers Colour') else "N/A"
    introduction_date = car_soup.find(text='Introduction date').find_next('div').text.strip() if car_soup.find(text='Introduction date') else "N/A"
    service_interval_distance = car_soup.find(text='Service interval distance').find_next('div').text.strip() if car_soup.find(text='Service interval distance') else "N/A"
    engine_position = car_soup.find(text='Engine position').find_next('div').text.strip() if car_soup.find(text='Engine position') else "N/A"
    engine_detail = car_soup.find(text='Engine detail').find_next('div').text.strip() if car_soup.find(text='Engine detail') else "N/A"
    engine_capacity = car_soup.find(text='Engine capacity (litre)').find_next('div').text.strip() if car_soup.find(text='Engine capacity (litre)') else "N/A"
    cylinder_layout = car_soup.find(text='Cylinder layout and quantity').find_next('div').text.strip() if car_soup.find(text='Cylinder layout and quantity') else "N/A"
    fuel_capacity = car_soup.find(text='Fuel capacity').find_next('div').text.strip() if car_soup.find(text='Fuel capacity') else "N/A"
    fuel_consumption = car_soup.find(text='Fuel consumption (average)').find_next('div').text.strip() if car_soup.find(text='Fuel consumption (average)') else "N/A"
    fuel_range = car_soup.find(text='Fuel range (average)').find_next('div').text.strip() if car_soup.find(text='Fuel range (average)') else "N/A"
    power_maximum = car_soup.find(text='Power maximum (detail)').find_next('div').text.strip() if car_soup.find(text='Power maximum (detail)') else "N/A"
    torque_maximum = car_soup.find(text='Torque maximum').find_next('div').text.strip() if car_soup.find(text='Torque maximum') else "N/A"
    acceleration = car_soup.find(text='Acceleration 0-100 km/h').find_next('div').text.strip() if car_soup.find(text='Acceleration 0-100 km/h') else "N/A"
    maximum_speed = car_soup.find(text='Maximum/top speed').find_next('div').text.strip() if car_soup.find(text='Maximum/top speed') else "N/A"
    co2_emissions = car_soup.find(text='CO2 emissions (average)').find_next('div').text.strip() if car_soup.find(text='CO2 emissions (average)') else "N/A"

  # ... Extract the remaining data fields ...

    return {
        'Title': title,
        'Price': price,
        'ExpectedPaymentPerMonth': expected_payment,
        'NewOld': new_old,
        'RegistrationYear': registration_year,
        'Transmission': transmission,
        'BodyType': body_type,
        'Body Type': body_type,
        'Rating': rating,
        'Fuel_Type': fuel_type,
        'Last_Updated': last_updated,
        'Manufacturers_Colour': manufacturers_colour,
        'Introduction_Date': introduction_date,
        'Engine_Position': service_interval_distance,
        'Engine_Detail': engine_position,
        'Engine_Capacity': engine_detail,
        'Cylinder Layout and Quantity': engine_capacity,
        'Fuel Capacity': cylinder_layout,
        'Fuel Consumption (Average)': fuel_capacity,
        'Fuel Range (Average)': fuel_consumption,
        'Power Maximum (Detail)': fuel_range,
        'Torque Maximum': power_maximum,
        'Acceleration 0-100 km/h': torque_maximum,
        'Maximum/Top Speed': acceleration,
        'CO2 Emissions (Average)': maximum_speed,
        'CO2 Emissions (Average)': co2_emissions
    
        # ... Include the remaining column names and corresponding values ...
    }

# Main code
create_table()

page_number = 1
while True:
    url = base_url.format(page_number)
    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')
    listing_tiles = soup.find_all('div', class_='e-featured-tile-container')

    if not listing_tiles:
        break  # No more listings on this page, exit the loop

    with ThreadPoolExecutor() as executor:
        futures = []
        for tile in listing_tiles:
            future = executor.submit(extract_car_data, tile)
            futures.append(future)

        for future in futures:
            car_data = future.result()
            insert_data_into_table(car_data)

    page_number += 1

print("Car listings extracted and saved to the database!")


# In[ ]:


import pyodbc

# Connection details
server = 'canvas-graduates.database.windows.net'
database = 'graduatesDB'
username = 'graduates23'
password = 'CanGrad2023'
driver = '{ODBC Driver 17 for SQL Server}'

# Establish a connection to the database
conn = pyodbc.connect(f"DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password}")

# Create a cursor to execute SQL statements
cursor = conn.cursor()

# Create the table if it doesn't exist
table_name = 'CarListings2023_new'
create_table_query = '''
    CREATE TABLE CarListings2023_new (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        Title NVARCHAR(255),
        Price NVARCHAR(255),
        [Expected Payment per Month] NVARCHAR(255),
        [New/Old] NVARCHAR(255),
        [Registration Year] NVARCHAR(255),
        Transmission NVARCHAR(255),
        [Body Type] NVARCHAR(255),
        Rating NVARCHAR(255),
        Fuel_Type NVARCHAR(255),
        [Last_Updated] NVARCHAR(255),
        Manufacturers_Colour NVARCHAR(255),
        Introduction_Date NVARCHAR(255),
        Service_Interval_Distance NVARCHAR(255),
        Engine_Position NVARCHAR(255),
        Engine_Detail NVARCHAR(255),
        Engine_Capacity NVARCHAR(255),
        [Cylinder Layout and Quantity] NVARCHAR(255),
        Fuel_Capacity NVARCHAR(255),
        [Fuel Consumption (Average)_] NVARCHAR(255),
        [Fuel Range (Average)] NVARCHAR(255),
        [Power Maximum (Detail)] NVARCHAR(255),
        [Torque Maximum] NVARCHAR(255),
        [Acceleration 0-100 km/h] NVARCHAR(255),
        [Maximum/Top Speed] NVARCHAR(255),
        [CO2 Emissions (Average)] NVARCHAR(255),
        Dealer NVARCHAR(255),
        [Service History] NVARCHAR(255)
    )
'''
cursor.execute(create_table_query)
conn.commit()


page_number = 1
while True:
    url = base_url.format(page_number)
    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')
    listing_tiles = soup.find_all('div', class_='e-featured-tile-container')

    if not listing_tiles:
        break  # No more listings on this page, exit the loop

    for tile in listing_tiles:
        car_data = extract_car_data(tile)

        # Insert the data into the database
        insert_query = '''
            INSERT INTO CarListings (
                Title, Price, ExpectedPaymentPerMonth, NewOld, RegistrationYear,
                Transmission, BodyType, Rating, FuelType, LastUpdated,
                ManufacturersColour, IntroductionDate, ServiceIntervalDistance,
                EnginePosition, EngineDetail, EngineCapacity, CylinderLayoutAndQuantity,
                FuelCapacity, FuelConsumptionAverage, FuelRangeAverage,
                PowerMaximumDetail, TorqueMaximum, Acceleration0_100KmH,
                MaximumTopSpeed, CO2EmissionsAverage, Dealer, ServiceHistory
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        '''
        cursor.execute(insert_query, (
            car_data['Title'], car_data['Price'], car_data['Expected Payment per Month'],
            car_data['New/Old'], car_data['Registration Year'], car_data['Transmission'],
            car_data['Body Type'], car_data['Rating'], car_data['Fuel_Type'],
            car_data['Last_Updated'], car_data['Manufacturers_Colour'], car_data['Introduction_Date'],
            car_data['Service_Interval_Distance'], car_data['Engine_Position'], car_data['Engine_Detail'], car_data['Engine_Capacity'], car_data['Cylinder Layout and Quantity'],
            car_data['Fuel Capacity'], car_data['Fuel Consumption (Average)_'], car_data['Fuel Range (Average)'],
            car_data['Power Maximum (Detail)'], car_data['Torque Maximum'], car_data['Acceleration 0-100 km/h'],
            car_data['Maximum/Top Speed'], car_data['CO2 Emissions (Average)'], car_data['Dealer'],
            car_data['Service History']
        ))
        conn.commit()

    page_number += 1

# Close the database connection
cursor.close()
conn.close()

print("Car listings extracted and saved to the database.")


# In[ ]:




