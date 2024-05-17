import { mozzyLunchApiAxios } from './apiConfig'

const axios = mozzyLunchApiAxios();
const API_URL = 'ssafy_food/today_menu'

/**
 * 오늘의 점심 메뉴
 * 
 * @returns {Promise} 점심 메뉴 조회
 */
export const fetchLunchMenu = async () => {
    const response = axios.get(API_URL)
    // console.log(response)
    return response
}