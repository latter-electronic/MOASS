// 장현욱

import 'package:flutter/material.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/schedule_box.dart';

class ReservationAdminFix extends StatelessWidget {
  const ReservationAdminFix({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱 바
      appBar: AppBar(
        title: const Text('시설 / 팀미팅 수정'),
      ),

      // 바디
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 싸피 스케줄
          CategoryText(text: 'SSAFY 스케줄'),
          Align(
            alignment: Alignment.topRight, // 오른쪽 끝에 텍스트 정렬
            child: Text('2222. 02. 22(금)'),
          ),
          // 들어오는 데이터에 따라 반복문 구현(일정들)
          ScheduleBox(title: '[Live] 생성형 AI 특강', time: '14:00-15:00'),

          // 스케줄과 지라 사이 간격 주기
          SizedBox(
            height: 20,
          ),

          // 나의 지라
          CategoryText(text: '나의 Jira'),
        ],
      ),
    );
  }
}
