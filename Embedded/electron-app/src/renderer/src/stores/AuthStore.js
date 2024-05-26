  // AuthStore.js
  import { create } from 'zustand';
  import useGlobalStore from './useGlobalStore.js';

  const AuthStore = create((set) => ({
    isAuthenticated: false,
    accessToken: '',
    refreshToken: '',
    deviceId: '',
    cardSerialId: '',
    isCheckingAuth: true,

    login: (accessToken, refreshToken, deviceId, cardSerialId) => {
      localStorage.setItem('accessToken', accessToken);
      localStorage.setItem('refreshToken', refreshToken);
      localStorage.setItem('deviceId', deviceId);
      localStorage.setItem('cardSerialId', cardSerialId);

      set({
        isAuthenticated: true,
        accessToken,
        refreshToken,
        deviceId,
        cardSerialId,
        isCheckingAuth: false,
      });
      useGlobalStore.getState().fetchUserInfo();
    },

    logout: () => {
      localStorage.removeItem('accessToken');
      localStorage.removeItem('refreshToken');
      localStorage.removeItem('deviceId');
      localStorage.removeItem('cardSerialId');
      localStorage.removeItem('userId');

      set({
        isAuthenticated: false,
        accessToken: null,
        refreshToken: null,
        deviceId: null,
        cardSerialId: null,
        isCheckingAuth: false,
      });

      if (window.electron && window.electron.ipcRenderer) {
        window.electron.ipcRenderer.send('logout-success', 'logout');
        console.log('로그아웃 신호 스토어에서 전송')
      }
    },

    checkStoredAuth: async () => {
      const { fetchUserInfo } = useGlobalStore.getState();
      set({ isCheckingAuth: true });
      const accessToken = localStorage.getItem('accessToken');
      const refreshToken = localStorage.getItem('refreshToken');
      const deviceId = localStorage.getItem('deviceId');
      const cardSerialId = localStorage.getItem('cardSerialId');

      if (accessToken && refreshToken && deviceId && cardSerialId) {
        set({
          isAuthenticated: true,
          accessToken,
          refreshToken,
          deviceId,
          cardSerialId,
        });
        await fetchUserInfo();
      } else {
        set({ isAuthenticated: false });
      }
      set({ isCheckingAuth: false });
    },

    updateAccessToken: (newAccessToken) => {
      localStorage.setItem('accessToken', newAccessToken);
      set({ accessToken: newAccessToken });
    },
  }));

  export default AuthStore;
