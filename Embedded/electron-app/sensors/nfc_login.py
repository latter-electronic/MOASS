# DamaskRose
# NFC 기기 로그인 기능

import os
from dotenv import load_dotenv
import board
import busio
import time
import json
import sys
import requests
from adafruit_pn532.i2c import PN532_I2C
from gpiozero import MotionSensor

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


pir = MotionSensor(17)  # GPIO 17번 핀에 연결된 PIR 센서 HC-SR501
motion_detected_time = time.time()

logged_in = False
print("Waiting for NFC card...")
pause_duration = 60

while True:
    if not  logged_in:  # 로그아웃 상태
        # 카드의 UID 읽기
        uid = pn532.read_passive_target(timeout=0.5)
        if uid is not None:
            # 카드 UID를 헥사 문자열로 변환
            card_serial_id = ''.join(["{0:x}".format(i).zfill(2) for i in uid])
            print("card UID:", card_serial_id)
            
            # 라즈베리파이 시리얼 넘버
            device_id = get_serial_number()
            
            # POST 요청 보내기
            url = f'{server_url}/api/device/login'
            payload = {'deviceId': device_id, 'cardSerialId': card_serial_id}
            headers = {'Content-Type': 'application/json'}

            try:
                response = requests.post(url, json=payload, headers=headers)
                response_data = response.json()
                print("Server response:", response_data)

                if response.status_code == 200 and response_data.get('message') == '로그인 성공':
                    print(json.dumps(response_data))  # 로그인 데이터 출력
                    # sys.stdout.flush()  # stdout을 즉시 플러시
                    logged_in = True
                    motion_detected_time = time.time()  # 움직임 감지 시간 초기화
                else:
                    print("Login failed:", response_data.get('message'))
            except Exception as e:
                print(f"Failed to send/receive data: {e}")

        elif pir.motion_detected:
            motion_detected_time = time.time()  # 움직임 감지 시간 업데이트

    elif logged_in:   # 로그인 상태
        if pir.motion_detected:
            motion_detected_time = time.time()  # 움직임 감지 시간 업데이트
            print("Motion detected.")

        if time.time() - motion_detected_time > 300:  # 5분 동안 움직임 없음
            print("No motion detected for 5 minutes, sending away status.")
            sys.stdout.write("AWAY\n")  # 자리 비움 신호 출력
            sys.stdout.flush()  # stdout을 즉시 플러시
    
    # 로그아웃 기능 추가!!!!!!
    
    time.sleep(1)  # 검사 간격 조정
       