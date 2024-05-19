// main/index.js
import { app, shell, BrowserWindow, ipcMain, screen } from 'electron'
import { join } from 'path'
import { electronApp, optimizer, is } from '@electron-toolkit/utils'
import { spawn } from 'child_process';
import readline from 'readline';
import icon from '../../resources/icon.png?asset'

// 라즈베리파이에서만 하드웨어 가속 비활성화
// if (process.platform === 'linux' && require('fs').existsSync('/etc/rpi-issue')) {
//   app.disableHardwareAcceleration();
// }

let mainWindow = null
let secondWindow = null
let pythonProcess = null

function createWindow() {
  const primaryDisplay = screen.getPrimaryDisplay()
  const externalDisplays = screen.getAllDisplays().filter((display) => display.id !== primaryDisplay.id)
  console.log('externalDisplay:', externalDisplays)
  // 메인 윈도우 설정
  mainWindow = new BrowserWindow({
    title: 'MOASS',
    width: 1600,
    height: 600,
    fullscreen: process.platform === 'linux', // 전체 화면 모드
    show: false,
    autoHideMenuBar: true,
    ...(process.platform === 'linux' ? { icon } : {}),
    webPreferences: {
      preload: join(__dirname, '../preload/index.js'),
      sandbox: false,
      nodeIntegration: true,
      contextIsolation: false,
    }
  })

  mainWindow.on('ready-to-show', () => {
    mainWindow.show()
  })

  mainWindow.webContents.setWindowOpenHandler((details) => {
    shell.openExternal(details.url)
    return { action: 'deny' }
  })

  const mainWindowURL = is.dev ? process.env['ELECTRON_RENDERER_URL'] : `file://${join(__dirname, '../renderer/index.html')}`;
  mainWindow.loadURL(mainWindowURL);

  // 라즈베리파이에서만 추가 디스플레이 처리
  if (process.platform === 'linux' && externalDisplays.length > 0){
    createSecondWindow(externalDisplays[0])
  }

  ipcMain.on('user-updated', (event, user) => {
    if (mainWindow) {
      mainWindow.webContents.send('user-updated', user);
    }
    if (secondWindow) {
      secondWindow.webContents.send('user-updated', user);
    }
  });

  setupPythonProcess(mainWindow, secondWindow)
}

function createSecondWindow(display) {
  // 두 번째 윈도우 설정
  secondWindow = new BrowserWindow({
    title: 'Name Space',
    width: 1600,
    height: 600,
    fullscreen: process.platform === 'linux', // 전체 화면 모드
    x: display.bounds.x,
    y: display.bounds.y,
    show: false,
    autoHideMenuBar: true,
    webPreferences: {
      preload: join(__dirname, '../preload/index.js'),
      sandbox: false,
      nodeIntegration: true,
      contextIsolation: false,
    }
  });

  secondWindow.on('ready-to-show', () => {
    secondWindow.show();
  });

  const secondWindowURL = is.dev ? `${process.env['ELECTRON_RENDERER_URL']}#/nameplate` : `file://${join(__dirname, '../renderer/index.html')}#/nameplate`;
  secondWindow.loadURL(secondWindowURL);
}

// python script 실행
function setupPythonProcess(mainWindow, secondWindow) {
  // 'linux' 플랫폼에서만 Python 스크립트 실행
  if (process.platform === 'linux') {
    const pythonPath = '/home/pi/myenv/bin/python'
    const scriptPath = join(__dirname, '../../sensors/sensor_data.py')
    const pythonProcess = spawn(pythonPath, [scriptPath], { encoding: 'utf8' })


    pythonProcess.on('error', (err) => {
      console.error('Failed to start Python process:', err)
    });

    pythonProcess.stdout.on('data', (data) => {
      console.log(`Python stdout: ${data.toString('utf8')}`)
    });

    pythonProcess.stderr.on('data', (data) => {
      console.error(`Python stderr:', ${data.toString('utf8')}`)
    })

    pythonProcess.on('close', (code) => {
      console.log(`Python process exited with code ${code}`)
    })

    const readlineSensorData = readline.createInterface({
      input: pythonProcess.stdout,
    })
    
    readlineSensorData.on('line', (data) => {
      const dataStr = data.toString('utf8').trim()
      console.log(`Received Sensor Data: ${dataStr}`)
    
      if (!mainWindow.isDestroyed()) { // mainWindow가 파괴되지 않았는지 확인
        try {
          // JSON 형식인지 확인
          if (dataStr.startsWith('{') && dataStr.endsWith('}')) {
            const message = JSON.parse(dataStr);
            switch (message.type) {
              case 'NFC_DATA':
                mainWindow.webContents.send('nfc-data', message.data); // nfc-data 전송
                break;
              case 'MOTION_DETECTED':
                mainWindow.webContents.send('motion-detected', message.data); // motion-detected 전송
                break;
              default:
                console.log('Received unknown message type:', message.type);
            }
          } else {
            console.log(`Non-JSON data received and ignored: ${dataStr}`);
          }
        } catch (error) {
          console.error('Error parsing data from Python:', error);
        }
      }
    });
    

    ipcMain.on('login-success', (event, data) => {
      if (secondWindow) {
        secondWindow.webContents.send('login-success', data);
      }
      console.log('Login success data received:', data);
      if (pythonProcess && pythonProcess.stdin && pythonProcess.stdin.writable) {
        console.log('Writing to Python process stdin:', JSON.stringify({ action: data }));
        pythonProcess.stdin.write(JSON.stringify({ action: data }) + '\n');
      } else {
        console.log('Python process is not available or not writable.');
        if (!pythonProcess) {
          console.error('Python process is null.');
        } else if (!pythonProcess.stdin) {
          console.error('Python process stdin is null.');
        } else {
          console.error(`Python process stdin writable: ${pythonProcess.stdin.writable}`);
        }
      }
    });

    ipcMain.on('logout-success', (event, data) => {
      console.log('Logout success data received:', data);
      if (pythonProcess && pythonProcess.stdin && pythonProcess.stdin.writable) {
        console.log('Writing to Python process stdin:', JSON.stringify({ action: data }));
        pythonProcess.stdin.write(JSON.stringify({ action: data }) + '\n');
      } else {
        console.log('Python process is not available or not writable.');
        if (!pythonProcess) {
          console.error('Python process is null.');
        } else if (!pythonProcess.stdin) {
          console.error('Python process stdin is null.');
        } else {
          console.error(`Python process stdin writable: ${pythonProcess.stdin.writable}`);
        }
      }
    });
  } else {
    console.log('Python script is not supported on this platform.')
  }
}

app.whenReady().then(() => {
  electronApp.setAppUserModelId('com.electron')

  app.on('browser-window-created', (_, window) => {
    optimizer.watchWindowShortcuts(window)
  })

  createWindow()
  const primaryDisplay = screen.getPrimaryDisplay()
  console.log('Primary Display:', primaryDisplay)

  app.on('activate', function () {
    if (BrowserWindow.getAllWindows().length === 0) createWindow()
  })
})

// explicitly with Cmd + Q.
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})
