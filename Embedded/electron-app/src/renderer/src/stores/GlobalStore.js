/* 전역 상태를 관리하는 파일
   애플리케이션 전반에서 공유되는 데이터(예: 사용자 정보, 설정, UI 상태 등)를 관리
   Zustand로 간단히 상태를 선언하고, 그걸 앱 전체에서 접근할 수 있게 할 수 있음*/
   
import { create } from 'zustand';

const useGlobalStore = create(set => ({
  user: null,
  setUser: user => set({ user }),
  theme: 'light',
  toggleTheme: () => set(state => ({ theme: state.theme === 'light' ? 'dark' : 'light' }))
}));

export default useGlobalStore;