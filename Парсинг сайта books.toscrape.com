import requests
from bs4 import BeautifulSoup
import csv

url = "https://books.toscrape.com"
response = requests.get(url)
soup = BeautifulSoup(response.text, 'html.parser')

# Твой существующий код парсинга
titles = soup.find_all('h3')
prices = soup.find_all('p', class_='price_color')

with open('результат.csv', 'w', newline='', encoding='utf-8-sig') as f:
    writer = csv.writer(f)
    writer.writerow(['Название', 'Цена'])  # русские заголовки
    
    for i in range(len(titles)):
        clean_price = prices[i].text.replace('Â£', '').replace('£', '')
        writer.writerow([titles[i].text, clean_price])

print("✅ Файл 'результат.csv' готов!")
