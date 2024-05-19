import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/reservation_model.dart';
import 'package:moass/model/scheduleModel.dart';
import 'package:moass/services/reservation_api.dart';
import 'package:moass/services/schedule_api.dart'; // ScheduleApi 가져오기
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/meeting_table.dart';
import 'package:moass/widgets/schedule_box.dart';
import 'package:moass/widgets/top_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 추가

class WorkAdminScreen extends ConsumerStatefulWidget {
  const WorkAdminScreen({super.key});

  @override
  _WorkAdminScreenState createState() => _WorkAdminScreenState();
}

class _WorkAdminScreenState extends ConsumerState<WorkAdminScreen> {
  List<ReservationDayModel> reservations = [];
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
      fetchReservations();
      fetchScheduleData(); // Schedule 데이터 가져오기
    });
  }

  Future<void> fetchReservations() async {
    final api =
        ReservationApi(dio: Dio(), storage: const FlutterSecureStorage());
    final reservationData = await api.reservationinfoDay(formattedDate);
    if (reservationData != null) {
      setState(() {
        reservations =
            reservationData.where((res) => res.category == '1').toList();
        isLoading = false;
      });
    }
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
        title: '관리자 업무',
        icon: Icons.work_rounded,
      ),
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
        Align(
          alignment: Alignment.center,
          child: Column(
            children: courses.isEmpty
                ? [
                    const SizedBox(height: 20),
                    const Text(
                      '오늘은 일정이 없어요!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                : courses
                    .map((course) => ScheduleBox(
                          title: course.title,
                          time: course.period,
                        ))
                    .toList(),
          ),
        ),
        const SizedBox(height: 20),
        const CategoryText(text: '예약 일정'),
        Align(
          alignment: Alignment.topRight,
          child: Text(displayDate),
        ),
        ...reservations.expand((reservation) => reservation.reservationInfoList
            .where((info) => info.infoState == 1)
            .map((info) => MeetingTable(
                  boxColor: reservation.colorCode,
                  reservationName: reservation.reservationName,
                  infoName: info.infoName,
                  infoTime: info.infoTime,
                ))),
      ],
    );
  }
}
