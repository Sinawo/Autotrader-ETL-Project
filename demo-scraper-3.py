import requests
from bs4 import BeautifulSoup 
import pandas as pd



base_url = "https://www.autotrader.co.za" 
    
#demo
#base_url = "file:///C:/Users/Student/CanvasProject/" 
# response = open('Land Rover Cars.html', 'r') 

header = { 'User-Agent' : 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36' }
#This is going to store the links for each car
car_links = []
vehicle_details = []
specifications = []




proxy = "http://50f791d8d804651ab0a4a8e83231e952ad1e5eee:js_render=true&antibot=true&wait=15000&js_instructions=%255B%257B%2522click%2522%253A%2522.selector%2522%257D%252C%257B%2522wait%2522%253A500%257D%252C%257B%2522fill%2522%253A%255B%2522.input%2522%252C%2522value%2522%255D%257D%252C%257B%2522wait_for%2522%253A%2522.slow_selector%2522%257D%255D&premium_proxy=true@proxy.zenrows.com:8001"
proxies = {"http": proxy, "https": proxy}

  
#Converts the list to dictionary 
def Convert(lst):
    res_dct = {lst[i]: lst[i + 1] for i in range(0, len(lst), 2)}
    return res_dct

def get_links(response):
    home_page = BeautifulSoup(response.content, 'lxml')
    car_list = home_page.find_all('div', attrs={'class': 'b-result-tiles'})
    for item in car_list:
        for link in item.find_all('a', href=True):
        #Add the links with baseURL

            car_links.append(base_url + link['href'])
    return car_links

def get_car_summary_info(soup):
    values = []
    try:
        price = soup.find('div', attrs={'class': 'e-price'}).text
        #dealer_name = soup.find('a', attrs={'class': 'e-dealer-link'} ).text
    except:
        price = '0'
    try:
        name = soup.find('h1', attrs={'class': 'e-listing-title'}).text
    except:
        name = "no name"
    values.append(name)
    values.append(price)
    #values.append(dealer_name)
    for item in soup.find_all('li', attrs={'class': 'e-summary-icon'}):
        values.append(item.text)
    print(values)
    
    
    


#========================================THIS CODE works for retrieving links=================================
#demo
for page in range(2):
    response = requests.get(f"https://www.autotrader.co.za/cars-for-sale?pagenumber={page}")
    print(response.status_code)
    home_page = BeautifulSoup(response.content, 'lxml')
    car_list = home_page.find_all('div', attrs={'class': 'b-result-tiles'})
    for item in car_list:
        found_cars = 0
        for link in item.find_all('a', href=True):
        #Add the links with baseURL
            if found_cars == 11:
              break
        
            found_link = (base_url + link['href'])
    
            r = requests.get(found_link, timeout=10)              
            soup = BeautifulSoup(r.content, 'lxml')
   
            # car_info = soup.find('div', attrs={'class': 'e-featured-tile-container'} )

            
            get_car_summary_info(soup)
            
            try:
                vd = soup.find_all('div' , attrs={'class': 'col-6'})
            except:
                vd = "No Vehicle details"
            if vd == "No Vehicle details":
                print(vd)
            else:
                [vehicle_details.append(row.text) for row in vd]
            print(Convert(vehicle_details))

            try:
                engine_details = soup.find_all('span' , attrs={'class': 'col-6'})
            except:
                engine_details = "No engine detals"
            if engine_details == "No engine detals":
                print(engine_details)
            else:
                [specifications.append(row.text) for row in engine_details ]
            print(Convert(specifications))   
            found_cars = found_cars+ 1
	    
    print(f'\n\n Next Vehicle on page: {page}')

  



