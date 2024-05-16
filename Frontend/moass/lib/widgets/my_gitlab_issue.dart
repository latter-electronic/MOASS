// 장현욱

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/related_gitlab_account.dart';
import 'package:moass/screens/work_screen.dart';
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
    // print('깃랩 메일 : ${gitlabResult?.gitlabEmail}');
    // print('깃랩 프로젝트 : ${gitlabResult?.gitlabProjects}');
    setState(() {
      // null 체크
      userGitlabMail = gitlabResult?.gitlabEmail;
      userGitlabProjects = gitlabResult?.gitlabProjects;
      userGitlabProjectsName = userGitlabProjects
          ?.map((GitlabProject project) => project.gitlabProjectName.toString())
          .toList();

      // isLoading = false;
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
                onChanged: (value) {
                  setState() {
                    selectedProject = value;
                  }
                  // print(value);
                },
              ),
            )
          else
            const SizedBox(
              height: 300,
              child: Center(
                child: Text('Gitlab 계정 연동을 확인해주세요'),
              ),
            ),
          const Column(
            children: [
              GitlabIssueCardWidget(),
              GitlabMRCardWidget(),
            ],
          ),
        ],
      ),
    );
  }
}
