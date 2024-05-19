// 장현욱

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/related_gitlab_account.dart';
import 'package:moass/services/gitlab_api.dart';
import 'package:moass/widgets/gitlab_issue_card.dart';
import 'package:moass/widgets/gitlab_mr_card.dart';

class MyGitlabIssue extends StatefulWidget {
  const MyGitlabIssue({
    super.key,
  });

  @override
  State<MyGitlabIssue> createState() => _MyGitlabIssueState();
}

class _MyGitlabIssueState extends State<MyGitlabIssue> {
  late String? userGitlabMail = "";
  late List<GitlabProject>? userGitlabProjects = [];
  late List<String>? userGitlabProjectsName = [];
  String? selectedProject;
  ProjectModel? currentProject;

  @override
  void initState() {
    // TODO: implement initState
    fetchMyRelatedAccount();
    super.initState();
  }

  // 계정 연동 정보 가져오기
  Future<void> fetchMyRelatedAccount() async {
    // setState(() => isLoading = true);
    // var api = ReservationApi(dio: Dio(), storage: const FlutterSecureStorage());
    var gitlabResult =
        await GitlabApi(dio: Dio(), storage: const FlutterSecureStorage())
            .fetchGitlabAccount();
    setState(() {
      // null 체크
      userGitlabMail = gitlabResult?.gitlabEmail;
      userGitlabProjects = gitlabResult?.gitlabProjects;
      userGitlabProjectsName = userGitlabProjects
          ?.map((GitlabProject project) => project.gitlabProjectName.toString())
          .toList();

      // isLoading = false;
      print(userGitlabMail);
      print(userGitlabProjects);
      print(userGitlabProjectsName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (userGitlabMail != null && userGitlabProjects!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: DropdownButton(
                value: selectedProject,
                hint: const Text('프로젝트를 선택하세요'),
                items: userGitlabProjectsName!
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) async {
                  setState(() {
                    selectedProject = value;
                  });

                  var tempProject = await GitlabApi(
                          dio: Dio(), storage: const FlutterSecureStorage())
                      .fetchGitlabProjectInfo(selectedProject!);
                  setState(() {
                    currentProject = tempProject;
                  });
                },
              ),
            )
          else
            const SizedBox(
              height: 200,
              child: Center(
                child: Text('Gitlab 계정 연동을 확인해주세요'),
              ),
            ),
          if (currentProject != null)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Project Issue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          if (currentProject != null && currentProject!.issues.isNotEmpty)
            for (var issue in currentProject!.issues)
              GitlabIssueCardWidget(
                issue: issue,
              ),
          if (currentProject != null && currentProject!.issues.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: Text('현재 활성화된 이슈가 없습니다')),
            ),
          if (currentProject != null)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Merge Request',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          if (currentProject != null &&
              currentProject!.mergeRequests.isNotEmpty)
            for (var mergeRequest in currentProject!.mergeRequests)
              GitlabMRCardWidget(
                mergeRequest: mergeRequest,
              ),
          if (currentProject != null && currentProject!.mergeRequests.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: Text('현재 열린 MR이 없습니다')),
            ),
        ],
      ),
    );
  }
}
