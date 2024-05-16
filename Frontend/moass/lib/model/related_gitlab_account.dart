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
