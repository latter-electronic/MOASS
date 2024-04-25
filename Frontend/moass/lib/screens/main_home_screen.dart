import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moass/widgets/top_bar.dart';

import '../widgets/category_text.dart';
import '../widgets/schedule_box.dart';

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
          Flexible(
            flex: 8,
            child: Expanded(
              child: Container(
                  height: 1000,
                  decoration: const BoxDecoration(color: Colors.grey),
                  child:
                      const Center(child: CategoryText(text: '기기 이미지 들어갈 곳'))),
            ),
          ),
          const Flexible(flex: 2, child: CategoryText(text: '내 상태 설정')),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFF3DB887),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: const Center(
                    child: Text('착석 중', style: TextStyle(color: Colors.white))),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFBC1F),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: const Center(
                    child:
                        Text('자리 비움', style: TextStyle(color: Colors.white))),
              ),
            ],
          ),
          const Flexible(flex: 2, child: CategoryText(text: '다음 일정')),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScheduleBox(title: '[Live] 생성형 AI 특강', time: '14:00-15:00'),
              ScheduleBox(title: '[자울PJT] 프로젝트 진행', time: '15:00-18:00'),
            ],
          ),
          const Flexible(flex: 2, child: CategoryText(text: '할 일 목록')),
          const Flexible(flex: 2, child: CategoryText(text: '오늘 내 예약')),
          const Column(
            children: [
              ScheduleBox(title: '플립보드 1', time: '10:00 - 11:00'),
              ScheduleBox(title: '팀 미팅', time: '11:00 - 12:00'),
            ],
          )
        ],
      ),
    );
  }
}
