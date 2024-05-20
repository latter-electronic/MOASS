# DamaskRose

import board
import busio
import time
from adafruit_pn532.i2c import PN532_I2C

# I2C 연결 설정
i2c = busio.I2C(board.SCL, board.SDA)

# PN532 모듈 초기화
pn532 = PN532_I2C(i2c, debug=False)

# SAM 구성
pn532.SAM_configuration()

print("Waiting for NFC card...")
while True:
    # 카드의 UID 읽기
    uid = pn532.read_passive_target(timeout=0.5)
    if uid is not None:
        card_uid = ''.join(["{0:x}".format(i).zfill(2) if i !=0 else '00' for i in uid])
        print("card UID:", card_uid)
        time.sleep(1)
