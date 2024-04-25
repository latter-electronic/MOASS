import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moass/widgets/top_bar.dart';

import '../widgets/category_text.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(title: '메인'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Flexible(
            flex: 2,
            child: CategoryText(
              text: '내 기기 상태',
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Flexible(
            flex: 10,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      decoration: const BoxDecoration(color: Colors.grey),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 90.0),
                        child: CategoryText(text: '기기 이미지 들어갈 곳'),
                      )),
                ),
              ],
            ),
          ),
          const Flexible(flex: 2, child: CategoryText(text: '내 상태 설정')),
          const Flexible(flex: 2, child: CategoryText(text: '다음 일정')),
          const Flexible(flex: 2, child: CategoryText(text: '할 일 목록')),
          const Flexible(flex: 2, child: CategoryText(text: '오늘 내 예약')),
        ],
      ),
    );
  }
}
