import { create } from 'zustand';

const useNotiStore = create((set, get) => ({
    notifications: [],
    addNotification: (notification) => set((state) => {
        const isDuplicate = state.notifications.some(noti => noti.body === notification.body);
        if (isDuplicate) {
            return { notifications: state.notifications };
        }
        return { notifications: [notification, ...state.notifications] };
    }),
    addNotifications: (notifications) => set((state) => {
        const existingNotificationBodies = state.notifications.map(noti => noti.body);
        const uniqueNotifications = notifications.filter(notification => {
            return !existingNotificationBodies.includes(notification.body);
        });
        return { notifications: [...uniqueNotifications, ...state.notifications] };
    }),
    clearNotifications: () => set({ notifications: [] })
}));

export default useNotiStore;
