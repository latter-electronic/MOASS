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
  final List<IssueModel> issues;
  final List<MergeRequestModel> mergeRequests;

  ProjectModel({
    required this.projectName,
    required this.issues,
    required this.mergeRequests,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> issuesJson = json['issues'];
    final List<dynamic> mergeRequestsJson = json['mergeRequests'];

    List<IssueModel> issues =
        issuesJson.map((issue) => IssueModel.fromJson(issue)).toList();
    List<MergeRequestModel> mergeRequests =
        mergeRequestsJson.map((mr) => MergeRequestModel.fromJson(mr)).toList();

    return ProjectModel(
      projectName: json['projectName'],
      issues: issues,
      mergeRequests: mergeRequests,
    );
  }
}

class IssueModel {
  final int id;
  final String title;
  final String description;
  final String state;
  final String createdAt;
  final String updatedAt;
  final UserModel author;

  IssueModel({
    required this.id,
    required this.title,
    required this.description,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    required this.author,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      state: json['state'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      author: UserModel.fromJson(json['author']),
    );
  }
}

class MergeRequestModel {
  final int id;
  final String title;
  final String description;
  final String state;
  final String createdAt;
  final String updatedAt;
  final UserModel author;
  final List<UserModel> assignees;

  MergeRequestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    required this.author,
    required this.assignees,
  });

  factory MergeRequestModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> assigneesJson = json['assignees'];
    List<UserModel> assignees =
        assigneesJson.map((assignee) => UserModel.fromJson(assignee)).toList();

    return MergeRequestModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      state: json['state'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      author: UserModel.fromJson(json['author']),
      assignees: assignees,
    );
  }
}

class UserModel {
  final int id;
  final String username;
  final String name;
  final String state;
  final bool locked;
  final String avatarUrl;
  final String webUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.state,
    required this.locked,
    required this.avatarUrl,
    required this.webUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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
