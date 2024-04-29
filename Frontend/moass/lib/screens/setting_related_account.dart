import 'package:flutter/material.dart';
import 'package:moass/widgets/top_bar.dart';

class SettingRelatedAccountScreen extends StatelessWidget {
  const SettingRelatedAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopBar(
        title: '연동 계정 관리',
        icon: Icons.settings,
      ),
    );
  }
}
