// LunchMenuStore.js
import { create } from 'zustand'
import { fetchLunchMenu } from '../services/mozzyService.js'

const LunchMenuStore = create((set, get) => ({
    lunchMenus: [],
    isLoading: false,
    error: null,
    lastFetch: null,

    fetchLunchMenus: async () => {
        const now = new Date();
        const lastFetch = get().lastFetch
        
        // 마지막 요청 이후 24시간이 지났는지 확인
        if (lastFetch && (now - lastFetch) < 86400000) {
            console.log('24시간이 지나지 않아 요청을 스킵합니다.')
            return
        }

        set({ isLoading: true, error: null, lastFetch: now }) // 요청 시간 업데이트 및 로딩 상태 설정
        try {
            const response = await fetchLunchMenu()
            if (response.data.attachments) {
                // console.log(response.data.attachments)
                set({ lunchMenus: response.data.attachments })
            } else {
                console.log('올바른 데이터가 아닙니다:', response.data)
                set({ error: '데이터 형식 오류' })
            }
        } catch (error) {
            console.error('점심 메뉴 데이터 불러오기 실패:', error)
            set({ error: '데이터를 불러오는 중 오류 발생', lunchMenus: [] })
        } finally {
            set({ isLoading: false });
        }
    }
}));

export default LunchMenuStore
