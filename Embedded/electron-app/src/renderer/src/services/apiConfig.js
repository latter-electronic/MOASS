import axios from "axios";

const MOASS_API_URL = "https://k10e203.p.ssafy.io"
const JIRA_API_URL = "https://ssafy.atlassian.net/rest/api/3"
const JIRA_API_EMAIL = "diduedidue@naver.com"
const JIRA_API_TOKEN = "ATATT3xFfGF0CQg6pdozVLzR_9t-KbjN0eVvOCFboUHE9I7HGTj9ChXe7VV-HtdlfYFkcXFZ6QMELuo0uhFvnNNWk6alPHKA2vUz2FnHtr2dRUm-8q2_IzH8NWz-h_OjJpbsGRCFg42yH5p5tztaSoV6z-pzSB2PxwwnOJ390Qe0D8TENAxzlBg=A98212EB"
const MOZZY_LUNCH_URL = "https://ssafyfood-www-jong.koyeb.app"

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

export function mozzyLunchApiAxios() {
  return axios.create({
    baseURL: MOZZY_LUNCH_URL,
  })
}