import { moassApiAxios } from './apiConfig';
import AuthStore from '../stores/AuthStore.js';

const axios = moassApiAxios();
const prefix = 'api/schedule';

/**
 * 예약 정보 가져오기
 * 
 * @returns {Promise} 예약 정보 조회 결과
 */
export const fetchReservationInfo = async () => {
    const { accessToken } = AuthStore.getState();

    return axios.get(`${prefix}/reservationinfo`, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
        }
    }).then(response => response.data)
      .catch(error => {
          console.error('Error fetching reservation info:', error);
          throw error;
      });
};
