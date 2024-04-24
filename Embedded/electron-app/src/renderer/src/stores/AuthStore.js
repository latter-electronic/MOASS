/* 인증 관련 상태를 관리
   로그인, 로그아웃, 사용자 인증 상태 확인 등 인증과 관련된 상태 관리*/
import { create } from 'zustand';

const useAuthStore = create(set => ({
  isAuthenticated: false,
  login: () => set({ isAuthenticated: true }),
  logout: () => set({ isAuthenticated: false })
}));

export default useAuthStore;
