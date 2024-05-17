import { moassApiAxios } from './apiConfig';
import AuthStore from '../stores/AuthStore.js';

const axios = moassApiAxios();

/**
 * 모든 알림 읽기
 * 
 * @returns {Promise} 모든 알림 읽기 결과
 */
export const readAllNotifications = () => {
    const { accessToken } = AuthStore.getState();

    return axios.delete('/api/notification/read-all', {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    }).then(response => response.data)
    .catch(error => {
        console.error('Error reading all notifications:', error);
        throw error;
    });
};

/**
 * 특정 알림 읽기 처리
 * 
 * @param {string} notificationId 읽을 알림의 ID
 * @returns {Promise} 알림 읽기 결과
 */
export const readNotification = (notificationId) => {
    const { accessToken } = AuthStore.getState();
    const url = `/api/notification/${notificationId}`;

    return axios.delete(url, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    }).then(response => response.data)
    .catch(error => {
        console.error(`Error reading notification with ID ${notificationId}:`, error);
        throw error;
    });
};

/**
 * 다음 알림 조회 (페이지네이션)
 * 
 * @param {string} lastNotificationId 마지막 알림의 ID
 * @param {string} lastCreatedAt 마지막 알림의 생성일시
 * @returns {Promise} 다음 알림 목록 조회 결과
 */
export const getNextNotifications = (lastNotificationId, lastCreatedAt) => {
    const { accessToken } = AuthStore.getState();
    const url = `/api/notification/search?lastnotificationid=${lastNotificationId}&lastCreatedAt=${lastCreatedAt}`;

    return axios.get(url, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    }).then(response => response.data)
    .catch(error => {
        console.error('Error fetching next notifications:', error);
        throw error;
    });
};

/**
 * 최근 알림 조회
 * 
 * @returns {Promise} 최근 알림 목록 조회 결과
 */
export const getRecentNotifications = () => {
    const { accessToken } = AuthStore.getState();
    const url = '/api/notification/search';

    return axios.get(url, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    }).then(response => response.data)
    .catch(error => {
        console.error('Error fetching recent notifications:', error);
        throw error;
    });
};
