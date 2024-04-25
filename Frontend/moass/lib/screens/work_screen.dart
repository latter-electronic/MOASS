import 'package:flutter/material.dart';

class WorkScreen extends StatelessWidget {
  const WorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.blue.shade100,
        title: Row(
          mainAxisSize:
              MainAxisSize.min, // 이 속성으로 인해 아이템들이 타이틀 중간이 아닌 시작 부분에 위치
          children: [
            Icon(Icons.work_outline, color: Colors.blue.shade100), // 아이콘 색상 조정
            const SizedBox(width: 10), // 아이콘과 텍스트 사이 간격
            const Text(
              "업무",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: const Center(
        child: Text('Work Screen Content'),
      ),
    );
  }
}
