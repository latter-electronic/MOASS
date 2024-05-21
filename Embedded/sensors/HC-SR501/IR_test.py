import RPi.GPIO as GPIO
import time

# GPIO 핀 번호 설정
IR_SENSOR_PIN = 17

# GPIO 설정
GPIO.setmode(GPIO.BCM)
GPIO.setup(IR_SENSOR_PIN, GPIO.IN)

def main():
    print("IR 센서 테스트 시작 (Ctrl+C로 종료)")

    try:
        while True:
            if GPIO.input(IR_SENSOR_PIN):
                print("물체 감지됨", GPIO.input(IR_SENSOR_PIN))
            else:
                print("물체 감지되지 않음", GPIO.input(IR_SENSOR_PIN))
            time.sleep(0.5)
    except KeyboardInterrupt:
        print("테스트 종료")
    finally:
        GPIO.cleanup()

if __name__ == "__main__":
    main()
