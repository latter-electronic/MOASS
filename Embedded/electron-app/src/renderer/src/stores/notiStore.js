import { create } from 'zustand';

const useNotiStore = create((set) => ({
    notifications: [],
    addNotification: (notification) => set((state) => ({
        notifications: [...state.notifications, notification]
    })),
    clearNotifications: () => set({ notifications: [] })
}));

export default useNotiStore;