class RelatedGitlabAccount {
  final gitlabEmail, gitlabProjects;

  RelatedGitlabAccount.fromJson(Map<String, dynamic> json)
      : gitlabEmail = json["gitlabEmail"],
        gitlabProjects = json["gitlabProjects"];
}
