import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:moass/model/reservation_model.dart';
import 'package:moass/services/reservation_api.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/top_bar.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime selectedDate = DateTime.now();
  List<MyReservationModel> reservations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  void _changeDate(bool next) {
    setState(() {
      selectedDate = next
          ? selectedDate.add(const Duration(days: 1))
          : selectedDate.subtract(const Duration(days: 1));
    });
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    setState(() => isLoading = true);
    var api = ReservationApi(dio: Dio(), storage: const FlutterSecureStorage());
    var result = await api.myReservationinfo(); // API 호출
    setState(() {
      // null 체크
      reservations = result
          .where((res) =>
              DateFormat('yyyy.MM.dd').format(DateTime.parse(res.infoDate)) ==
              DateFormat('yyyy.MM.dd').format(selectedDate))
          .toList();
      isLoading = false;
    });
  }

  // 예약 취소 확인 대화상자
  void _showCancelDialog(BuildContext context, int infoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('예약 취소'),
          content: const Text('이 예약을 취소하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                _cancelReservation(infoId);
              },
            ),
          ],
        );
      },
    );
  }

// 예약 취소 요청
  void _cancelReservation(int infoId) async {
    var api = ReservationApi(dio: Dio(), storage: const FlutterSecureStorage());
    await api.reservationCancel(infoId);
    fetchReservations(); // 예약 목록 새로 고침
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy. MM. dd').format(selectedDate);

    return Scaffold(
      appBar:
          const TopBar(title: '시설/미팅 예약', icon: Icons.edit_calendar_outlined),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFF6ECEF5)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 10.0)),
                ),
                onPressed: () {},
                child: const Text('시설/팀미팅 예약하기'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => _changeDate(false)),
                Text(formattedDate,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () => _changeDate(true)),
              ],
            ),
          ),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: CategoryText(text: '나의 예약 리스트'))),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: reservations.length,
                    itemBuilder: (context, index) {
                      var reservation = reservations[index];
                      String timeSlot = convertTimeFromIndex(
                          reservation.infoTime); // 시간 변환 함수 호출

                      return GestureDetector(
                        onLongPress: () => _showCancelDialog(
                            context, reservation.infoId), // context 추가
                        child: Card(
                          margin: const EdgeInsets.all(8.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 8.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(8.0),
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10.0))),
                                  child: Text(reservation.infoName,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18))),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(10.0))),
                                child: Text(
                                    "${reservation.infoDate} at $timeSlot", // 시간 표시
                                    style:
                                        const TextStyle(color: Colors.black54)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// infoTime을 시간으로 바꿔주는 함수
String convertTimeFromIndex(int index) {
  int hour = 9 + (index - 1) ~/ 2; // 9시부터 시작하므로
  int minute = (index % 2 == 1) ? 0 : 30;
  return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
}
