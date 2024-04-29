import 'package:flutter/material.dart';
import 'package:moass/widgets/top_bar.dart';

class SettingUserInfoScreen extends StatelessWidget {
  const SettingUserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopBar(
        title: '회원 정보 관리',
        icon: Icons.settings,
      ),
    );
  }
}
