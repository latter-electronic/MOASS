(async () => {
    const { default: fetch } = await import('node-fetch');
  
    fetch('https://ssafy.atlassian.net/rest/api/3/project/search', {
      method: 'GET',
      headers: {
        'Authorization': `Basic ${Buffer.from(`diduedidue@naver.com:${import.meta.env.VITE_JIRA_API_TOKEN}`).toString('base64')}`,
        'Accept': 'application/json'
      }
    })
    .then(response => {
      console.log(`Response: ${response.status} ${response.statusText}`);
      return response.text();
    })
    .then(text => console.log(text))
    .catch(err => console.error(err));
  })();
  