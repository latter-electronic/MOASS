// src/store/useAuthStore.js

/* 인증 관련 상태를 관리
로그인, 로그아웃, 사용자 인증 상태 확인 등 인증과 관련된 상태 관리*/
import { create } from 'zustand'

const AuthStore = create(set => ({
  isAuthenticated: false,  // 로그인 상태
  accessToken: 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMDU4NzA2IiwidXNlckVtYWlsIjoiZGlkdWVkaWR1ZUBuYXZlci5jb20iLCJ1c2VySWQiOiIxMDU4NzA2IiwidXNlck5hbWUiOiLshJzsp4DsiJgiLCJqb2JDb2RlIjoxLCJ0ZWFtQ29kZSI6IkUyMDMiLCJpYXQiOjE3MTQ3MTY3OTYsImV4cCI6MTcxNDcyNzU5Nn0.1mz4_pH6qACdjwdngAX-GiGz2TTgqFPkz4ehyGRhHZU',  // 액세스 토큰
  refreshToken: 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMDU4NzA2IiwidXNlckVtYWlsIjoiZGlkdWVkaWR1ZUBuYXZlci5jb20iLCJ1c2VySWQiOiIxMDU4NzA2IiwidXNlck5hbWUiOiLshJzsp4DsiJgiLCJqb2JDb2RlIjoxLCJ0ZWFtQ29kZSI6IkUyMDMiLCJpYXQiOjE3MTQ3MTY3OTYsImV4cCI6MTcxNTMyMTU5Nn0.YHzyhefYDjnvcBswvd50PMR613IRFCncGh0F8PAQ-sI', // 리프레시 토큰

  login: (accessToken, refreshToken) => set({
    isAuthenticated: true,
    accessToken,
    refreshToken
  }),

  logout: () => set({
    isAuthenticated: false,
    accessToken: null,
    refreshToken: null
  })
}));

export default AuthStore;
