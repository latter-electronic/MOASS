import nfc
import ndef
from nfc.clf import ContactlessFrontend

def write_to_tag(tag, user_id):
    if tag.ndef:
        # Convert user input to text record
        text_record = ndef.TextRecord(user_id)
        tag.ndef.records = [text_record]
        return True
    return False

def on_connect(tag):
    print(f"Connected to tag with UID: {tag.identifier.hex()}")
    user_id = input("Enter userID to write: ")  # User input for userID
    if write_to_tag(tag, user_id):
        print("Data written successfully.")
    else:
        print("Failed to write data. This tag may not support NDEF.")

def read_write_nfc():
    with ContactlessFrontend('pn532_i2c:/dev/i2c-1') as clf:  # Changed to I2C interface
        while True:
            target = nfc.clf.RemoteTarget("106A")  # Type 2 Tag (NTAG 215)
            tag = clf.connect(rdwr={'on-connect': on_connect, 'targets': [target]})
            if tag.ndef:
                for record in tag.ndef.records:
                    print(f"Read data: {record.text}")
            break

if __name__ == "__main__":
    read_write_nfc()
