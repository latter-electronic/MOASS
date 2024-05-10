// AuthStore.js
import { create } from 'zustand';
import useGlobalStore from './useGlobalStore.js'; // GlobalStore 가져오기

const AuthStore = create((set) => ({
  isAuthenticated: false, // 로그인 상태
  accessToken: '',
  refreshToken: '',
  deviceId: '',
  cardSerialId: '',

  login: (accessToken, refreshToken, deviceId, cardSerialId) =>
    set({
      isAuthenticated: true,
      accessToken,
      refreshToken,
      deviceId,
      cardSerialId,
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
    });
  },

  checkStoredAuth: () => {
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

      // 사용자 정보 불러오기
      const fetchUserInfo = useGlobalStore.getState().fetchUserInfo;
      fetchUserInfo();
    } else {
      set({ isAuthenticated: false });
    }
  },
}));

export default AuthStore;
