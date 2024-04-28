// src/store/useAuthStore.js

/* 인증 관련 상태를 관리
로그인, 로그아웃, 사용자 인증 상태 확인 등 인증과 관련된 상태 관리*/
import create from 'zustand'

const useAuthStore = create(set => ({
  isAuthenticated: false,  // 로그인 상태
  accessToken: null,  // 액세스 토큰
  refreshToken: null, // 리프레시 토큰

  // 로그인 상태 설정
  login: (accessToken, refreshToken) => set({
    isAuthenticated: true,
    accessToken,
    refreshToken
  }),

  // 로그아웃 상태 설정
  logout: () => set({
    isAuthenticated: false,
    accessToken: null,
    refreshToken: null
  })
}));

export default useAuthStore;
