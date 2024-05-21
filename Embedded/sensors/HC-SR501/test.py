import RPi.GPIO as GPIO
import time

# GPIO 핀 번호 설정
motion_sensor_pin = 17  # 센서 핀 연결 번호

# GPIO 모드 설정
GPIO.setmode(GPIO.BCM)
GPIO.setup(motion_sensor_pin, GPIO.IN)

try:
    print("PIR 모션 센서 테스트 시작 (Ctrl+C로 종료)")
    time.sleep(2)  # 센서 안정화 시간

    while True:
        if GPIO.input(motion_sensor_pin):
            print("모션 감지됨!")
            # 모션이 감지된 후에는 모션이 없을 때까지 대기
            start_time = time.time()
            while GPIO.input(motion_sensor_pin):
                time.sleep(0.1)  # 모션이 지속되는 동안 잠시 대기
            end_time = time.time()
            print(f"모션 유지 시간: {end_time - start_time:.2f} 초")

        time.sleep(0.1)  # 상태 확인 주기 조정

except KeyboardInterrupt:
    print("테스트 종료")

finally:
    GPIO.cleanup()  # GPIO 설정 초기화

