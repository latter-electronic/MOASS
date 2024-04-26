import 'package:flutter/material.dart';
import 'package:moass/widgets/top_bar.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopBar(
        title: '모음보드',
        icon: Icons.dashboard_outlined,
      ),
    );
  }
}
