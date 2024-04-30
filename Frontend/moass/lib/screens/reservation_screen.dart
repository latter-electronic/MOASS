import 'package:flutter/material.dart';
import 'package:moass/widgets/top_bar.dart';

class ReservationScreen extends StatelessWidget {
  const ReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopBar(
        title: '유저 예약',
        icon: Icons.edit_calendar_outlined,
      ),
    );
  }
}
