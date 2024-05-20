from gpiozero import MotionSensor
import time

pirPin = MotionSensor(17)

try:
    while True:
        sensorValue = pirPin.value
        print(sensorValue)
        time.sleep(0.5)

except KeyboardInterrupt:
    pass