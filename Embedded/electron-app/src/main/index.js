// main/index.js
import { app, shell, BrowserWindow, ipcMain } from 'electron'
import { join } from 'path'
import { electronApp, optimizer, is } from '@electron-toolkit/utils'
import { spawn } from 'child_process';
import readline from 'readline';
import icon from '../../resources/icon.png?asset'

let pythonProcess = null;

function createWindow() {
  const mainWindow = new BrowserWindow({
    title: 'MOASS',
    // width: 1600,
    // height: 600,
    fullscreen: true, // 전체 화면 모드
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

  if (is.dev && process.env['ELECTRON_RENDERER_URL']) {
    mainWindow.loadURL(process.env['ELECTRON_RENDERER_URL'])
  } else {
    mainWindow.loadFile(join(__dirname, '../renderer/index.html'))
  }

  setupPythonProcess(mainWindow)
}

// python script 실행
function setupPythonProcess(mainWindow) {
  // 'linux' 플랫폼에서만 Python 스크립트 실행
  if (process.platform === 'linux') {
    pythonProcess = spawn('python', [join(__dirname, '../../sensors/sensor_data.py')], { encoding: 'utf8' });

    const readlineSensorData = readline.createInterface({
      input: pythonProcess.stdout,
    });

    readlineSensorData.on('line', (data) => {
      console.log(`Received Sensor Data: ${data.toString('utf8')}`);
      if (!mainWindow.isDestroyed()) { // mainWindow가 파괴되지 않았는지 확인
        try {
          const message = JSON.parse(data.toString());
          console.log(message.data)
          switch (message.type) {
            case 'NFC_DATA':
              mainWindow.webContents.send('nfc-data', message.data) // nfc-data 전송
              break
            case 'MOTION_DETECTED':
              mainWindow.webContents.send('motion-detected', message.data)  // motion-detected 전송
              break
            default:
              console.log('Received unknown message type:', message.type)
          }
        } catch (error) {
          console.error('Error parsing data from Python:', error)
        }
      }
    });

    pythonProcess.stderr.on('data', (data) => {
      console.log('Python log:', data.toString());  // 에러 출력
    });

    pythonProcess.on('close', (code) => {
        console.log(`child process exited with code ${code}`);
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

  // IPC test
  // ipcMain.on('ping', (event) => {
  //   console.log('pong')
  //   event.reply('pong', 'This is a message from the main process.')
  // })

  createWindow()

  if (process.platform === 'linux') {
    ipcMain.on('login-success', (event, data) => {
      console.log('Login success data received:', data);
      if (pythonProcess && pythonProcess.stdin.writable) {
          pythonProcess.stdin.write(JSON.stringify({action: data}) + '\n');
      } else {
        console.log('Python process is not available or not writable.');
      }
    })

    ipcMain.on('logout-success', (event, data) => {
      console.log('Logout success data received:', data);
      if (pythonProcess && pythonProcess.stdin.writable) {
          pythonProcess.stdin.write(JSON.stringify({action: data}) + '\n');
      } else {
        console.log('Python process is not available or not writable.');
      }
    })
}

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
