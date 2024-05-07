import { app, shell, BrowserWindow, ipcMain } from 'electron'
import { join } from 'path'
import { electronApp, optimizer, is } from '@electron-toolkit/utils'
import { spawn } from 'child_process';
import readline from 'readline';
import icon from '../../resources/icon.png?asset'

function createWindow() {
  // Create the browser window.
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

  // HMR for renderer base on electron-vite cli.
  // Load the remote URL for development or the local html file for production.
  if (is.dev && process.env['ELECTRON_RENDERER_URL']) {
    mainWindow.loadURL(process.env['ELECTRON_RENDERER_URL'])
  } else {
    mainWindow.loadFile(join(__dirname, '../renderer/index.html'))
  }

  const pythonTest = spawn('python', [join(__dirname, '../../sensors/ipc_test.py')], { encoding: 'utf8' });
  const rl = readline.createInterface({
    input: pythonTest.stdout,
  });

  rl.on('line', (data) => {
    console.log(`Received line: ${data.toString('utf8')}`);
    if (!mainWindow.isDestroyed()) { // mainWindow가 파괴되지 않았는지 확인
      mainWindow.webContents.send('fromPython', data.toString('utf8'));
    }
  });

  pythonTest.stderr.on('data', (data) => {
    console.error(`stderr: ${data}`);
  });

  pythonTest.on('close', (code) => {
    console.log(`child process exited with code ${code}`);
  });

  setupPythonProcess(mainWindow)
}

// python script 실행
function setupPythonProcess(mainWindow) {
  // 'linux' 플랫폼에서만 Python 스크립트 실행
  if (process.platform === 'linux') {
    const pythonProcess = spawn('python', [join(__dirname, '../../sensors/sensor_data.py')], { encoding: 'utf8' });

    const readlineSensorData = readline.createInterface({
      input: pythonTest.stdout,
    });

    readlineSensorData.on('line', (data) => {
      const output = data.toString('utf8').trim();
      console.log(`stdout: ${output}`);
      if (!mainWindow.isDestroyed()) { // mainWindow가 파괴되지 않았는지 확인
        try {
          // 데이터를 JSON으로 파싱
          const jsonData = JSON.parse(output);
          console.log(jsonData);
          // 로그인 성공 메시지 처리
          if (jsonData.status === 200) {
            mainWindow.webContents.send('nfc-data', jsonData.data);
            console.log('login success');  
          } else if (["AWAY", "AOD", "LONG_SIT"].includes(jsonData.type)) { // 메시지에 따라 다른 이벤트 전송
            mainWindow.webContents.send(`${jsonData.type.toLowerCase()}-status`, jsonData.type);
          }
        } catch (error) {
          console.error('Error parsing JSON:', error);
        }
      }
    });

    pythonProcess.stderr.on('data', (data) => {
      console.log('Python log:', data.toString());  // stderr를 통해 로그 출력
    });

    pythonProcess.on('close', (code) => {
        console.log(`child process exited with code ${code}`);
    });
  } else {
    console.log('Python script is not supported on this platform.')
  }
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.whenReady().then(() => {
  // Set app user model id for windows
  electronApp.setAppUserModelId('com.electron')

  app.on('browser-window-created', (_, window) => {
    optimizer.watchWindowShortcuts(window)
  })

  // IPC test
  // ipcMain.on('ping', () => console.log('pong'))
  ipcMain.on('ping', (event) => {
    console.log('pong')
    event.reply('pong', 'This is a message from the main process.') // event.sender.send('pong', ...)로도 가능
  })

  createWindow()

  app.on('activate', function () {
    // On macOS it's common to re-create a window in the app when the
    // dock icon is clicked and there are no other windows open.
    if (BrowserWindow.getAllWindows().length === 0) createWindow()
  })
})

// explicitly with Cmd + Q.
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})
