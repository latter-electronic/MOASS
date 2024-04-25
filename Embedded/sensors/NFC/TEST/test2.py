import requests

url = "https://ssafyfood-www-jong.koyeb.app/ssafy_food/today_menu/"
response = requests.post(url)
response_data = response.json()
print("Server response:", response_data)