// main/index.js
import { app, shell, BrowserWindow, ipcMain, screen } from 'electron'
import { join } from 'path'
import { electronApp, optimizer, is } from '@electron-toolkit/utils'
import { spawn } from 'child_process';
import readline from 'readline';
import icon from '../../resources/icon.png?asset'

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
    // width: 1600,
    // height: 600,
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

  // if (is.dev && process.env['ELECTRON_RENDERER_URL']) {
  //   mainWindow.loadURL(process.env['ELECTRON_RENDERER_URL'])
  // } else {
  //   mainWindow.loadFile(join(__dirname, '../renderer/index.html'))
  // }

  const mainWindowURL = is.dev ? process.env['ELECTRON_RENDERER_URL'] : `file://${join(__dirname, '../renderer/index.html')}`;
  mainWindow.loadURL(mainWindowURL);

  // 라즈베리파이에서만 추가 디스플레이 처리
  if (process.platform === 'linux' && externalDisplays.length > 0) {
    createSecondWindow(externalDisplays[0])
  }

  // const pythonTest = spawn('python', [join(__dirname, '../../sensors/ipc_test.py')], { encoding: 'utf8' });
  // const rl = readline.createInterface({
  //   input: pythonTest.stdout,
  // });

  // rl.on('line', (line) => {
  //   console.log(`Received line: ${line.toString()}`);
  //   if (!mainWindow.isDestroyed()) { // mainWindow가 파괴되지 않았는지 확인
  //     mainWindow.webContents.send('fromPython', line.toString('utf8'));
  //   }
  // });

  // // pythonTest.stdout.on('data', (data) => {
  // //   console.log(`python data: ${data}`);
  // //   mainWindow.webContents.send('fromPython', data.toString());
  // // });

  // pythonTest.stderr.on('data', (data) => {
  //   console.error(`stderr: ${data}`);
  // });

  // pythonTest.on('close', (code) => {
  //   console.log(`child process exited with code ${code}`);
  // });


  setupPythonProcess(mainWindow)
}

function createSecondWindow(display) {
  // 두 번째 윈도우 설정
  secondWindow = new BrowserWindow({
    title: 'Name Space',
    fullscreen: true, // 전체 화면 모드
    x: display.bounds.x,
    y: display.bounds.y,
    webPreferences: {
      preload: join(__dirname, '../preload/index.js'),
      sandbox: false,
      nodeIntegration: true,
      contextIsolation: false,
    }
  });

  console.log('xxxxxx: ', display.bounds.x)
  console.log('yyyyyy: ', display.bounds.y)
  console.log(join(__dirname, '../renderer/secondary.html'));

  const secondWindowURL = is.dev ? `${process.env['ELECTRON_RENDERER_URL']}#/nameplate` : `file://${join(__dirname, '../renderer/index.html')}#/nameplate`;
  secondWindow.loadURL(secondWindowURL);

  // secondWindow.loadFile(join(__dirname, '../renderer/secondary.html')).then(() => {
  //   secondWindow.webContents.send('navigate', '/nameplate');
  // });
}

// python script 실행
function setupPythonProcess(mainWindow) {
  // 'linux' 플랫폼에서만 Python 스크립트 실행
  if (process.platform === 'linux') {
    const pythonPath = '/home/pi/myenv/bin/python';
    const scriptPath = join(__dirname, '../../sensors/sensor_data.py');
    const pythonProcess = spawn(pythonPath, [scriptPath], { encoding: 'utf8' });

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
  const primaryDisplay = screen.getPrimaryDisplay()
  console.log('Primary Display:', primaryDisplay)

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
