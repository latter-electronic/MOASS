import { create } from 'zustand';

const useTodoStore = create((set) => ({
    todos: [],
    lastFetched: null,
    setTodos: (todos) => set({ todos }),
    setLastFetched: (timestamp) => set({ lastFetched: timestamp }),
}));

export default useTodoStore;