// 장현욱

import 'package:flutter/material.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/gitlab_issue_card.dart';
import 'package:moass/widgets/gitlab_mr_card.dart';
import 'package:moass/widgets/schedule_box.dart';
import 'package:moass/widgets/top_bar.dart';

import '../widgets/my_gitlab_issue.dart';

class WorkScreen extends StatelessWidget {
  const WorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // 앱 바
      appBar: TopBar(
        title: '업무',
        icon: Icons.work_rounded,
      ),

      // 바디
      body: Column(
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
          CategoryText(text: '나의 Gitlab 프로젝트'),
          MyGitlabIssue(),
        ],
      ),
    );
  }
}
