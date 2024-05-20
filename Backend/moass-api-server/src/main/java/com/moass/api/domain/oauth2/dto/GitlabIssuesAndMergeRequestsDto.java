package com.moass.api.domain.oauth2.dto;

import com.fasterxml.jackson.databind.JsonNode;
import lombok.Data;

import java.util.List;

@Data
public class GitlabIssuesAndMergeRequestsDto {
    private String projectName;
    private List<JsonNode> issues;
    private List<JsonNode> mergeRequests;

    public GitlabIssuesAndMergeRequestsDto(String projectName, List<JsonNode> issues, List<JsonNode> mergeRequests) {
        this.projectName = projectName;
        this.issues = issues;
        this.mergeRequests = mergeRequests;
    }
}
