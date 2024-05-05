(async () => {
    const { default: fetch } = await import('node-fetch');
    const jqlQuery = encodeURIComponent(`project = 'S10P31E203' AND sprint IN closedSprints() AND sprint NOT IN futureSprints() ORDER BY sprint DESC`);
    // 원래는 project = 'S10P31E203' AND sprint IN openSprints() 인데 지금 열린 스프린트가 없어서 제일 최신 스프린트로 불러옴
  
    fetch(`https://ssafy.atlassian.net/rest/api/3/search?jql=${jqlQuery}&maxResults=10`, {
      method: 'GET',
      headers: {
        'Authorization': `Basic ${Buffer.from('diduedidue@naver.com:ATATT3xFfGF0CQg6pdozVLzR_9t-KbjN0eVvOCFboUHE9I7HGTj9ChXe7VV-HtdlfYFkcXFZ6QMELuo0uhFvnNNWk6alPHKA2vUz2FnHtr2dRUm-8q2_IzH8NWz-h_OjJpbsGRCFg42yH5p5tztaSoV6z-pzSB2PxwwnOJ390Qe0D8TENAxzlBg=A98212EB').toString('base64')}`,
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
  