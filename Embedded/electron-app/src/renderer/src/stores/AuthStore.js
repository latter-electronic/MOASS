// AuthStore.js
import { create } from 'zustand';
import useGlobalStore from './useGlobalStore.js';

const AuthStore = create((set) => ({
  isAuthenticated: false, // 로그인 상태
  accessToken: '',
  refreshToken: '',
  deviceId: '',
  cardSerialId: '',
  isCheckingAuth: true, // 로그인 상태 확인 중인지 나타내는 변수

  login: (accessToken, refreshToken, deviceId, cardSerialId) =>
    set({
      isAuthenticated: true,
      accessToken,
      refreshToken,
      deviceId,
      cardSerialId,
      isCheckingAuth: false, // 확인 완료
    }),

  logout: () => {
    localStorage.removeItem('accessToken');
    localStorage.removeItem('refreshToken');
    localStorage.removeItem('deviceId');
    localStorage.removeItem('cardSerialId');

    set({
      isAuthenticated: false,
      accessToken: null,
      refreshToken: null,
      deviceId: null,
      cardSerialId: null,
      isCheckingAuth: false, // 확인 완료
    });
  },

  checkStoredAuth: async () => {
    const { fetchUserInfo } = useGlobalStore.getState();
    set({ isCheckingAuth: true }); // 확인 시작
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
    set({ isCheckingAuth: false }); // 확인 완료
  },
}));

export default AuthStore;
