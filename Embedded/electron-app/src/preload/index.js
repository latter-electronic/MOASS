import { contextBridge, ipcRenderer } from 'electron'
import { electronAPI } from '@electron-toolkit/preload'
import path from 'path';

// Custom APIs for renderer
const api = {}

const userAPI = {
  joinPath: (...paths) => path.join(...paths),
  onNfcData: (callback) => {
      ipcRenderer.on('nfc-data', (event, data) => callback(data));
  },
  removeNfcDataListener: () => {
      ipcRenderer.removeAllListeners('nfc-data');
  }
};

// Use `contextBridge` APIs to expose Electron APIs to
// renderer only if context isolation is enabled, otherwise
// just add to the DOM global.
if (process.contextIsolated) {
  try {
    contextBridge.exposeInMainWorld('electron', electronAPI)
    contextBridge.exposeInMainWorld('api', api)
    contextBridge.exposeInMainWorld('userAPI', userAPI)
  } catch (error) {
    console.error(error)
  }
} else {
  window.electron = electronAPI
  window.api = api
  window.userAPI = userAPI
}
