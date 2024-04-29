import { contextBridge, ipcRenderer } from 'electron'
import { electronAPI } from '@electron-toolkit/preload'
import path from 'path';

const userAPI = {
  joinPath: (...paths) => path.join(...paths),
  onNfcData: (callback) => {
      ipcRenderer.on('nfc-data', (event, data) => callback(data));
  },
  removeNfcDataListener: () => {
      ipcRenderer.removeAllListeners('nfc-data');
  },
  onStatus: (type, callback) => {
    ipcRenderer.on(`${type}-status`, (event, data) => callback(data));
  },
  removeStatusListener: (type) => {
    ipcRenderer.removeAllListeners(`${type}-status`);
  }
};

// Use `contextBridge` APIs to expose Electron APIs to
// renderer only if context isolation is enabled, otherwise
// just add to the DOM global.
if (process.contextIsolated) {
  try {
    contextBridge.exposeInMainWorld('electron', electronAPI)
    contextBridge.exposeInMainWorld('userAPI', userAPI)
  } catch (error) {
    console.error(error)
  }
} else {
  window.electron = electronAPI
  window.userAPI = userAPI
}
