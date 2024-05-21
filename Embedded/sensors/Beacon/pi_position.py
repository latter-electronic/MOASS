# DamaskRose
# 자동 좌석도 생성 기능
from collections import deque
from bluepy.btle import Scanner, DefaultDelegate
import numpy as np
import math
import requests
import time
import os
from dotenv import load_dotenv
from scipy.optimize import least_squares, minimize

load_dotenv()  # 환경 변수 로드
server_url = os.getenv('SERVER_URL')

class ScanDelegate(DefaultDelegate):
    def __init__(self):
        DefaultDelegate.__init__(self)

class RSSISmoother:
    def __init__(self, window_size=10):
        self.rssi_queues = {}
        self.window_size = window_size
    
    def add_rssi(self, beacon_id, rssi):
        if beacon_id not in self.rssi_queues:
            self.rssi_queues[beacon_id] = deque(maxlen=self.window_size)
        self.rssi_queues[beacon_id].append(rssi)
        return np.mean(self.rssi_queues[beacon_id])
    
def get_serial_number():
    with open('/proc/cpuinfo', 'r') as f:
        for line in f:
            if line.startswith('Serial'):
                return line.split(':')[1].strip()
    return None

def calculate_distance(rssi, tx_power):
    # if rssi == 0:
    #     return -1.0
    # ratio = rssi * 1.0 / tx_power
    # if ratio < 1.0:
    #     return ratio ** 10
    # else:
    #     return (0.89976) * (ratio ** 7.7095) + 0.111

    if rssi == 0:
        return -1.0
    
    ratio_db = tx_power - rssi
    ratio_linear = 10 ** (ratio_db / (10 * 1))
    
    distance = math.sqrt(ratio_linear)
    return distance

def get_coordinates(dist_a, dist_b, dist_c, xa, ya, xb, yb, xc, yc):
    A = 2 * xb - 2 * xa
    B = 2 * yb - 2 * ya
    C = dist_a**2 - dist_b**2 - xa**2 + xb**2 - ya**2 + yb**2
    D = 2 * xc - 2 * xb
    E = 2 * yc - 2 * yb
    F = dist_b**2 - dist_c**2 - xb**2 + xc**2 - yb**2 + yc**2
    x = (C * E - F * B) / (E * A - B * D)
    y = (C * D - A * F) / (B * D - A * E)
    return (x, y)

def find_position(dist_a, dist_b, dist_c, xa, ya, xb, yb, xc, yc):
    """
    세 원의 교차점을 찾는 함수를 최적화 방법으로 개선
    각 원의 중심과 반지름을 이용하여 교차점 좌표를 계산
    """
    def objective(p):
        x, y = p
        return ((x - xa)**2 + (y - ya)**2 - dist_a**2)**2 + \
               ((x - xb)**2 + (y - yb)**2 - dist_b**2)**2 + \
               ((x - xc)**2 + (y - yc)**2 - dist_c**2)**2

    # 초기 추정치는 비콘의 중심점을 사용
    x_guess = (xa + xb + xc) / 3
    y_guess = (ya + yb + yc) / 3
    initial_guess = [x_guess, y_guess]
    
    # 최적화 실행
    result = minimize(objective, initial_guess, method='L-BFGS-B')
    
    # 최적화 결과에서 x, y 좌표 추출
    if result.success:
        optimized_x, optimized_y = result.x
        return optimized_x, optimized_y
    else:
        raise RuntimeError("Optimization failed: " + result.message)

# --------------------------------------------------------------------------------------------------

device_id = get_serial_number()

# 강의실, 책상 크기(cm)
room_width = 942
room_height = 1495 
desk_width = 85
desk_height = 85 

# 비콘 좌표
xa, ya = 1, 747.5   # MOASS_1
xb, yb = 940, 0     # MOASS_2
xc, yc = 941, 1490  # MOASS_3

rssi_smoother = RSSISmoother(window_size=5)
scanner = Scanner().withDelegate(ScanDelegate())

while True:
    print('Scanning....')
    devices = scanner.scan(15.0)

    distances = {}
    rssi_values = {}
    beacon_addresses = {
        'MOASS_1': 'c3:00:00:1c:6e:e3',
        'MOASS_2': 'c3:00:00:1c:6e:ce', 
        'MOASS_3': 'c3:00:00:1c:6e:ed'  
    }
    tx_power = -59  # 실제 측정된 tx_power 사용

    for dev in devices:
        if dev.addr.lower() in [mac.lower() for mac in beacon_addresses.values()]:
            beacon_id = [key for key, value in beacon_addresses.items() if value.lower() == dev.addr.lower()][0]
            smooth_rssi = rssi_smoother.add_rssi(beacon_id, dev.rssi)
            rssi_values[beacon_id] = smooth_rssi
            distances[beacon_id] = calculate_distance(smooth_rssi, tx_power)
            print(f'{beacon_id}: {distances[beacon_id]:.2f} meters')

    if len(distances) == 3:
        dist_a = distances.get('MOASS_1', None)
        dist_b = distances.get('MOASS_2', None)
        dist_c = distances.get('MOASS_3', None)
        rssi_a = rssi_values.get('MOASS_1', 0)
        rssi_b = rssi_values.get('MOASS_2', 0)
        rssi_c = rssi_values.get('MOASS_3', 0)

        if None not in [dist_a, dist_b, dist_c]:  # Ensure all distances are available
            x, y = find_position(dist_a, dist_b, dist_c, xa, ya, xb, yb, xc, yc)

            x_cm = int(x)  # 소수점 제거
            y_cm = int(y)  # 소수점 제거
            print(f'Computed coordinates: X = {x_cm}, Y = {y_cm}')

            x, y = get_coordinates(dist_a, dist_b, dist_c, xa, ya, xb, yb, xc, yc)
            print(f'X: {x}, y: {y}')
            time.sleep(1)

            # patch_url = f"{server_url}/api/device/coordinate/{device_id}"
            # data = {
            #     "xcoord": x_cm, 
            #     "ycoord": y_cm
            #     }
            # response = requests.patch(patch_url, json=data)
            # print("Response from server:", response.text)
        else:
            print('One or more distances are missing')
    else:
        print('Fail to measure position')
        time.sleep(5)

    time.sleep(20)
