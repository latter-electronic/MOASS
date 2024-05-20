import nfc
from time import sleep

def on_connect(tag):
    print(f"UID: {tag.identifier.hex()}")  # 카드의 UID를 16진수로 출력

def read_nfc_uid():
    with nfc.ContactlessFrontend('pn532_i2c:/dev/i2c-1') as clf:  # PN532 모듈의 I2C 포트 경로
        while True:
            print("Approach an NFC tag...")
            target = clf.sense(RemoteTarget("106A"))  # Type 2 Tag (NTAG 215)
            if target:
                tag = clf.connect(rdwr={'on-connect': on_connect})
            sleep(1)  # 반복해서 카드를 탐지하기 위해 잠시 대기

if __name__ == "__main__":
    read_nfc_uid()
