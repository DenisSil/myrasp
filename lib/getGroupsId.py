import requests
import csv
import random

response = requests.get("https://edu.donstu.ru/api/raspGrouplist?year=2023-2024")

data = response.json()['data']
print(data)

with open('groups.csv', 'w', newline='') as csvfile:
    spamwriter = csv.writer(csvfile, delimiter=' ',
                            quotechar='|', quoting=csv.QUOTE_MINIMAL)
    for i in data:
        spamwriter.writerow(f"{i['name']} {i['id']}")

print()