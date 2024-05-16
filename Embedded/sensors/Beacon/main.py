from collections import deque
from bluepy.btle import Scanner, DefaultDelegate
import numpy as np
import math
import requests
import time
import os
from dotenv import load_dotenv
from scipy.optimize import minimize

load_dotenv()  # 환경 변수 로드
server_url = os.getenv('SERVER_URL')

class ScanDelegate(DefaultDelegate):
    def __init__(self):
        DefaultDelegate.__init__(self)

class KalmanFilter:
    def __init__(self, process_variance=1e-2, measurement_variance=1):
        self.process_variance = process_variance
        self.measurement_variance = measurement_variance
        self.posteri_estimate = 0.0
        self.posteri_error_estimate = 1.0

    def update(self, measurement):
        priori_estimate = self.posteri_estimate
        priori_error_estimate = self.posteri_error_estimate + self.process_variance

        blending_factor = priori_error_estimate / (priori_estimate + self.measurement_variance)
        self.posteri_estimate = priori_estimate + blending_factor * (measurement - priori_estimate)
        self.posteri_error_estimate = (1 - blending_factor) * priori_error_estimate

        return self.posteri_estimate

class RSSISmoother:
    def __init__(self, window_size=10):
        self.rssi_queues = {}
        self.window_size = window_size
        self.filters = {}

    def add_rssi(self, beacon_id, rssi):
        if beacon_id not in self.rssi_queues:
            self.rssi_queues[beacon_id] = deque(maxlen=self.window_size)
            self.filters[beacon_id] = KalmanFilter()

        filtered_rssi = self.filters[beacon_id].update(rssi)
        self.rssi_queues[beacon_id].append(filtered_rssi)
        return np.mean(self.rssi_queues[beacon_id])

def get_serial_number():
    with open('/proc/cpuinfo', 'r') as f:
        for line in f:
            if line.startswith('Serial'):
                return line.split(':')[1].strip()
    return None

def calculate_distance(rssi, tx_power):
    if rssi == 0:
        return -1.0

    ratio_db = tx_power - rssi
    ratio_linear = 10 ** (ratio_db / 10)
    distance = math.sqrt(ratio_linear)
    return distance

def find_position(dist_a, dist_b, dist_c, xa, ya, xb, yb, xc, yc):
    def objective(p):
        x, y = p
        return ((x - xa)**2 + (y - ya)**2 - dist_a**2)**2 + \
               ((x - xb)**2 + (y - yb)**2 - dist_b**2)**2 + \
               ((x - xc)**2 + (y - yc)**2 - dist_c**2)**2

    x_guess = (xa + xb + xc) / 3
    y_guess = (ya + yb + yc) / 3
    initial_guess = [x_guess, y_guess]

    result = minimize(objective, initial_guess, method='L-BFGS-B')

    if result.success:
        optimized_x, optimized_y = result.x
        return optimized_x, optimized_y
    else:
        raise RuntimeError("Optimization failed: " + result.message)

def send_position(x, y):
    patch_url = f"{server_url}/api/device/coordinate/{device_id}"
    data = {
        "xcoord": x, 
        "ycoord": y
    }
    response = requests.patch(patch_url, json=data)
    print("Response from server:", response.text)

def calculate_distance_moved(pos1, pos2):
    return math.sqrt((pos1[0] - pos2[0]) ** 2 + (pos1[1] - pos2[1]) ** 2)

# --------------------------------------------------------------------------------------------------

device_id = get_serial_number()

# 비콘 좌표 (삼각형 배치)
xa, ya = 0, 0      # MOASS_1: 강의실 좌상단 모서리
xb, yb = 942, 1495    # MOASS_2: 강의실 우상단 모서리
xc, yc = 0, 1495   # MOASS_3: 강의실 좌하단 모서리

# xa, ya = 0, 0      # MOASS_1: 강의실 좌상단 모서리
# xb, yb = 262, 0    # MOASS_2: 강의실 우상단 모서리
# xc, yc = 0, 295   # MOASS_3: 강의실 좌하단 모서리

rssi_smoother = RSSISmoother(window_size=5)
scanner = Scanner().withDelegate(ScanDelegate())

# 초기 좌표 설정
last_position = None
threshold_distance = 50.0  # 좌표 변화 임계값 (cm)

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

        if None not in [dist_a, dist_b, dist_c]:  # Ensure all distances are available
            x, y = find_position(dist_a, dist_b, dist_c, xa, ya, xb, yb, xc, yc)

            x_cm = int(x)  # 소수점 제거
            y_cm = int(y)  # 소수점 제거
            print(f'Computed coordinates: X = {x_cm}, Y = {y_cm}')

            if last_position is None:
                # 초기 실행 시 좌표 전송
                send_position(x_cm, y_cm)
                last_position = (x_cm, y_cm)
            else:
                # 좌표 변화가 임계값을 초과할 경우에만 전송
                distance_moved = calculate_distance_moved(last_position, (x_cm, y_cm))
                if distance_moved > threshold_distance:
                    send_position(x_cm, y_cm)
                    last_position = (x_cm, y_cm)
        else:
            print('One or more distances are missing')
    else:
        print('Fail to measure position')

    time.sleep(20)