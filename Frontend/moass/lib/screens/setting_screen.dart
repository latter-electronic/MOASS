import 'package:flutter/material.dart';
import 'package:moass/widgets/top_bar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopBar(
        title: '설정',
        icon: Icons.settings,
      ),
    );
  }
}
