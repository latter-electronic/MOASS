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
            'Content-Type': 'application/json'
        }
    });
};

/**
 * 액세스 토큰 갱신
 *
 * @returns {Promise} 갱신된 토큰 정보
 */
export const refreshToken = async () => {
    // AuthStore에서 리프레시 토큰 가져오기
    const { refreshToken } = AuthStore.getState();

    // 리프레시 토큰으로 새 액세스 토큰 요청
    const response = await axios.post(`${API_URL}/refresh`, {}, {
        headers: {
            'Content-Type': 'application/json'
        }
    });

    // 새로운 토큰 저장 및 반환
    AuthStore.getState().login(response.data.data.accessToken, refreshToken);
    return response.data;
};
