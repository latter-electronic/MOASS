import { app, shell, BrowserWindow, ipcMain } from 'electron'
import { join } from 'path'
import { electronApp, optimizer, is } from '@electron-toolkit/utils'
import { spawn } from 'child_process';
import icon from '../../resources/icon.png?asset'

let mainWindow;

function createWindow() {
  // Create the browser window.
  const mainWindow = new BrowserWindow({
    title: 'MOASS',
    width: 1600,
    height: 600,
    // fullscreen: true, // 전체 화면 모드
    show: false,
    autoHideMenuBar: true,
    ...(process.platform === 'linux' ? { icon } : {}),
    webPreferences: {
      preload: join(__dirname, '../preload/index.js'),
      sandbox: false,
      nodeIntegration: true,
      contextIsolation: false
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

  setupPythonProcess(mainWindow)
}

// python script 실행
function setupPythonProcess(mainWindow) {
  // 'linux' 플랫폼에서만 Python 스크립트 실행
  if (process.platform === 'linux') {
    const pythonProcess = spawn('python', [join(__dirname, '../../sensors/sensor_data.py')]);

    pythonProcess.stdout.on('data', (data) => {
      const output = data.toString().trim();
      console.log(`stdout: ${output}`);
      
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

  // Default open or close DevTools by F12 in development
  // and ignore CommandOrControl + R in production.
  // see https://github.com/alex8088/electron-toolkit/tree/master/packages/utils
  app.on('browser-window-created', (_, window) => {
    optimizer.watchWindowShortcuts(window)
  })

  // IPC test
  ipcMain.on('ping', () => console.log('pong'))

  createWindow()

  app.on('activate', function () {
    // On macOS it's common to re-create a window in the app when the
    // dock icon is clicked and there are no other windows open.
    if (BrowserWindow.getAllWindows().length === 0) createWindow()
  })
})

// Quit when all windows are closed, except on macOS. There, it's common
// for applications and their menu bar to stay active until the user quits
// explicitly with Cmd + Q.
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

// In this file you can include the rest of your app"s specific main process
// code. You can also put them in separate files and require them here.
