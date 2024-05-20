# -*- coding: utf-8 -*-
import os
import board
import busio
import time
import json
import sys
import io
import traceback
import threading
import RPi.GPIO as GPIO
from dotenv import load_dotenv
from adafruit_pn532.i2c import PN532_I2C
import subprocess

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
load_dotenv()

server_url = os.getenv('SERVER_URL')

i2c = busio.I2C(board.SCL, board.SDA)
pn532 = PN532_I2C(i2c, debug=False)
pn532.SAM_configuration()

motion_sensor_pin = 17
GPIO.setmode(GPIO.BCM)
GPIO.setup(motion_sensor_pin, GPIO.IN)

last_motion_time = time.time()
motion_state = 'AWAY'
stay_start_time = None
logged_in = False
logged_in_lock = threading.Lock()

NO_MOTION_TIMEOUT = 30  # 30 seconds
LONG_SIT_TIMEOUT = 60  # 2 minutes

print("Waiting for NFC card...", file=sys.stderr)

# -----------------------------------------------------------------

def listen_for_commands():
    global logged_in
    while True:
        try:
            line = sys.stdin.readline()
            print(f"Received command: {line}", file=sys.stderr)
            if line:
                data = json.loads(line)
                with logged_in_lock:
                    if data.get("action") == "login":
                        logged_in = True
                        print(f"Login signal received: {data}", file=sys.stderr)
                    elif data.get("action") == "logout":
                        logged_in = False
                        print(f"Logout signal received: {data}", file=sys.stderr)
                        check_aod_and_set_display_power()  
        except json.JSONDecodeError as e:
            print("JSON Decode Error:", str(e), file=sys.stderr)
        except Exception as e:
            print("An error occurred:", traceback.format_exc(), file=sys.stderr)
        except KeyboardInterrupt:
            print("Thread interrupted", file=sys.stderr)
            break

def get_serial_number():
    with open('/proc/cpuinfo', 'r') as f:
        for line in f:
            if line.startswith('Serial'):
                return line.split(':')[1].strip()
    return None

def read_uid():
    uid = pn532.read_passive_target(timeout=0.5)
    if uid is not None:
        return ''.join(["{0:x}".format(i).zfill(2) for i in uid])
    return None

def handle_login_response(device_id, card_serial_id):
    if device_id and card_serial_id:
        login_data = {
            'type': 'NFC_DATA',
            'data': {
                'deviceId': device_id,
                'cardSerialId': card_serial_id
            }
        }
        nfc_data = json.dumps(login_data, ensure_ascii=False)
        sys.stdout.write(nfc_data + '\n')
        sys.stdout.flush()
        print(nfc_data, file=sys.stderr)

def handle_logged_in_state():
    global last_motion_time, motion_state, stay_start_time
    try:
        current_time = time.time()
        if GPIO.input(motion_sensor_pin):
            if motion_state == 'AWAY' or motion_state == 'LONG_SIT':
                motion_state = 'STAY'
                stay_start_time = current_time
                send_motion_status("STAY")
            last_motion_time = current_time
            # Check for LONG_SIT
            if stay_start_time and (current_time - stay_start_time) >= LONG_SIT_TIMEOUT:
                if motion_state != 'LONG_SIT':
                    motion_state = 'LONG_SIT'
                    send_motion_status("LONG_SIT")
        else:
            # Check for AWAY
            if (current_time - last_motion_time) >= NO_MOTION_TIMEOUT:
                if motion_state != 'AWAY':
                    motion_state = 'AWAY'
                    stay_start_time = None  # Reset the stay start time
                    send_motion_status("AWAY")

    except Exception as e:
        print(f"An error occurred during motion detection: {e}", file=sys.stderr)
        traceback.print_exc()

def handle_logged_out_state():
    global last_motion_time, motion_state
    try:
        current_time = time.time()
        if GPIO.input(motion_sensor_pin):
            if motion_state != 'LOGOUT_STAY':
                motion_state = 'LOGOUT_STAY'
                print(motion_state, file=sys.stderr)
                set_display_power(True)
            last_motion_time = current_time
        else:
            if (current_time - last_motion_time) >= NO_MOTION_TIMEOUT:
                if motion_state != 'LOGOUT_AWAY':
                    motion_state = 'LOGOUT_AWAY'
                    print(motion_state, file=sys.stderr)
                    set_display_power(False)
    except Exception as e:
        print(f"An error occurred during motion detection: {e}", file=sys.stderr)
        traceback.print_exc()

def send_motion_status(status):
    motion_data = json.dumps({
        "type": "MOTION_DETECTED",
        "data": {
            "status": status
        }
    })
    sys.stdout.write(motion_data + '\n')
    sys.stdout.flush()

def set_display_power(on):
    if on:
        subprocess.run(['vcgencmd', 'display_power', '1'])
    else:
        subprocess.run(['vcgencmd', 'display_power', '0'])

def check_aod_and_set_display_power():
    global motion_state
    if motion_state != 'AOD':
        set_display_power(False)
    else:
        set_display_power(True)

# -----------------------------------------------------------------

if __name__ == '__main__':
    device_id = get_serial_number()

    command_thread = threading.Thread(target=listen_for_commands)
    command_thread.start()

    while True:
        try:
            with logged_in_lock:
                current_logged_in_status = logged_in

            if current_logged_in_status:
                handle_logged_in_state()
            else:
                card_serial_id = read_uid()
                if card_serial_id:
                    print(card_serial_id, file=sys.stderr)
                    handle_login_response(device_id, card_serial_id)
                else:
                    handle_logged_out_state()

        except json.JSONDecodeError as e:
            print("JSON Decode Error:", str(e), file=sys.stderr)
        except Exception as e:
            print("An error occurred:", traceback.format_exc(), file=sys.stderr)
        except KeyboardInterrupt:
            print("Program stopped by User", file=sys.stderr)
            GPIO.cleanup()
            break

        time.sleep(1)
