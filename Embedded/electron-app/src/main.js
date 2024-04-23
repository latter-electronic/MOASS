const { app, BrowserWindow } = require('electron') 
const path = require('path') 
function createWindow () { 
  const win = new BrowserWindow({ 
    title: "MOASS",
    width: 1600, 
    height: 600, 
    // fullscreen: true,   // 전체 화면 설정
    webPreferences: { 
      nodeIntegration: true,
      contextIsolation : false
    },
    autoHideMenuBar: true  // 메뉴 바 자동 숨기기 
  }) 
  win.loadURL("http://localhost:3000")
} 
app.whenReady().then(() => { 
  createWindow() 
}) 
app.on('window-all-closed', function () { 
  if (process.platform !== 'darwin') app.quit() 
})