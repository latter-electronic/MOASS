// reservationService.js
import { moassApiAxios } from './apiConfig';
import AuthStore from '../stores/AuthStore.js';

const axios = moassApiAxios();

/**
 * 나의 예약 정보 조회
 * 
 * @returns {Promise} 예약 정보 조회 결과
 */
export const fetchReservationInfo = () => {
    const { accessToken } = AuthStore.getState();

    return axios.get('/api/reservationinfo', {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.data)
    .catch(error => {
        console.error('Error fetching reservation info:', error);
        throw error;
    });
};
