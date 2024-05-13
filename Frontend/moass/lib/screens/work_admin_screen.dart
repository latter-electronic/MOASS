import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/reservation_model.dart';
import 'package:moass/services/reservation_api.dart';
import 'package:moass/widgets/category_text.dart';
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

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    final api =
        ReservationApi(dio: Dio(), storage: const FlutterSecureStorage());
    final reservationData =
        await api.reservationinfoDay('2024-05-13'); // 예시 날짜, 수정 가능
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
    return Scaffold(
      appBar: const TopBar(
        title: '관리자 업무',
        icon: Icons.work_rounded,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : buildContent(),
    );
  }

  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CategoryText(text: 'SSAFY 스케줄'),
        const Align(
          alignment: Alignment.topRight,
          child: Text('2222. 02. 22(금)'),
        ),
        ...reservations.expand((reservation) => reservation.reservationInfoList
            .where((info) => info.infoState == 1)
            .map((info) => ScheduleBox(
                  title: reservation.reservationName,
                  time:
                      '${info.infoName} - ${info.infoTime}', // 시간 포맷은 상황에 맞게 조정
                ))),
        const SizedBox(height: 20),
        const CategoryText(text: '다음 미팅 일정'),
      ],
    );
  }
}
