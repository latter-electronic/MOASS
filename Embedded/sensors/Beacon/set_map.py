# DamaskRose
# 자동 좌석도 생성 기능
from collections import deque
from bluepy.btle import Scanner, DefaultDelegate
import numpy as np
import math
import requests
import time

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

def calculate_distance(rssi, tx_power):
    if rssi == 0:
        return -1.0
    ratio = rssi * 1.0 / tx_power
    if ratio < 1.0:
        return ratio ** 10
    else:
        return (0.89976) * (ratio ** 7.7095) + 0.111

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

def convert_to_grid(x, y, room_width, room_height, desk_width, desk_height):
    # 강의실 및 책상 크기 기준에 따른 격자 변환
    grid_x = int(x / room_width * (room_width / desk_width))
    grid_y = int(y / room_height * (room_height / desk_height))
    return grid_x, grid_y

def print_grid_dimensions(room_width, room_height, desk_width, desk_height):
    grid_columns = int(room_width / desk_width)
    grid_rows = int(room_height / desk_height)
    print("Grid Dimensions: {} columns x {} rows".format(grid_columns, grid_rows))

# --------------------------------------------------------------------------------------------------

# 강의실, 책상 크기(cm)
room_width = 942
room_height = 1495 
desk_width = 85
desk_height = 85 

# 비콘 좌표
xa, ya = 0, 747.5   # MOASS_1
xb, yb = 942, 0     # MOASS_2
xc, yc = 942, 1495  # MOASS_3

rssi_smoother = RSSISmoother(window_size=5)
scanner = Scanner().withDelegate(ScanDelegate())

while True:
    print('Scanning....')
    devices = scanner.scan(10.0)

    distances = {}
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
            distances[beacon_id] = calculate_distance(smooth_rssi, tx_power)
            print(f'{beacon_id}: {distances[beacon_id]:.2f} meters')

    if len(distances) == 3:
        dist_a = distances.get('MOASS_1', None)
        dist_b = distances.get('MOASS_2', None)
        dist_c = distances.get('MOASS_3', None)

        if None not in [dist_a, dist_b, dist_c]:  # Ensure all distances are available
            x, y = get_coordinates(dist_a, dist_b, dist_c, xa, ya, xb, yb, xc, yc)
            print(f'X: {x}, y: {y}')
            grid_x, grid_y = convert_to_grid(x, y, room_width, room_height, desk_width, desk_height)
            print("Grid Position: (", grid_x, ",", grid_y, ")")
            print_grid_dimensions(room_width, room_height, desk_width, desk_height)
            time.sleep(5)
            # Optional: POST to REST API
            # api_url = "http://yourserver.com/api/positions"
            # data = {"grid_x": grid_x, "grid_y": grid_y}
            # response = requests.post(api_url, json=data)
            # print("Response from server:", response.text)
        else:
            print('One or more distances are missing')
    else:
        print('Fail to measure position')
        time.sleep(5)
