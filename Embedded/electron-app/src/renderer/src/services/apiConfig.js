import axios from "axios";

const MOASS_API_URL = import.meta.env.VITE_MOASS_API_URL;

export function moassApiAxios() {
    return axios.create({
        baseURL: MOASS_API_URL,
        params: {
            "language": "ko-KR"
        },
        withCredentials: true
    });
}