// 장현욱 작성
// 바텀 네비게이션 위젯

import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onItemSelected,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.work_outline_outlined), label: 'Work'),
        BottomNavigationBarItem(
            icon: Icon(Icons.edit_calendar_outlined), label: 'Reservation'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.event_seat_outlined), label: 'Seat'),
        BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined), label: 'Board'),
      ],
      unselectedItemColor: Colors.grey.shade400,
      selectedItemColor: Colors.amber[800],
    );
  }
}
