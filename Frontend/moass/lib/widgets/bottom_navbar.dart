// 장현욱
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
        BottomNavigationBarItem(icon: Icon(Icons.work_rounded), label: '업무'),
        BottomNavigationBarItem(
            icon: Icon(Icons.edit_calendar_outlined), label: '예약'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_month_rounded), label: '좌석'),
        BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined), label: '모음보드'),
      ],
      unselectedItemColor: Colors.grey.shade400,
      selectedItemColor: const Color(0xFF6ECEF5),
    );
  }
}
