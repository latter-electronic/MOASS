(async () => {
    const { default: fetch } = await import('node-fetch');
    const { writeFile } = await import('fs/promises');

    // 필요한 필드 ID를 정확히 알아내야 함. 커스텀필드는 지정 불가
    const fields = 'creator,summary,priority,status';

    // 원래는 project = 'S10P31E203' AND sprint IN openSprints() 인데 지금 열린 스프린트가 없어서 제일 최신 스프린트로 불러옴
    const jqlQuery = encodeURIComponent(`project = 'S10P31E203' AND sprint IN closedSprints() AND sprint NOT IN futureSprints() ORDER BY sprint DESC`);
    const url = `https://ssafy.atlassian.net/rest/api/3/search?jql=${jqlQuery}&fields=${fields}&maxResults=10`;

    try {
        const response = await fetch(url, {
            method: 'GET',
            headers: {
                'Authorization': `Basic ${Buffer.from(`diduedidue@naver.com:${import.meta.env.VITE_JIRA_API_TOKEN}`).toString('base64')}`,
                'Accept': 'application/json'
            }
        });

        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const data = await response.json();
        const filePath = './issueSearch.json';
        await writeFile(filePath, JSON.stringify(data, null, 2), 'utf8');
        console.log('Data saved to issueSearch.json');
    } catch (err) {
        console.error('Error:', err);
    }
})();