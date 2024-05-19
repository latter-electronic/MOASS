import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:moass/model/scheduleModel.dart';
import 'package:moass/services/schedule_api.dart';
import 'package:moass/widgets/schedule_box.dart';

class CurrentSchedule extends ConsumerStatefulWidget {
  const CurrentSchedule({
    super.key,
  });

  @override
  _CurrentScheduleState createState() => _CurrentScheduleState();
}

class _CurrentScheduleState extends ConsumerState<CurrentSchedule> {
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
    if (!mounted) return;
    setState(() {
      courses = scheduleData.courses; // Schedule 데이터를 courses 리스트에 추가
      isLoading = false;
    });
  }

  bool isCurrentTimeInPeriod(String period) {
    final now = DateTime.now();
    final timeFormat = DateFormat('HH:mm');

    final times = period.split('~');
    if (times.length != 2) {
      return false;
    }

    final startTime = timeFormat.parse(times[0]);
    final endTime = timeFormat.parse(times[1]);

    final currentTime = timeFormat.parse('${now.hour}:${now.minute}');
    return currentTime.isAfter(startTime) && currentTime.isBefore(endTime);
  }

  @override
  Widget build(BuildContext context) {
    String displayDate = DateFormat('yyyy. MM. dd(EEE)', 'ko_KR')
        .format(DateTime.now()); // 한국어 요일 포함
    return SizedBox(
        height: 100,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                // Add Padding to ensure finite size
                padding: const EdgeInsets.all(16.0),
                child: buildContent(displayDate),
              ));
  }

  Widget buildContent(String displayDate) {
    final filteredCourses = courses
        .where((course) => isCurrentTimeInPeriod(course.period))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (filteredCourses.isNotEmpty)
          Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...filteredCourses.map((course) => ScheduleBox(
                      title: course.title,
                      time: course.period,
                    )),
              ],
            ),
          )
        else
          const Center(
            child: Text('현재 시간에 배정된 일정이 없습니다'),
          ),
      ],
    );
  }
}
