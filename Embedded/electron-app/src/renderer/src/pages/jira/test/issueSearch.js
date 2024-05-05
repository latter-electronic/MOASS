(async () => {
    const { default: fetch } = await import('node-fetch');
    const { writeFile } = await import('fs/promises');

    const jqlQuery = encodeURIComponent(`project = 'S10P31E203' AND sprint IN closedSprints() AND sprint NOT IN futureSprints() ORDER BY sprint DESC`);
    const url = `https://ssafy.atlassian.net/rest/api/3/search?jql=${jqlQuery}&maxResults=10`;
  
    try {
        const response = await fetch(url, {
            method: 'GET',
            headers: {
                'Authorization': `Basic ${Buffer.from('diduedidue@naver.com:ATATT3xFfGF0CQg6pdozVLzR_9t-KbjN0eVvOCFboUHE9I7HGTj9ChXe7VV-HtdlfYFkcXFZ6QMELuo0uhFvnNNWk6alPHKA2vUz2FnHtr2dRUm-8q2_IzH8NWz-h_OjJpbsGRCFg42yH5p5tztaSoV6z-pzSB2PxwwnOJ390Qe0D8TENAxzlBg=A98212EB').toString('base64')}`,
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
