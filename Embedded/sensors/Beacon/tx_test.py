from collections import deque
from bluepy.btle import Scanner, DefaultDelegate
import numpy as np
import math
import time
import os
from dotenv import load_dotenv
import requests

load_dotenv()
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

        blending_factor = priori_error_estimate / (priori_error_estimate + self.measurement_variance)
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

def calculate_distance(rssi, rssi_at_one_meter=-59, path_loss_exponent=2):
    if rssi == 0:
        return -1.0

    ratio_db = rssi_at_one_meter - rssi
    distance = 10 ** (ratio_db / (10 * path_loss_exponent))
    return distance

def find_position(distances, beacon_positions):
    def solve_circle_intersection(x1, y1, r1, x2, y2, r2):
        d = math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
        if d > r1 + r2:
            return None  # No solution, the circles are too far apart
        if d < abs(r1 - r2):
            return None  # No solution, one circle is contained within the other

        a = (r1**2 - r2**2 + d**2) / (2 * d)
        h = math.sqrt(r1**2 - a**2)
        x0 = x1 + a * (x2 - x1) / d
        y0 = y1 + a * (y2 - y1) / d
        rx = -(y2 - y1) * (h / d)
        ry = (x2 - x1) * (h / d)
        return (x0 + rx, y0 - ry), (x0 - rx, y0 + ry)

    beacon_keys = list(beacon_positions.keys())
    if len(beacon_keys) < 3:
        return None

    x1, y1 = beacon_positions[beacon_keys[0]]
    r1 = distances[beacon_keys[0]]
    x2, y2 = beacon_positions[beacon_keys[1]]
    r2 = distances[beacon_keys[1]]
    x3, y3 = beacon_positions[beacon_keys[2]]
    r3 = distances[beacon_keys[2]]

    intersections = solve_circle_intersection(x1, y1, r1, x2, y2, r2)
    if intersections is None:
        print(f"No intersections between circles centered at ({x1}, {y1}) and ({x2}, {y2})")
        return weighted_average_position(distances, beacon_positions)

    possible_positions = [p for p in intersections if math.isclose(math.sqrt((p[0] - x3)**2 + (p[1] - y3)**2), r3, rel_tol=0.1)]

    if len(possible_positions) == 0:
        print(f"No valid intersections for third circle at ({x3}, {y3}) with radius {r3}")
        return weighted_average_position(distances, beacon_positions)
    elif len(possible_positions) == 1:
        return possible_positions[0]
    else:
        x_guess = np.mean([p[0] for p in possible_positions])
        y_guess = np.mean([p[1] for p in possible_positions])
        return (x_guess, y_guess)

def weighted_average_position(distances, beacon_positions):
    total_weight = sum(1/d for d in distances.values())
    x_weighted_sum = sum(beacon_positions[key][0] / d for key, d in distances.items())
    y_weighted_sum = sum(beacon_positions[key][1] / d for key, d in distances.items())
    x = x_weighted_sum / total_weight
    y = y_weighted_sum / total_weight
    print(f"Using weighted average position: X = {x:.2f}, Y = {y:.2f}")
    return x, y

def send_position(position):
    x, y = position
    patch_url = f"{server_url}/api/device/coordinate/{device_id}"
    data = {
        "xcoord": x, 
        "ycoord": y
    }
    response = requests.patch(patch_url, json=data)
    print("Response from server:", response.text)

def calculate_distance_moved(pos1, pos2):
    return math.sqrt((pos1[0] - pos2[0])**2 + (pos1[1] - pos2[1])**2)

device_id = get_serial_number()

# 비콘 좌표 설정 (삼각형 배치)
beacon_positions = {
    'MOASS_1': (0, 0),    # 강의실 좌상단 모서리
    'MOASS_2': (262, 0),  # 강의실 우상단 모서리
    'MOASS_3': (0, 295)   # 강의실 좌하단 모서리
}

rssi_smoother = RSSISmoother(window_size=5)
scanner = Scanner().withDelegate(ScanDelegate())

last_position = None
threshold_distance = 50.0  # 좌표 변화 임계값 (cm)

# 실험을 통해 적절한 path_loss_exponent 값을 찾기 위해 여러 번 실행해보세요.
path_loss_exponent = 2.5  # 경로 손실 지수 (실험적으로 결정해야 함)

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
    rssi_at_one_meter = -59  # 1미터 거리에서의 RSSI 값 (실험적으로 결정해야 함)

    for dev in devices:
        if dev.addr.lower() in [mac.lower() for mac in beacon_addresses.values()]:
            beacon_id = [key for key, value in beacon_addresses.items() if value.lower() == dev.addr.lower()][0]
            smooth_rssi = rssi_smoother.add_rssi(beacon_id, dev.rssi)
            rssi_values[beacon_id] = smooth_rssi
            distances[beacon_id] = calculate_distance(smooth_rssi, rssi_at_one_meter, path_loss_exponent)
            print(f'{beacon_id}: {distances[beacon_id]:.2f} meters')

    if len(distances) == 3:
        try:
            position = find_position(distances, beacon_positions)
            if position:
                x_cm, y_cm = int(position[0]), int(position[1])
                print(f'Computed coordinates: X = {x_cm}, Y = {y_cm}')

                if last_position is None:
                    # send_position((x_cm, y_cm))
                    last_position = (x_cm, y_cm)
                else:
                    distance_moved = calculate_distance_moved(last_position, (x_cm, y_cm))
                    if distance_moved > threshold_distance:
                        # send_position((x_cm, y_cm))
                        last_position = (x_cm, y_cm)
        except RuntimeError as e:
            print(f"Position optimization failed: {e}")
    else:
        print('Fail to measure position')

    time.sleep(20)
