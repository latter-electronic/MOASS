import axios from "axios";

const MOASS_API_URL = import.meta.env.VITE_MOASS_API_URL;
const JIRA_API_URL = import.meta.env.VITE_JIRA_API_URL;
const JIRA_API_EMAIL = import.meta.env.VITE_JIRA_API_EMAIL;
const JIRA_API_TOKEN = import.meta.env.VITE_JIRA_API_TOKEN;

export function moassApiAxios() {
    return axios.create({
        baseURL: MOASS_API_URL,
        params: {
            "language": "ko-KR"
        },
        withCredentials: true
    });
}

export function jiraApiAxios() {
    const token = Buffer.from(`${JIRA_API_EMAIL}:${JIRA_API_TOKEN}`).toString('base64');
    return axios.create({
      baseURL: JIRA_API_URL,
      headers: {
        'Authorization': `Basic ${token}`,
        'Accept': 'application/json'
      }
    });
  }