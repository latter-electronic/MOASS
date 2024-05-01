import 'package:flutter/material.dart';
import 'package:moass/widgets/top_bar.dart';

import '../widgets/set_related_account.dart';

class SettingRelatedAccountScreen extends StatelessWidget {
  const SettingRelatedAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: TopBar(
          title: '연동 계정 관리',
          icon: Icons.settings,
        ),
        body: Column(children: [
          SetRelatedAccount(service: 'jira'),
          SetRelatedAccount(service: 'mattermost'),
          SetRelatedAccount(service: 'gitlab'),
        ]));
  }
}
