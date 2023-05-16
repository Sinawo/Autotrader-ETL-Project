import threading 
import queue
import requests
import concurrent.futures
import random
from bs4 import BeautifulSoup 
import pandas as pd
# q = queue.Queue()
# valid_proxies = []

# with open("proxylist.txt", "r") as file:
#     proxy_list = file.read().split("\n")
#     for p in proxies:
#         q.put(p)

# Read list of proxies from a text file

base_url = "https://www.autotrader.co.za" 

car_links = []
vehicle_details = []
specifications = []

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
        dealer_name = soup.find('a', attrs={'class': 'e-dealer-link'} ).text
    except:
        price = '0'
    try:
        name = soup.find('h1', attrs={'class': 'e-listing-title'}).text
    except:
        name = "no name"
    values.append(name)
    values.append(price)
    values.append(dealer_name)
    for item in soup.find_all('li', attrs={'class': 'e-summary-icon'}):
        values.append(item.text)
    print(values)
    
with open('userAgents.txt', 'r') as f:
    headers_list = [line.strip() for line in f]

with open('proxylist.txt', 'r') as f:
    proxy_list = [line.strip() for line in f]

def extract(proxy):
# Test each proxy individually
    # proxy = random.choice(proxylist)
    for proxy in proxy_list:
        try:
            #response = requests.get('http://ipinfo.io/json', proxies={'https': proxy}, timeout=5)
            for page in range(1):
                header = random.choice(headers_list)
                response = requests.get(f"https://www.autotrader.co.za/cars-for-sale?pagenumber={page}", headers=header, proxies={'https': proxy}, timeout=5)
                print(response.status_code)
                car_links = get_links(response)#response = requests.get('https://httpbin.org/ip', proxies={'https': proxy}, timeout=5)

                i = 0
                for link in car_links:
                    # proxy = random.choice(proxylist)
                    r = requests.get(link, headers=header, proxies={'https': proxy}, timeout=5 )              
                    soup = BeautifulSoup(r.content, 'lxml')
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
                    if i == 3:
                        break
                    i = i + 1
            
            print(f'\n\n Next Vehicle on page: {page}')


            # If the request was successful, print the proxy and response status code
            print(f"{proxy} is working (status code: {response.status_code})")

        except:
            # If the request failed, print the proxy and a message indicating the failure
            #print(f"{proxy} is not working")
            pass
            

with concurrent.futures.ThreadPoolExecutor() as executor:
    executor.map(extract, proxy_list)

# def check_proxies():
#     global q 
#     while not q.empty():
#         proxy = q.get()
#         try:
#             #This is the website used for th=esting the proxies is working or valid
#             response = requests.get("http://ipinfo.io/json",
#                                proxies = {"http": proxy,
#                                           "https": proxy})
#             print(proxy)
#             print(response.status_code)
            
#         except:
            
#             continue
#         if response.status_code == 200:
#             valid_proxies.append(proxy)
#             print(valid_proxies)
        
# for _ in range(10):
#     threading.Thread(target=check_proxies()).start
            