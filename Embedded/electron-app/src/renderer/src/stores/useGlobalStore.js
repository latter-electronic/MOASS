/* 전역 상태를 관리하는 파일
   애플리케이션 전반에서 공유되는 데이터(예: 사용자 정보, 설정, UI 상태 등)를 관리
   Zustand로 간단히 상태를 선언하고, 그걸 앱 전체에서 접근할 수 있게 할 수 있음*/
   
import { create } from 'zustand';
import { fetchUserInfo } from '../services/userService.js';
import testUser from './test/testUser.json';

const useGlobalStore = create((set) => ({
  user: null, // 초기 상태로 `null` 설정
  setUser: (user) => set({ user }),
  fetchUserInfo: async () => {
    try {
      const response = await fetchUserInfo();
      set({ user: response.data.data });
    } catch (error) {
      console.error('사용자 정보를 불러오는데 실패했습니다:', error);
      set({ user: null }); // 에러가 발생하면 user를 null로 설정
    }
  },
  theme: 'light',
  toggleTheme: () => set((state) => ({ theme: state.theme === 'light' ? 'dark' : 'light' })),
}));

export default useGlobalStore;