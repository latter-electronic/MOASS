import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/services/jira_api.dart';
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
  late String? userJiraMail;
  late JiraApi jiraApi;

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
    setState(() {
      // null 체크
      userJiraMail = result?.userMail;

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
        body: Column(children: [
          SetRelatedAccount(service: 'jira', userJiraMail: userJiraMail),
          const SetRelatedAccount(service: 'mattermost'),
          const SetRelatedAccount(service: 'gitlab'),
        ]));
  }
}
