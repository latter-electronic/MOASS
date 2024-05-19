import { create } from 'zustand';

const useNotiStore = create((set) => ({
    notifications: [],
    addNotification: (notification) => set((state) => ({
        notifications: [notification, ...state.notifications]  // 알림을 배열의 맨 앞에 추가
    })),
    addNotifications: (notifications) => set((state) => ({
        notifications: [...notifications, ...state.notifications].sort((a, b) => new Date(b.date) - new Date(a.date))  // 다중 알림을 추가하고 정렬
    })),
    clearNotifications: () => set({ notifications: [] })
}));

export default useNotiStore;