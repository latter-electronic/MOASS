import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/reservation_model.dart';
import 'package:moass/services/reservation_api.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/meeting_table.dart';
import 'package:moass/widgets/schedule_box.dart';
import 'package:moass/widgets/top_bar.dart';

class WorkAdminScreen extends StatefulWidget {
  const WorkAdminScreen({super.key});

  @override
  _WorkAdminScreenState createState() => _WorkAdminScreenState();
}

class _WorkAdminScreenState extends State<WorkAdminScreen> {
  List<ReservationDayModel> reservations = [];
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
    });
  }

  Future<void> fetchReservations() async {
    final api =
        ReservationApi(dio: Dio(), storage: const FlutterSecureStorage());
    final reservationData = await api.reservationinfoDay(formattedDate);
    print('예약: $reservationData');
    if (reservationData != null) {
      setState(() {
        reservations =
            reservationData.where((res) => res.category == '1').toList();
        isLoading = false;
      });
    }
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
            : buildContent(displayDate),
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
        ...reservations.expand((reservation) => reservation.reservationInfoList
            .where((info) => info.infoState == 1)
            .map((info) => ScheduleBox(
                  title: reservation.reservationName,
                  time: '${info.infoName} - ${info.infoTime}',
                ))),
        const SizedBox(height: 20),
        const CategoryText(text: '미팅 일정'),
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
