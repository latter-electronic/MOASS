import 'package:flutter/material.dart';
import 'package:moass/widgets/noti_widget.dart';
import 'package:moass/widgets/top_bar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: TopBar(
          title: '알림',
          icon: Icons.notifications,
        ),
        body: Column(
          children: [NotiWidget()],
        ));
  }
}
