import { moassApiAxios } from './apiConfig';
import AuthStore from '../stores/AuthStore.js'; 

const axios = moassApiAxios();
const prefix = 'api/device';

/**
 * 기기 로그인
 * 
 * @param {Object} loginData 로그인 데이터
 * @returns {Promise} 로그인 결과
 */
export const deviceLogin = (loginData) => {
    return axios.post(`${prefix}/login`, loginData, {
        headers: { 
            'Content-Type': 'application/json'
        }
    });
};

/**
 * 기기 로그아웃
 * 
 * @param {Object} logoutData 로그아웃 데이터 (deviceId와 userId 포함)
 * @returns {Promise} 로그아웃 결과
 */
export const deviceLogout = (logoutData) => {
    const { accessToken } = AuthStore.getState();
    return axios.post(`${prefix}/logout`, logoutData, {
        headers: {
            'Authorization': `Bearer ${accessToken}`
        }
    });
};

/**
 * 기기 정보 조회
 * 
 * @returns {Promise} 기기 정보
 */
export const fetchDeviceInfo = () => {
    const { accessToken } = AuthStore.getState();
    return axios.get(prefix, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    });
};

/**
 * 기기 호출
 * 
 * @param {string} studentId 학생 ID
 * @returns {Promise} 호출 결과
 */
export const callDevice = (studentId) => {
    const { accessToken } = AuthStore.getState();
    return axios.post(`${prefix}/call`, { studentId }, {
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${accessToken}`
        }
    });
};