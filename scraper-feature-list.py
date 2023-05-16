import requests
from bs4 import BeautifulSoup 
import pandas as pd



base_url = "https://www.autotrader.co.za" 
    
#demo
#base_url = "file:///C:/Users/Student/CanvasProject/" 
# response = open('Land Rover Cars.html', 'r') 

header = { 'User-Agent' : 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36' 


}
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


    
    


#========================================THIS CODE works for retrieving links=================================
#demo
for page in range(1):
    response = requests.get(f"https://www.autotrader.co.za/cars-for-sale?pagenumber={page}")
    print(response.status_code)

    soup = BeautifulSoup(response.content, 'lxml')
    # cars_container = soup.find_all('span', class_='e-details') --> I'll used this one when I want to loop through this div tag
    car_contaner = soup.find_all('div', attrs={'class': 'b-result-tiles'})
    price = car_contaner.find_all('span', attrs={'class': 'e-price'}).text
    price_rating = car_contaner.find_all('span', attrs={'class': 'b-price-rating m-norating'}).text
    title = car_contaner.find_all('span', attrs={'class': 'e-price'}).text
    
    used_new = car_contaner.find_all('span', attrs={'class': 'e-summary-icon m-type'}).text
    mileage = car_contaner.find_all('span', attrs={'class': 'e-summary-icon'}).text
    transmission = car_contaner.find_all('span', attrs={'class': 'e-summary-icon'})[1].text
    dealer = car_contaner.find_all('span', attrs={'class': 'e-dealer'}).text
    summary_details = {
        'Car_Title' : title,
        'Price': price,
        'Price Rating': price_rating,
        'New/Used': used_new,
        'Mileage': mileage,
        'Transimmision': transmission,
        'Dealer': dealer
    }
    df = pd.Dataframe(summary_details)
    print(df)
    #Now lets take the link fromthis car container div tag 
    for item in car_contaner:
        for link in item.find_all('a', href=True):
        #Lets visit the link then
            r = requests.get(base_url + link['href'], timeout=10)              
            soup = BeautifulSoup(r.content, 'lxml')
            try:
                vd = soup.find_all('div' , attrs={'class': 'col-6'})
            except:
                vd = "No Vehicle details"
            if vd == "No Vehicle details":
                print(vd)
            else:
                [vehicle_details.append(row.text) for row in vd]
            vdf =pd.DataFrame(Convert(vehicle_details))
            print(vdf)

            try:
                engine_details = soup.find_all('span' , attrs={'class': 'col-6'})
            except:
                engine_details = "No engine detals"
            if engine_details == "No engine detals":
                print(engine_details)
            else:
                [specifications.append(row.text) for row in engine_details ]
            sdf =pd.DataFrame(Convert(specifications))
            print(sdf)
            if i == 3:
                break
            i = i + 1
    
    print(f'\n\n Next Vehicle on page: {page}')
            
    





    car_links = get_links(response)
    i = 0
    for link in car_links:
            r = requests.get(link)              
            soup = BeautifulSoup(r.content, 'lxml')
   
            car_info = soup.find('div', attrs={'class': 'e-featured-tile-container'} )

            
            
            

  



