// 탑 바
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  // final List<Widget>? actions;

  const TopBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black,
      elevation: 2,
      backgroundColor: Colors.blue.shade900,
      foregroundColor: Colors.blue.shade100,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 30,
        ),
      ),
      // actions: actions,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Default is 56.0
}
