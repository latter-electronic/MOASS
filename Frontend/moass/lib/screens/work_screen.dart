// 장현욱

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:moass/model/scheduleModel.dart';
import 'package:moass/services/schedule_api.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/schedule_box.dart';
import 'package:moass/widgets/top_bar.dart';
import 'package:lottie/lottie.dart'; // 로티임포트
import '../widgets/my_gitlab_issue.dart';

class WorkScreen extends ConsumerStatefulWidget {
  const WorkScreen({super.key});

  @override
  _WorkScreenState createState() => _WorkScreenState();
}

class _WorkScreenState extends ConsumerState<WorkScreen> {
  List<Course> courses = []; // Schedule 데이터를 담을 리스트 추가
  bool isLoading = true;
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR').then((_) {
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      });
      fetchScheduleData(); // Schedule 데이터 가져오기
    });
  }

  Future<void> fetchScheduleData() async {
    final api = ScheduleApi(dio: Dio(), storage: const FlutterSecureStorage());
    final scheduleData = await api.fetchSchedule(formattedDate);
    setState(() {
      courses = scheduleData.courses; // Schedule 데이터를 courses 리스트에 추가
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String displayDate = DateFormat('yyyy. MM. dd(EEE)', 'ko_KR')
        .format(DateTime.now()); // 한국어 요일 포함

    return Scaffold(
      appBar: const TopBar(
        title: '업무',
        icon: Icons.work_rounded,
      ),

      // 바디
      body: SingleChildScrollView(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: buildContent(displayDate),
              ),
      ),
    );
  }

  Widget buildContent(String displayDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CategoryText(text: 'SSAFY 스케줄'),
        Align(
          alignment: Alignment.topRight,
          child: Text(displayDate),
        ),
        if (courses.isEmpty) ...[
          //📲 json 확장자 명까지 써주어야 합니다
          //📲 repeat > 반복 옵션
          //📲 animate > 움직이는 옵션
          //📲 그외에도 많은 옵션들이 있으니 테스트 해보시면 됩니다
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('오늘은 일정이 없어요!'),
                  SizedBox(
                    width: 200, // 원하는 너비
                    height: 200, // 원하는 높이
                    child: Lottie.asset(
                      'assets/img/noDataCat.json',
                      repeat: true,
                      animate: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ] else ...[
          Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...courses.map((course) => ScheduleBox(
                      title: course.title,
                      time: course.period,
                    )),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),

        // 나의 지라
        const CategoryText(text: '나의 Gitlab 프로젝트'),
        const MyGitlabIssue(),
      ],
    );
  }
}
