import 'package:flutter/material.dart';
import 'package:moass/widgets/top_bar.dart';

class SeatScreen extends StatelessWidget {
  const SeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopBar(
        title: '좌석',
        icon: Icons.calendar_view_month_rounded,
      ),
    );
  }
}
