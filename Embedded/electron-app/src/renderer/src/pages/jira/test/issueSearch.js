(async () => {
    const { default: fetch } = await import('node-fetch');
    const { writeFile } = await import('fs/promises');

    const jqlQuery = encodeURIComponent(`project = 'S10P31E203' AND sprint IN closedSprints() AND sprint NOT IN futureSprints() ORDER BY sprint DESC`);
    const url = `https://ssafy.atlassian.net/rest/api/3/search?jql=${jqlQuery}&maxResults=10`;
  
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
        console.log('Data saved to test.json');
    } catch (err) {
        console.error('Error:', err);
    }
})();
