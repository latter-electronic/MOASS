from bluepy.btle import Scanner, DefaultDelegate

class ScanDelegate(DefaultDelegate):
    def __init__(self):
        DefaultDelegate.__init__(self)

    # def handleDiscovery(self, dev, isNewDev, isNewData):
    #     if isNewDev:
    #         print("Discovered device", dev.addr)
    #     elif isNewData:
    #         print("Received new data from", dev.addr)

print("Scan Start...")
scanner = Scanner().withDelegate(ScanDelegate())
devices = scanner.scan(10.0)

# 원하는 비콘의 MAC 주소 설정
desired_mac = "c3:00:00:1c:6e:ed"

for dev in devices:
    # 특정 MAC 주소로 필터링
    if dev.addr.lower() == desired_mac.lower():
        print(f"Device {dev.addr} matched MAC address.")
        rssi = dev.rssi
        measured_power = -59  # 캘리브레이션된 1m에서의 RSSI 값
        N = 2.0  # 환경 상수
        distance = 10 ** ((measured_power - rssi) / (10 * N))
        print("Distance: %.2f m" % distance)
        # 거리에 따른 점유 상태 판단
        occupied = distance < 1.0  # 1미터 이내면 점유로 간주
        print("Seat Occupied:", occupied)
        # 이후 서버로 데이터 전송 로직 구현할 수 있습니다.
