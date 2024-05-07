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
import board
import busio
import time
import json
import sys
import requests
import io
import traceback
from dotenv import load_dotenv
from adafruit_pn532.i2c import PN532_I2C
from gpiozero import MotionSensor

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
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

# -----------------------------------------------------------------

# 기기 시리얼 넘버 
def get_serial_number():
    with open('/proc/cpuinfo', 'r') as f:
        for line in f:
            if line.startswith('Serial'):
                return line.split(':')[1].strip()
    return None

# NFC uid 읽기
def read_uid():
    uid = pn532.read_passive_target(timeout=0.5)
    if uid is not None:
        return ''.join(["{0:x}".format(i).zfill(2) for i in uid])
    return None

# 로그인 정보 송신(electron)
def handle_login_response(device_id, card_serial_id):
    if device_id and card_serial_id:
        print("NFC 로그인 성공")
        sys.stdout.write(json.dumps({"type": "NFC_DATA", "data": {'deviceId': device_id, 'cardSerialId': card_serial_id}}))
        sys.stdout.flush()
        return True
    print("Login failed")
    return False

# 인체 감지 센서 로직
def handle_motion_detection():
    global motion_detected_time, last_motion_time
    if pir.motion_detected:
        motion_detected_time = last_motion_time = time.time()
        print("Motion detected.")

    current_time = time.time()
    if current_time - motion_detected_time > NO_MOTION_TIMEOUT:
        print("자리 비움 상태")
        sys.stdout.write(json.dumps({"type": "MOTION_DETECTED", "data": {"status": "AWAY"}}))
        sys.stdout.flush()
        motion_detected_time = current_time

    if current_time - last_motion_time > LONG_SIT_TIMEOUT:
        print("오래 앉아 있음 상태")
        sys.stdout.write(json.dumps({"type": "MOTION_DETECTED", "data": {"status": "LONG_SIT"}}))
        sys.stdout.flush()
        last_motion_time = current_time

# -----------------------------------------------------------------

# 메인 로직
if __name__ == '__main__': 
    device_id = get_serial_number()
    
    while True:
        try:
            line = sys.stdin.readline()
            data = json.loads(line)
            if data.get("action") == "login_success":
                logged_in = True
                print("Login status changed to True")

            if not logged_in:   # 로그아웃 상태
                card_serial_id = read_uid()
                if card_serial_id:
                    logged_in = handle_login_response(device_id, card_serial_id)
                elif pir.motion_detected:
                    print("AOD 상태")
                    sys.stdout.write(json.dumps({"type": "MOTION_DETECTED", "data": {"status": "AOD"}}))
                    sys.stdout.flush()
            
            else:   # 로그인 상태
                handle_motion_detection()

        except json.JSONDecodeError as e:
            print("JSON Decode Error:", str(e))
        except Exception as e:
            print("An error occurred:", traceback.format_exc())

        time.sleep(1)