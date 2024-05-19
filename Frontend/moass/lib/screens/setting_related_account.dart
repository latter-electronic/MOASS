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
  String? userJiraMail;
  String? userGitlabMail;
  late JiraApi jiraApi;
  List<GitlabProject>? userGitlabProjects = [];
  bool isLoading = true;
  MattermostConnectionStatus? mattermostConnectionStatus;

  @override
  initState() {
    super.initState();
    jiraApi = JiraApi(dio: Dio(), storage: const FlutterSecureStorage());
    fetchMyRelatedAccount();
  }

  // 계정 연동 정보 가져오기
  Future<void> fetchMyRelatedAccount() async {
    try {
      var result = await jiraApi.fetchJiraAccount();
      var gitlabResult =
          await GitlabApi(dio: Dio(), storage: const FlutterSecureStorage())
              .fetchGitlabAccount();
      var mmConnectionResult =
          await MatterMostApi(dio: Dio(), storage: const FlutterSecureStorage())
              .checkMattermostConnection();

      setState(() {
        userJiraMail = result?.userMail;
        userGitlabMail = gitlabResult?.gitlabEmail;
        userGitlabProjects = gitlabResult?.gitlabProjects;
        mattermostConnectionStatus = mmConnectionResult;
        // print('지라 : $userJiraMail');
        // print('깃랩 : $userGitlabProjects');
        // print('깃랩 메일 : $userGitlabMail');
        // print('메타모스트 : $mattermostConnectionStatus');

        isLoading = false;
      });
    } catch (e) {
      // 오류 처리
      setState(() {
        isLoading = false;
        // print('실패');
        // print('지라 : $userJiraMail');
        // print('깃랩 : $userGitlabProjects');
        // print('깃랩 메일 : $userGitlabMail');
        // print('메타모스트 : $mattermostConnectionStatus');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(
        title: '연동 계정 관리',
        icon: Icons.settings,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SetRelatedAccount(
                      service: 'jira', userJiraMail: userJiraMail),
                  SetRelatedAccount(
                    service: 'mattermost',
                    userMattermostMail:
                        mattermostConnectionStatus?.data?.userId,
                  ),
                  SetRelatedAccount(
                    service: 'gitlab',
                    userGitlabMail: userGitlabMail,
                    userGitlabProject: userGitlabProjects,
                  ),
                ],
              ),
            ),
    );
  }
}
