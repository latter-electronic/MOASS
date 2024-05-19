import { moassApiAxios } from './apiConfig.js';
import AuthStore from '../stores/AuthStore.js';

const axios = moassApiAxios();
const prefix = 'api/oauth2/jira/proxy';
const CACHE_EXPIRATION_MS = 5 * 60 * 1000; // 캐시 만료 시간: 5분

const getCache = (key) => {
    const cachedData = localStorage.getItem(key);
    if (cachedData) {
        const parsedData = JSON.parse(cachedData);
        if (Date.now() < parsedData.expiration) {
            return parsedData.data;
        } else {
            localStorage.removeItem(key);
        }
    }
    return null;
};

const setCache = (key, data) => {
    const cacheData = {
        data,
        expiration: Date.now() + CACHE_EXPIRATION_MS,
    };
    localStorage.setItem(key, JSON.stringify(cacheData));
};

/**
 * 현재 Jira 연결 상태 확인(프록시x)
 * 
 * @returns {Promise} Jira 연결 상태
 */
export const checkJiraConnection = async () => {
    const { accessToken } = AuthStore.getState();
    const url = '/api/oauth2/jira/isconnected';

    return axios.get(url, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    }).then(response => {
        console.log(response.data)
        return response.data; // 연결 상태 반환
    })
    .catch(error => {
        console.error('Error checking Jira connection status:', error);
        throw error;
    });
};

/**
 * 현재 로그인한 사용자의 Jira 정보 조회
 * 
 * @returns {Promise} 사용자 정보
 */
export const getCurrentUser = async () => {
    const { accessToken } = AuthStore.getState();
    const payload = {
        method: "get",
        url: "/rest/api/3/myself",
    };

    return axios.post(prefix, payload, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    }).then(response => {
        response.data.data
        console.log("지라로그인 유저", response.data.data);
    })
    .catch(error => {
        console.error('Error fetching current user details:', error);
        throw error;
    });
};

/**
 * 현재 열려있는 스프린트의 이슈들 검색
 * 
 * @param {string} statusId - 조회할 이슈의 상태 ID ('10000' - 해야 할 일, '3' - 진행 중, '10001' - 완료)
 * @returns {Promise} 이슈 데이터
 */
export const fetchCurrentSprintIssues = async (statusId) => {
    const cacheKey = `currentSprintIssues-${statusId}`;
    const cachedData = getCache(cacheKey);
    if (cachedData) {
        return { issues: cachedData };
    }

    const { accessToken } = AuthStore.getState();
    const projectData = await getProject();
    const projectKey = projectData.values[0].key;
    const currentUser = await checkJiraConnection(); // 현재 사용자 정보 가져오기
    const reporterEmail = currentUser.data; // 사용자 이메일 주소

    const data = {
        method: "get",
        url: `/rest/api/3/search?jql=project = '${projectKey}' AND sprint IN openSprints() AND status = '${statusId}' AND reporter = '${reporterEmail}'&fields=customfield_10014,summary,priority,assignee,customfield_10031&maxResults=240`
    };

    const issues = await axios.post(prefix, data, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    }).then(response => response.data.data.issues)
      .catch(error => {
          console.error('Error fetching current sprint issues based on status:', error);
          throw error;
      });

    const issuesWithEpics = await Promise.all(issues.map(async issue => {
        if (issue.fields.customfield_10014) {
            const epicData = await getIssueDetails(issue.fields.customfield_10014);
            issue.epic = {
                name: epicData.fields.customfield_10011,
                color: epicData.fields.customfield_10017
            };
        }
        return issue;
    }));

    setCache(cacheKey, issuesWithEpics);

    return { issues: issuesWithEpics };
};

/**
 * 주어진 ID 또는 키로 Jira 이슈의 세부 정보 가져옴.
 * MOASS 내부에선 epic 가져오는 용도로 쓰임
 * 
 * @param {string} issueIdOrKey - 검색할 이슈의 ID 또는 키
 * @returns {Promise} 이슈 세부 정보를 나타내는 Promise 객체
 */
export const getIssueDetails = async (issueIdOrKey) => {
    const { accessToken } = AuthStore.getState();
    const data = {
        method: 'get',
        url: `/rest/api/3/issue/${issueIdOrKey}?fields=customfield_10011,customfield_10017`
    };

    return axios.post(prefix, data, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    }).then(response => {
        return response.data.data
    })
      .catch(error => {
          console.error(`Error fetching details for issue ${issueIdOrKey}:`, error);
          throw error;
      });
};

/**
 * 최근 마감된 스프린트의 이슈들 검색
 * 
 * @returns {Promise} 이슈 데이터
 */
export const fetchRecentClosedSprintIssues = async () => {
    const { accessToken } = AuthStore.getState();
    const data = {
        method: "get",
        url: "/rest/api/3/search?jql=project = 'S10P31E203' AND reporter = 'diduedidue@naver.com' AND sprint IN closedSprints() AND sprint NOT IN futureSprints() ORDER BY sprint DESC&fields=creator,summary,priority,status,customfield_10031,parent&maxResults=50"
    };

    return axios.post(prefix, data, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    }).then(response => response.data)
      .catch(error => {
          console.error('Error fetching recent closed sprint issues:', error);
          throw error;
      });
};

/**
 * 모든 Jira 프로젝트 검색
 * 
 * @returns {Promise} 프로젝트 목록
 * expand: insight  통해 lastIssueUpdatedTime 키값 json 결과값에 추가하고 해당 키를 통해 desc 정렬. 마지막 결과 1개만 받아옴
 */
export const getProject = async () => {
    const cacheKey = 'jiraProjects';
    const cachedData = getCache(cacheKey);
    if (cachedData) {
        return cachedData;
    }

    const { accessToken } = AuthStore.getState();
    const data = {
        method: "get",
        url: "/rest/api/3/project/search?maxResults=1&expand=insight&orderBy=-lastIssueUpdatedTime"
    };

    const projectData = await axios.post(prefix, data, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    }).then(response => {
        console.log("Project data received:", response.data.data.values[0].key );
        return response.data.data;
    })
    .catch(error => {
        console.error('Error fetching projects:', error);
        throw error;
    });

    setCache(cacheKey, projectData);
    return projectData;
};

/**
 * Jira 이슈의 상태 변경
 * 
 * @param {string} issueIdOrKey - 변경할 이슈의 ID 또는 키
 * @param {string} transitionId - 적용할 상태 전환의 ID
 * @returns {Promise} 상태 변경 요청의 결과를 반환하는 Promise 객체
 */
export const changeIssueStatus = async (issueIdOrKey, transitionId) => {
    const { accessToken } = AuthStore.getState();
    const payload = {
        method: 'post',
        url: `/rest/api/3/issue/${issueIdOrKey}/transitions`,
        body: JSON.stringify({
            transition: {
                id: transitionId
            }
        })
    };

    return axios.post(prefix, payload, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    })
    .then(response => {
        if (response.status === 204) {
            console.log('Status updated successfully');
        }
        return response;
    })
    .catch(error => {
        // console.error(`Error updating status for issue ${issueIdOrKey}:`, error.response || error.message);
        throw error;
    });
};
