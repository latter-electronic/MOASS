import { moassApiAxios } from './apiConfig.js';
import AuthStore from '../stores/AuthStore.js';

const axios = moassApiAxios();
const API_URL = '/api/user';

/**
 * 사용자 정보 조회
 *
 * @returns {Promise} 사용자 정보 결과
 */
export const fetchUserInfo = async () => {
    // AuthStore에서 액세스 토큰 가져오기
    const { accessToken } = AuthStore.getState();

    // 요청 헤더에 액세스 토큰 추가
    return axios.get(API_URL, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
        }
    });
};

/**
 * 사용자 상태 업데이트
 *
 * @param {Object} updateData - 업데이트할 사용자 데이터
 * @returns {Promise} 업데이트 결과
 */
export const updateUserStatus = async (updateData) => {
    const { accessToken } = AuthStore.getState();

    try {
        const response = await axios.patch(`${API_URL}/status`, updateData, {
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${accessToken}`
            }
        });
        return response.data;
    } catch (error) {
        console.error('Error updating user status:', error.response);
        throw error;
    }
};
