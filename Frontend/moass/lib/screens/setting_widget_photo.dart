import 'package:flutter/material.dart';
import 'package:moass/widgets/top_bar.dart';

class SettingWidgetPhotoScreen extends StatelessWidget {
  const SettingWidgetPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopBar(
        title: '위젯 사진 설정',
        icon: Icons.settings,
      ),
    );
  }
}
