import axios from "axios";

const MOASS_API_URL = "https://k10e203.p.ssafy.io"
const MOZZY_LUNCH_URL = "https://ssafyfood-www-jong.koyeb.app"

export function moassApiAxios() {
    return axios.create({
        baseURL: MOASS_API_URL,
        withCredentials: true,
        params: {
            "language": "ko-KR"
        },
    });
}

export function mozzyLunchApiAxios() {
    return axios.create({
      baseURL: MOZZY_LUNCH_URL,
    })
  }