/* UI 관련 상태를 관리
   ex) 모달의 열림 상태, 알림 메시지, 로딩 상태 등의 UI 요소 */

import { create } from 'zustand';

const useUIStore = create(set => ({
  isModalOpen: false,
  toggleModal: () => set(state => ({ isModalOpen: !state.isModalOpen }))
}));

export default useUIStore;