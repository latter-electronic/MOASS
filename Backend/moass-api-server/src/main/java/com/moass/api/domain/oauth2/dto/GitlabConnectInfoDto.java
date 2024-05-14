package com.moass.api.domain.oauth2.dto;

import com.moass.api.domain.oauth2.entity.GitlabProject;
import lombok.Data;

import java.util.List;

@Data
public class GitlabConnectInfoDto {
    private String gitlabEmail;
    private List<GitlabProjectData> gitlabProjects;

    @Data
    public static class GitlabProjectData {
        private String gitlabProjectId;
        private Integer gitlabTokenId;
        private String gitlabProjectName;

        public GitlabProjectData(GitlabProject gitlabProject) {
            this.gitlabProjectId = gitlabProject.getGitlabProjectId();
            this.gitlabTokenId = gitlabProject.getGitlabTokenId();
            this.gitlabProjectName = gitlabProject.getGitlabProjectName();
        }
    }
}
