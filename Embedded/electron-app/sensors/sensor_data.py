# DamaskRose

#  - NFC 기기 로그인 기능
#    : NFC 태깅 후 Token 전달

#  - 인체 감지 센서 기능
#    1. 로그인 상태
#        1-1. 5분 이상 자리 비움
#        1-2. 2시간 이상 자리에 앉아 있는 경우
#    2. 로그아웃 상태
#        2-1. 사람 인식 후 AOD 화면 출력

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
print("Waiting for NFC card...", file=sys.stderr)

# 설정된 시간 정의
NO_MOTION_TIMEOUT = 300  # 5분
LONG_SIT_TIMEOUT = 7200  # 2시간
last_motion_time = time.time()

while True:
    if not  logged_in:  # 로그아웃 상태
        # 카드의 UID 읽기
        uid = pn532.read_passive_target(timeout=0.5)
        if uid is not None:
            # 카드 UID를 헥사 문자열로 변환
            card_serial_id = ''.join(["{0:x}".format(i).zfill(2) for i in uid])
            # print("card UID:", card_serial_id)
            
            # 라즈베리파이 시리얼 넘버
            device_id = get_serial_number()
            
            # POST 요청 보내기
            url = f'{server_url}/api/device/login'
            payload = {'deviceId': device_id, 'cardSerialId': card_serial_id}
            headers = {'Content-Type': 'application/json'}

            try:
                response = requests.post(url, json=payload, headers=headers)
                response_data = response.json()
                # print("Server response:", response_data)

                if response.status_code == 200 and response_data.get('message') == '로그인 성공':
                    print(json.dumps(response_data))  # 로그인 데이터 출력
                    logged_in = True
                    motion_detected_time = time.time()  # 움직임 감지 시간 초기화
                else:
                    print("Login failed:", response_data.get('message'))
            except Exception as e:
                print(f"Failed to receive data: {e}")

        elif pir.motion_detected:
            # 로그아웃 상태에서 감지 시 AOD 화면 출력
            print("Motion detected in logged out state.")
            sys.stdout.write(json.dumps({"type": "AOD"}))
            sys.stdout.flush()

    elif logged_in: # 로그인 상태
        if pir.motion_detected: # 움직임 감지
            motion_detected_time = time.time()
            last_motion_time = time.time()
            print("Motion detected.")

        current_time = time.time()
        if current_time - motion_detected_time > NO_MOTION_TIMEOUT:
            # 자리 비움 상태 전달
            print("No motion detected for 5 minutes, sending away status.")
            sys.stdout.write(json.dumps({"type": "AWAY"}))
            sys.stdout.flush()
            motion_detected_time = current_time  # 타이머 리셋

        if current_time - last_motion_time > LONG_SIT_TIMEOUT:
            # 오래 앉아 있음 상태 전달
            print("Continuous motion detected for 2 hours, sending long sit status.")
            sys.stdout.write(json.dumps({"type": "LONG_SIT"}))
            sys.stdout.flush()
            last_motion_time = current_time  # 타이머 리셋
    
    # 로그아웃 기능 추가!!!!!!
    
    time.sleep(1)  # 검사 간격 조정
       