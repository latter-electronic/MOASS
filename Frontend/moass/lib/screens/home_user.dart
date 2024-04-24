import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black,
          elevation: 3,
          title: const Text('MOASS'),
        ),
        body: const Column(
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
        ));
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
