class RelatedGitlabAccount {
  final String gitlabEmail;
  final List<GitlabProject> gitlabProjects;

  RelatedGitlabAccount({
    required this.gitlabEmail,
    required this.gitlabProjects,
  });

  factory RelatedGitlabAccount.fromJson(Map<String, dynamic> json) {
    var projectsList = json['gitlabProjects'] as List;
    List<GitlabProject> projects =
        projectsList.map((project) => GitlabProject.fromJson(project)).toList();

    return RelatedGitlabAccount(
      gitlabEmail: json['gitlabEmail'],
      gitlabProjects: projects,
    );
  }
}

class GitlabProject {
  final gitlabProjectId, gitlabTokenId, gitlabProjectName;

  GitlabProject.fromJson(Map<String, dynamic> json)
      : gitlabProjectId = json['gitlabProjectId'],
        gitlabProjectName = json['gitlabProjectName'],
        gitlabTokenId = json['gitlabTokenId'];
}

class ProjectModel {
  final String projectName;
  final List<Issue> issues;
  final List<MergeRequest> mergeRequests;

  ProjectModel({
    required this.projectName,
    required this.issues,
    required this.mergeRequests,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      projectName: json['projectName'],
      issues: List<Issue>.from(
        json['issues'].map((issue) => Issue.fromJson(issue)),
      ),
      mergeRequests: List<MergeRequest>.from(
        json['mergeRequests']
            .map((mergeRequest) => MergeRequest.fromJson(mergeRequest)),
      ),
    );
  }
}

class Issue {
  final int id;
  final int iid;
  final int projectId;
  final String title;
  final String description;
  final String state;
  final String createdAt;
  final String updatedAt;
  final dynamic closedAt;
  final dynamic closedBy;
  final List<dynamic> labels;
  final dynamic milestone;
  final List<dynamic> assignees;
  final Author author;
  final String type;
  final dynamic assignee;
  final int userNotesCount;
  final int mergeRequestsCount;
  final int upvotes;
  final int downvotes;
  final dynamic dueDate;
  final bool confidential;
  final dynamic discussionLocked;
  final String issueType;
  final String webUrl;
  final TimeStats timeStats;
  final TaskCompletionStatus taskCompletionStatus;
  final bool hasTasks;
  final String taskStatus;
  final dynamic links;
  final References references;
  final String severity;
  final dynamic movedToId;
  final dynamic serviceDeskReplyTo;

  Issue({
    required this.id,
    required this.iid,
    required this.projectId,
    required this.title,
    required this.description,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    required this.closedAt,
    required this.closedBy,
    required this.labels,
    required this.milestone,
    required this.assignees,
    required this.author,
    required this.type,
    required this.assignee,
    required this.userNotesCount,
    required this.mergeRequestsCount,
    required this.upvotes,
    required this.downvotes,
    required this.dueDate,
    required this.confidential,
    required this.discussionLocked,
    required this.issueType,
    required this.webUrl,
    required this.timeStats,
    required this.taskCompletionStatus,
    required this.hasTasks,
    required this.taskStatus,
    required this.links,
    required this.references,
    required this.severity,
    required this.movedToId,
    required this.serviceDeskReplyTo,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['id'],
      iid: json['iid'],
      projectId: json['project_id'],
      title: json['title'],
      description: json['description'],
      state: json['state'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      closedAt: json['closed_at'],
      closedBy: json['closed_by'],
      labels: json['labels'],
      milestone: json['milestone'],
      assignees: json['assignees'],
      author: Author.fromJson(json['author']),
      type: json['type'],
      assignee: json['assignee'],
      userNotesCount: json['user_notes_count'],
      mergeRequestsCount: json['merge_requests_count'],
      upvotes: json['upvotes'],
      downvotes: json['downvotes'],
      dueDate: json['due_date'],
      confidential: json['confidential'],
      discussionLocked: json['discussion_locked'],
      issueType: json['issue_type'],
      webUrl: json['web_url'],
      timeStats: TimeStats.fromJson(json['time_stats']),
      taskCompletionStatus:
          TaskCompletionStatus.fromJson(json['task_completion_status']),
      hasTasks: json['has_tasks'],
      taskStatus: json['task_status'],
      links: json['_links'],
      references: References.fromJson(json['references']),
      severity: json['severity'],
      movedToId: json['moved_to_id'],
      serviceDeskReplyTo: json['service_desk_reply_to'],
    );
  }
}

class Author {
  final int id;
  final String username;
  final String name;
  final String state;
  final bool locked;
  final String avatarUrl;
  final String webUrl;

  Author({
    required this.id,
    required this.username,
    required this.name,
    required this.state,
    required this.locked,
    required this.avatarUrl,
    required this.webUrl,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      state: json['state'],
      locked: json['locked'],
      avatarUrl: json['avatar_url'],
      webUrl: json['web_url'],
    );
  }
}

class Reviewer {
  final int id;
  final String username;
  final String name;
  final bool locked;
  final String state;
  final String avatarUrl;
  final String webUrl;

  Reviewer(
      {required this.id,
      required this.username,
      required this.name,
      required this.locked,
      required this.avatarUrl,
      required this.webUrl,
      required this.state});

  factory Reviewer.fromJson(Map<String, dynamic> json) {
    return Reviewer(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      state: json['state'],
      locked: json['locked'],
      avatarUrl: json['avatar_url'],
      webUrl: json['web_url'],
    );
  }
}

class TimeStats {
  final int timeEstimate;
  final int totalTimeSpent;
  final dynamic humanTimeEstimate;
  final dynamic humanTotalTimeSpent;

  TimeStats({
    required this.timeEstimate,
    required this.totalTimeSpent,
    required this.humanTimeEstimate,
    required this.humanTotalTimeSpent,
  });

  factory TimeStats.fromJson(Map<String, dynamic> json) {
    return TimeStats(
      timeEstimate: json['time_estimate'],
      totalTimeSpent: json['total_time_spent'],
      humanTimeEstimate: json['human_time_estimate'],
      humanTotalTimeSpent: json['human_total_time_spent'],
    );
  }
}

class TaskCompletionStatus {
  final int count;
  final int completedCount;

  TaskCompletionStatus({
    required this.count,
    required this.completedCount,
  });

  factory TaskCompletionStatus.fromJson(Map<String, dynamic> json) {
    return TaskCompletionStatus(
      count: json['count'],
      completedCount: json['completed_count'],
    );
  }
}

class References {
  final String short;
  final String relative;
  final String full;

  References({
    required this.short,
    required this.relative,
    required this.full,
  });

  factory References.fromJson(Map<String, dynamic> json) {
    return References(
      short: json['short'],
      relative: json['relative'],
      full: json['full'],
    );
  }
}

class MergeRequest {
  final int id;
  final int iid;
  final int projectId;
  final String title;
  final String description;
  final String state;
  final String createdAt;
  final String updatedAt;
  final dynamic mergedBy;
  final dynamic mergeUser;
  final dynamic mergedAt;
  final dynamic closedBy;
  final dynamic closedAt;
  final String targetBranch;
  final String sourceBranch;
  final int userNotesCount;
  final int upvotes;
  final int downvotes;
  final Author author;
  final List<dynamic> assignees;
  final dynamic assignee;
  final List<Reviewer> reviewers;
  final int sourceProjectId;
  final int targetProjectId;
  final List<dynamic> labels;
  final bool draft;
  final bool workInProgress;
  final dynamic milestone;
  final bool mergeWhenPipelineSucceeds;
  final String mergeStatus;
  final String detailedMergeStatus;
  final String sha;
  final dynamic mergeCommitSha;
  final dynamic squashCommitSha;
  final dynamic discussionLocked;
  final dynamic shouldRemoveSourceBranch;
  final bool forceRemoveSourceBranch;
  final String preparedAt;
  final String reference;
  final References references;
  final String webUrl;
  final TimeStats timeStats;
  final bool squash;
  final bool squashOnMerge;
  final TaskCompletionStatus taskCompletionStatus;
  final bool hasConflicts;
  final bool blockingDiscussionsResolved;

  MergeRequest({
    required this.id,
    required this.iid,
    required this.projectId,
    required this.title,
    required this.description,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    required this.mergedBy,
    required this.mergeUser,
    required this.mergedAt,
    required this.closedBy,
    required this.closedAt,
    required this.targetBranch,
    required this.sourceBranch,
    required this.userNotesCount,
    required this.upvotes,
    required this.downvotes,
    required this.author,
    required this.assignees,
    required this.assignee,
    required this.reviewers,
    required this.sourceProjectId,
    required this.targetProjectId,
    required this.labels,
    required this.draft,
    required this.workInProgress,
    required this.milestone,
    required this.mergeWhenPipelineSucceeds,
    required this.mergeStatus,
    required this.detailedMergeStatus,
    required this.sha,
    required this.mergeCommitSha,
    required this.squashCommitSha,
    required this.discussionLocked,
    required this.shouldRemoveSourceBranch,
    required this.forceRemoveSourceBranch,
    required this.preparedAt,
    required this.reference,
    required this.references,
    required this.webUrl,
    required this.timeStats,
    required this.squash,
    required this.squashOnMerge,
    required this.taskCompletionStatus,
    required this.hasConflicts,
    required this.blockingDiscussionsResolved,
  });

  factory MergeRequest.fromJson(Map<String, dynamic> json) {
    return MergeRequest(
      id: json['id'],
      iid: json['iid'],
      projectId: json['project_id'],
      title: json['title'],
      description: json['description'],
      state: json['state'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      mergedBy: json['merged_by'],
      mergeUser: json['merge_user'],
      mergedAt: json['merged_at'],
      closedBy: json['closed_by'],
      closedAt: json['closed_at'],
      targetBranch: json['target_branch'],
      sourceBranch: json['source_branch'],
      userNotesCount: json['user_notes_count'],
      upvotes: json['upvotes'],
      downvotes: json['downvotes'],
      author: Author.fromJson(json['author']),
      assignees: json['assignees'],
      assignee: json['assignee'],
      reviewers: List<Reviewer>.from(
          json['reviewers'].map((reviewer) => Reviewer.fromJson(reviewer))),
      sourceProjectId: json['source_project_id'],
      targetProjectId: json['target_project_id'],
      labels: json['labels'],
      draft: json['draft'],
      workInProgress: json['work_in_progress'],
      milestone: json['milestone'],
      mergeWhenPipelineSucceeds: json['merge_when_pipeline_succeeds'],
      mergeStatus: json['merge_status'],
      detailedMergeStatus: json['detailed_merge_status'],
      sha: json['sha'],
      mergeCommitSha: json['merge_commit_sha'],
      squashCommitSha: json['squash_commit_sha'],
      discussionLocked: json['discussion_locked'],
      shouldRemoveSourceBranch: json['should_remove_source_branch'],
      forceRemoveSourceBranch: json['force_remove_source_branch'],
      preparedAt: json['prepared_at'],
      reference: json['reference'],
      references: References.fromJson(json['references']),
      webUrl: json['web_url'],
      timeStats: TimeStats.fromJson(json['time_stats']),
      squash: json['squash'],
      squashOnMerge: json['squash_on_merge'],
      taskCompletionStatus:
          TaskCompletionStatus.fromJson(json['task_completion_status']),
      hasConflicts: json['has_conflicts'],
      blockingDiscussionsResolved: json['blocking_discussions_resolved'],
    );
  }
}
