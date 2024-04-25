import 'package:flutter/material.dart';
import 'package:moass/widgets/top_bar.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopBar(title: '메인'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryText(),
          SizedBox(
            height: 5,
          ),
          Text('내 상태 설정'),
          Text('다음 일정'),
          Text('할 일 목록'),
          Text('오늘 내 예약'),
        ],
      ),
    );
  }
}

class CategoryText extends StatelessWidget {
  const CategoryText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      '내 기기 상태',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    );
  }
}
