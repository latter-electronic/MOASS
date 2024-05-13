import axios from "axios";

const MOASS_API_URL = "https://k10e203.p.ssafy.io"

export function moassApiAxios() {
    return axios.create({
        baseURL: MOASS_API_URL,
        withCredentials: true,
        params: {
            "language": "ko-KR"
        },
    });
}