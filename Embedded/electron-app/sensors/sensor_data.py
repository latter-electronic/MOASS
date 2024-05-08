# DamaskRose

#  - NFC ��� �α��� ���
#    : NFC �±� �� Token ����

#  - ��ü ���� ���� ���
#    1. �α��� ����
#        1-1. 5�� �̻� �ڸ� ���
#        1-2. 2�ð� �̻� �ڸ��� �ɾ� �ִ� ���
#    2. �α׾ƿ� ����
#        2-1. ��� �ν� �� AOD ȭ�� ���

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
load_dotenv() # .env ���� �ε�

server_url = os.getenv('SERVER_URL')
i2c = busio.I2C(board.SCL, board.SDA) # I2C ���� ����
pn532 = PN532_I2C(i2c, debug=False) # PN532 ��� �ʱ�ȭ
pn532.SAM_configuration() # SAM ����

pir = MotionSensor(17)  # GPIO 17�� �ɿ� ����� PIR ���� HC-SR501
motion_detected_time = time.time()

logged_in = False
# print("Waiting for NFC card...", file=sys.stderr)

# ������ �ð� ����
NO_MOTION_TIMEOUT = 300  # 5��
LONG_SIT_TIMEOUT = 7200  # 2�ð�
last_motion_time = time.time()

# -----------------------------------------------------------------

# ��� �ø��� �ѹ� 
def get_serial_number():
    with open('/proc/cpuinfo', 'r') as f:
        for line in f:
            if line.startswith('Serial'):
                return line.split(':')[1].strip()
    return None

# NFC uid �б�
def read_uid():
    uid = pn532.read_passive_target(timeout=0.5)
    if uid is not None:
        return ''.join(["{0:x}".format(i).zfill(2) for i in uid])
    return None

# �α��� ���� �۽�(electron)
def handle_login_response(device_id, card_serial_id):
    if device_id and card_serial_id:
        # print("NFC �α��� ����")
        nfc_data = json.dumps({"type": "NFC_DATA", "data": {'deviceId': device_id, 'cardSerialId': card_serial_id}}, ensure_ascii=False)
        sys.stdout.write(nfc_data + '\n')
        sys.stdout.flush()
        return True
    # print("Login failed")
    return False

# ��ü ���� ���� ����
def handle_motion_detection():
    global motion_detected_time, last_motion_time
    if pir.motion_detected:
        motion_detected_time = last_motion_time = time.time()
        # print("Motion detected.")

    current_time = time.time()
    if current_time - motion_detected_time > NO_MOTION_TIMEOUT:
        # print("�ڸ� ��� ����")
        sys.stdout.write(json.dumps({"type": "MOTION_DETECTED", "data": {"status": "AWAY"}}))
        sys.stdout.flush()
        motion_detected_time = current_time

    if current_time - last_motion_time > LONG_SIT_TIMEOUT:
        # print("���� �ɾ� ���� ����")
        sys.stdout.write(json.dumps({"type": "MOTION_DETECTED", "data": {"status": "LONG_SIT"}}))
        sys.stdout.flush()
        last_motion_time = current_time

# -----------------------------------------------------------------

# ���� ����
if __name__ == '__main__': 
    device_id = get_serial_number()
    
    while True:
        try:
            line = sys.stdin.readline()
            data = json.loads(line)
            if data.get("action") == "login_success":
                logged_in = True
                # print("Login status changed to True")

            if not logged_in:   # �α׾ƿ� ����
                card_serial_id = read_uid()
                if card_serial_id:
                    logged_in = handle_login_response(device_id, card_serial_id)
                # elif pir.motion_detected:
                #     print("AOD ����")
                #     sys.stdout.write(json.dumps({"type": "MOTION_DETECTED", "data": {"status": "AOD"}}))
                #     sys.stdout.flush()
            
            else:   # �α��� ����
                pass
                # handle_motion_detection()

        except json.JSONDecodeError as e:
            print("JSON Decode Error:", str(e))
        except Exception as e:
            print("An error occurred:", traceback.format_exc())

        time.sleep(1)