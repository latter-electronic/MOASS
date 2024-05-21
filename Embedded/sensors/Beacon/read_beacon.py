from bluepy.btle import Scanner, DefaultDelegate
import time

class ScanDelegate(DefaultDelegate):
    def __init__(self):
        DefaultDelegate.__init__(self)

def calculate_distance(rssi, tx_power):
    """
    Calculate the estimated distance from the RSSI value.
    """
    if rssi == 0:
        return -1.0  # unable to determine distance
    ratio = rssi * 1.0 / tx_power
    if ratio < 1.0:
        return ratio ** 10
    else:
        return (0.89976) * (ratio ** 7.7095) + 0.111

scanner = Scanner().withDelegate(ScanDelegate())

# 세 개의 비콘 MAC 주소 설정
beacon_macs = {
    "beacon1": "c3:00:00:1c:6e:e3",
    "beacon2": "c3:00:00:1c:6e:ce",
    "beacon3": "c3:00:00:1c:6e:ed"  
}

while True:
    print("Scanning...")
    devices = scanner.scan(10.0)  # 10초 동안 BLE 장치를 스캔

    for dev in devices:
        if dev.addr.lower() in [mac.lower() for mac in beacon_macs.values()]:
            rssi = dev.rssi
            measured_power = -59  # 캘리브레이션된 1m에서의 RSSI 값 (실제 값 필요)
            N = 2.0  # 환경 상수
            distance = calculate_distance(rssi, measured_power)
            beacon_id = [key for key, value in beacon_macs.items() if value.lower() == dev.addr.lower()][0]
            print(f"Distance to {beacon_id}: {distance:.2f} m")

    time.sleep(5)  # 30초 동안 대기 후 다시 스캔
