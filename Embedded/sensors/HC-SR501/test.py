import RPi.GPIO as GPIO
import time

# GPIO 핀 번호 설정
sensor_pin = 17  # 센서 연결 핀 번호, 실제 연결 상황에 맞게 조정하세요.

# GPIO 라이브러리 설정
GPIO.setmode(GPIO.BCM)
GPIO.setup(sensor_pin, GPIO.IN)  # 센서 핀을 입력으로 설정

try:
    print("PIR Module Test (CTRL+C to exit)")
    time.sleep(2)  # 초기화 시간
    print("Ready")

    while True:
        if GPIO.input(sensor_pin):
            print("Motion Detected!")
            time.sleep(1)  # 1초 동안 대기 후 다시 감지 시작
        time.sleep(0.1)  # 검사 간격 설정

except KeyboardInterrupt:
    print("Program stopped by User")
    GPIO.cleanup()  # GPIO 설정 초기화

