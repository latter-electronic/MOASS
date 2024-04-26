// 장현욱
// 탑 바
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  // final List<Widget>? actions;
  final IconData icon;

  const TopBar({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black,
      elevation: 2,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
      title: Row(
        mainAxisSize: MainAxisSize.min, // 이 속성으로 인해 아이템들이 타이틀 중간이 아닌 시작 부분에 위치
        children: [
          Icon(icon, color: const Color(0xFF6ECEF5)), // 아이콘 색상 조정
          const SizedBox(width: 10), // 아이콘과 텍스트 사이 간격
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Default is 56.0
}
