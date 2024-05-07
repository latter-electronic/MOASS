// saveJiraIssues.js
import fs from 'fs/promises';

const saveIssuesToFile = async () => {
    try {
        // jiraService 모듈을 동적으로 불러옵니다.
        const jiraService = await import('../../../services/jiraService.js');
        const issues = await jiraService.fetchCurrentSprintIssues();
        const filePath = './CurrentSprintAll.json';
        await fs.writeFile(filePath, JSON.stringify(issues, null, 2), 'utf8');
        console.log('Issues saved to recentClosedSprintIssues.json');
    } catch (error) {
        console.error('Error saving issues to file:', error);
    }
};

saveIssuesToFile();
