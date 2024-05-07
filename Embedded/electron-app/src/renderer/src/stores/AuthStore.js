// src/store/useAuthStore.js

/* 인증 관련 상태를 관리
로그인, 로그아웃, 사용자 인증 상태 확인 등 인증과 관련된 상태 관리*/
import { create } from 'zustand'

const AuthStore = create(set => ({
  isAuthenticated: false,  // 로그인 상태
  accessToken: '',
  refreshToken: '',
  deviceId: '',
  cardSerialId: '',

  login: (accessToken, refreshToken, deviceId, cardSerialId) => set({
    isAuthenticated: true,
    accessToken,
    refreshToken,
    deviceId,
    cardSerialId
  }),

  logout: () => set({
    isAuthenticated: false,
    accessToken: null,
    refreshToken: null,
    deviceId: null,
    cardSerialId: null
  })
}));

export default AuthStore;
