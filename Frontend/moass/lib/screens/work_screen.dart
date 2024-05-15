// 장현욱

import 'package:flutter/material.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/gitlab_issue_card.dart';
import 'package:moass/widgets/gitlab_mr_card.dart';
import 'package:moass/widgets/schedule_box.dart';
import 'package:moass/widgets/top_bar.dart';

class WorkScreen extends StatelessWidget {
  const WorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱 바
      appBar: const TopBar(
        title: '업무',
        icon: Icons.work_rounded,
      ),

      // 바디
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 싸피 스케줄
          const CategoryText(text: 'SSAFY 스케줄'),
          const Align(
            alignment: Alignment.topRight, // 오른쪽 끝에 텍스트 정렬
            child: Text('2222. 02. 22(금)'),
          ),
          // 들어오는 데이터에 따라 반복문 구현(일정들)
          const ScheduleBox(title: '[Live] 생성형 AI 특강', time: '14:00-15:00'),

          // 스케줄과 지라 사이 간격 주기
          const SizedBox(
            height: 20,
          ),

          // 나의 지라
          const CategoryText(text: '나의 Gitlab Issue'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: DropdownButton(
                hint: const Text('프로젝트를 선택하세요'),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('S10P31E203')),
                  DropdownMenuItem(value: 2, child: Text('TIL')),
                ],
                onChanged: (int? value) {}),
          ),
          const GitlabIssueCardWidget(),
          const GitlabMRCardWidget(),
        ],
      ),
    );
  }
}
