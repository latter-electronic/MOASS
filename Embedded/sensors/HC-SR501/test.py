import RPi.GPIO as GPIO
import time

# GPIO 핀 번호 설정
sensor_pin = 17  # 센서 연결 핀 번호

GPIO.setmode(GPIO.BCM)
GPIO.setup(sensor_pin, GPIO.IN) 

def main():
    try:
        print("PIR Module Test (CTRL+C to exit)")
        time.sleep(2)  # 초기화 시간
        print("Ready")

        while True:
            if GPIO.input(sensor_pin):
                print("Motion Detected!")
            else:
                print('Not detected')
            time.sleep(0.1)  # 검사 간격 설정

    except KeyboardInterrupt:
        print("Program stopped by User")
        GPIO.cleanup()  # GPIO 설정 초기화

if __name__ == "__main__":
    main()