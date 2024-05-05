// CommonJS 스타일의 index.js
(async () => {
    const { default: fetch } = await import('node-fetch');
  
    fetch('https://ssafy.atlassian.net/rest/api/3/project/search', {
      method: 'GET',
      headers: {
        'Authorization': `Basic ${Buffer.from('diduedidue@naver.com:your_api_token').toString('base64')}`,
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
  