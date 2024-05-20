# DamaskRose
# 기기 로그인 기능

import os
from dotenv import load_dotenv
import board
import busio
import time
from adafruit_pn532.i2c import PN532_I2C
import requests

def get_serial_number():
    with open('/proc/cpuinfo', 'r') as f:
        for line in f:
            if line.startswith('Serial'):
                return line.split(':')[1].strip()
    return None

load_dotenv() # .env 파일 로드
server_url = os.getenv('SERVER_URL')

i2c = busio.I2C(board.SCL, board.SDA) # I2C 연결 설정
pn532 = PN532_I2C(i2c, debug=False) # PN532 모듈 초기화
pn532.SAM_configuration() # SAM 구성

print("Waiting for NFC card...")
pause_duration = 60  # 로그인 성공 후 일시 중지할 시간 -> 로그아웃 전까지로 수정 요함

while True:
    # 카드의 UID 읽기
    uid = pn532.read_passive_target(timeout=0.5)
    if uid is not None:
        # 카드 UID를 헥사 문자열로 변환
        card_serial_id = ''.join(["{0:x}".format(i).zfill(2) for i in uid])
        print("card UID:", card_serial_id)
        
        # 라즈베리파이 시리얼 넘버
        device_id = get_serial_number()
        print(device_id)
        
        # POST 요청 보내기
        url = f'{server_url}/api/device/login'
        payload = {'deviceId': device_id, 'cardSerialId': card_serial_id}
        headers = {'Content-Type': 'application/json'}
        
        response = requests.post(url, json=payload, headers=headers)
        response_data = response.json()
        print("Server response:", response_data)

        if response.status_code == 200 and response_data.get('message') == '로그인 성공':
            print("Login successful. Pausing NFC detection for", pause_duration, "seconds.")
            time.sleep(pause_duration)  # 로그인 성공, 일시 중지
            # 로그아웃 로직 필요함
        else:
            print("Login failed:", response_data.get('message'))
            print("Ready for next NFC tag...")
        
        time.sleep(1)
