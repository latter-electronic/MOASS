import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/related_MM_account.dart';
import 'package:moass/model/related_gitlab_account.dart';
import 'package:moass/services/gitlab_api.dart';
import 'package:moass/services/jira_api.dart';
import 'package:moass/services/mattermost_api.dart';
import 'package:moass/widgets/top_bar.dart';

import '../widgets/set_related_account.dart';

class SettingRelatedAccountScreen extends StatefulWidget {
  const SettingRelatedAccountScreen({super.key});

  @override
  State<SettingRelatedAccountScreen> createState() =>
      _SettingRelatedAccountScreenState();
}

class _SettingRelatedAccountScreenState
    extends State<SettingRelatedAccountScreen> {
  late String? userJiraMail = '정보를 불러오고 있습니다...';
  late String? userGitlabMail = '정보를 불러오고 있습니다...';
  late JiraApi jiraApi;
  late List<GitlabProject>? userGitlabProjects = [];
  late List<MattermostTeam>? userMattermostTeamList = [];

  @override
  initState() {
    jiraApi = JiraApi(dio: Dio(), storage: const FlutterSecureStorage());

    fetchMyRelatedAccount();
    super.initState();
  }

  // 계정 연동 정보 가져오기
  Future<void> fetchMyRelatedAccount() async {
    // setState(() => isLoading = true);
    // var api = ReservationApi(dio: Dio(), storage: const FlutterSecureStorage());
    var result = await jiraApi.fetchJiraAccount(); // API 호출
    var gitlabResult =
        await GitlabApi(dio: Dio(), storage: const FlutterSecureStorage())
            .fetchGitlabAccount();
    var mmTeamResult =
        await MatterMostApi(dio: Dio(), storage: const FlutterSecureStorage())
            .fetchMatterMostChannels();
    // print('깃랩 메일 : ${gitlabResult?.gitlabEmail}');
    // print('깃랩 프로젝트 : ${gitlabResult?.gitlabProjects}');
    setState(() {
      // null 체크
      userJiraMail = result?.userMail;
      userGitlabMail = gitlabResult?.gitlabEmail;
      userGitlabProjects = gitlabResult?.gitlabProjects;
      userMattermostTeamList = mmTeamResult;

      // print(userGitlabMail);

      // isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TopBar(
          title: '연동 계정 관리',
          icon: Icons.settings,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            SetRelatedAccount(service: 'jira', userJiraMail: userJiraMail),
            SetRelatedAccount(
              service: 'mattermost',
              userMattermostMail: userMattermostTeamList != null ? '연동됨' : null,
            ),
            userMattermostTeamList != null
                ? Column(
                    children: [
                      for (MattermostTeam userMattermostTeam
                          in userMattermostTeamList!)
                        for (MattermostChannel userMattermostChannel
                            in userMattermostTeam.mmChannelList)
                          Column(
                            children: [
                              Text(
                                userMattermostTeam.mmTeamName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(userMattermostChannel.channelName),
                            ],
                          ),
                    ],
                  )
                : const SizedBox(),
            SetRelatedAccount(
              service: 'gitlab',
              userGitlabMail: userGitlabMail,
              userGitlabProject: userGitlabProjects,
            ),
          ]),
        ));
  }
}
