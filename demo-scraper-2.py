import requests
from bs4 import BeautifulSoup 
import pandas as pd

#Creadential to a proxy lab


base_url = "https://www.autotrader.co.za" 
    
#demo
#base_url = "file:///C:/Users/Student/CanvasProject/" 
# response = open('Land Rover Cars.html', 'r') 


#This is going to store the links for each car
car_links = []
vehicle_details = []
specifications = []
values = []



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
    values  = []
    try:
        price = soup.find('div', attrs={'class': 'e-price'}).text
    except:
        price = '0'
    try:
        name = soup.find('h1', attrs={'class': 'e-listing-title'}).text
    except:
        name = "no name"
    values.append(name)
    values.append(price)
    for item in soup.find_all('li', attrs={'class': 'e-summary-icon'}):
        values.append(item.text)
    print(values)
    values = []
    


#========================================THIS CODE works for retrieving links=================================
#demo
for page in range(1, 4):
    response = requests.get(f"https://www.autotrader.co.za/cars-for-sale?pagenumber={page}&priceoption=RetailPrice")
    car_links = get_links(response)
    #------------------------------------------------------------------------------------------------------------
    i = 0
    for link in car_links:
            r = requests.get(link)              
            soup = BeautifulSoup(r.content, 'lxml')
            car_info = soup.find('div', attrs={'class': 'b-listing-info'} )

            print("Summary:")
            get_car_summary_info(soup)

            try:
                vd = car_info.find_all('div' , attrs={'class': 'col-6'})
            except:
                vd = "No Vehicle detals"
            if vd == "No Vehicle detals":
                    print(vd)
            else:
                [vehicle_details.append(row.text) for row in vd]
            print(Convert(vehicle_details))

            try:
                engine_details = car_info.find('span' , attrs={'class': 'col-6'})
            except:
                engine_details = "No engine detals"
            if engine_details == "No engine detals":
                print(engine_details)
            else:
                [specifications.append(row.text) for row in engine_details ]
            print(Convert(specifications))
            
            i = i + 1
            if i == 3:
                break
 
    print(f'\n\n Next Vehicle on page: {page}')

  



