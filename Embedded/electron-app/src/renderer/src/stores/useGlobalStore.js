import { create } from 'zustand';
import { fetchUserInfo } from '../services/userService.js';

const useGlobalStore = create((set) => ({
  user: {
    locationCode: "",
    locationName: "",
    classCode: "",
    teamCode: "",
    teamName: "",
    userId: "",
    userEmail: "",
    userName: "",
    positionName: null,
    statusId: 1,
    profileImg: null,
    backgroundImg: null,
    jobCode: 0,
    connectFlag: 0,
    xcoord: null,
    ycoord: null
  },
  isLoadingUser: false,
  setUser: (user) => {
    set({ user });
    if (window.electron) {
      window.electron.ipcRenderer.send('user-updated', user); // 상태 변경을 IPC로 전달
    }
  },
  fetchUserInfo: async () => {
    set({ isLoadingUser: true });
    try {
      const response = await fetchUserInfo();
      set({ user: response.data.data });
      console.log('try');
    } catch (error) {
      console.error('사용자 정보를 불러오는데 실패했습니다:', error);
      set({ user: null });
    } finally {
      set({ isLoadingUser: false });
    }
  },
  theme: 'light',
  toggleTheme: () => set((state) => ({ theme: state.theme === 'light' ? 'dark' : 'light' })),
  boardUrl: '',
  setBoardUrl: (url) => {
    console.log('Setting board URL:', url);
    set({ boardUrl: url });
  },
}));

export default useGlobalStore;
