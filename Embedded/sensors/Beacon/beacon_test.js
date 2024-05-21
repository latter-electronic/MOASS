const noble = require('@abandonware/noble');

const targetId = 'c300001c6ee3';

noble.on('stateChange', async (state) => {
  if (state === 'poweredOn') {
    await noble.startScanningAsync([], true); // 모든 서비스 UUID에 대해 스캔
    console.log('Scanning...');
  } else {
    await noble.stopScanningAsync();
    console.log('Scanner stopped.');
  }
});

noble.on('discover', (peripheral) => {
  const { id, rssi, address, advertisement } = peripheral;
  if (id === targetId) {
    const localName = advertisement.localName || 'Beacon01'; // 비콘의 이름
    const manufacturerData = advertisement.manufacturerData ? advertisement.manufacturerData.toString('hex') : 'None'; // 제조사 데이터
    console.log(`Found Device: ${localName}, ID: ${id}, Address: ${address}, RSSI: ${rssi}, Manufacturer Data: ${manufacturerData}`);
  }
});
