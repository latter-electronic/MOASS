import { create } from 'zustand';

const useStore = create((set) => ({
  data: {},
  updateData: (newData) => set((state) => ({ data: {...state.data, ...newData} })),
}));

export default useStore;