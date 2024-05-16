import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:moass/model/reservation_model.dart';
import 'package:moass/screens/reservation_user_step1.dart';
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
  late ReservationApi api;

  @override
  void initState() {
    super.initState();
    api = ReservationApi(
        dio: Dio(), storage: const FlutterSecureStorage()); // Initialize here
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
    var result = await api.myReservationinfo(); // API 호출
    setState(() {
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
    try {
      await api.reservationCancel(infoId);
      fetchReservations(); // 예약 목록 새로 고침
    } catch (e) {
      String errorMessage = '예약 취소 중 오류가 발생했습니다.';
      if (e is DioException && e.response?.statusCode == 404) {
        errorMessage = '예약한 당사자만 예약을 취소할 수 있습니다.';
      }
      _showErrorMessage(errorMessage);
    }
  }

  // 에러 메시지를 보여주는 다이얼로그
  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('오류'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy. MM. dd').format(selectedDate);
    DateTime now = DateTime.now();

    // 유효한 예약 항목 필터링
    List<MyReservationModel> validReservations = reservations
        .where((reservation) => now.isBefore(convertEndTimeFromIndex(
            reservation.infoDate, reservation.infoTime)))
        .toList();

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReservationUserStep1()),
                  );
                },
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
                    itemCount: validReservations.length,
                    itemBuilder: (context, index) {
                      var reservation = validReservations[index];
                      String timeSlot = convertTimeFromIndex(
                          reservation.infoTime); // 시간 변환 함수 호출
                      DateTime endTime = convertEndTimeFromIndex(
                          reservation.infoDate,
                          reservation.infoTime); // 끝나는 시간 변환 함수 호출

                      return GestureDetector(
                        onLongPress: () => _showCancelDialog(
                            context, reservation.infoId), // context 추가
                        child: Card(
                          margin: const EdgeInsets.all(8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color:
                                  index == 0 ? Colors.red : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
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
                                        top: Radius.circular(10.0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(reservation.reservationName),
                                      Text(reservation.infoName,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18)),
                                      const SizedBox(height: 8),
                                      // 프로필 이미지 리스트
                                      Row(
                                        children: reservation
                                            .userSearchInfoDtoList
                                            .map<Widget>((user) {
                                          return Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: CircleAvatar(
                                              backgroundImage: user.profileImg !=
                                                      null
                                                  ? NetworkImage(
                                                      '${user.profileImg}')
                                                  : const AssetImage(
                                                          'assets/img/nullProfile.png')
                                                      as ImageProvider,
                                              radius: 20,
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    ],
                                  )),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(10.0))),
                                child: Text(
                                    "${reservation.infoDate} at $timeSlot ~ ${DateFormat('HH:mm').format(endTime)}", // 시간 표시
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

// infoTime을 시작 시간으로 바꿔주는 함수
String convertTimeFromIndex(int index) {
  int hour = 9 + (index - 1) ~/ 2; // 9시부터 시작하므로
  int minute = (index % 2 == 1) ? 0 : 30;
  return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
}

// infoTime을 끝나는 시간으로 바꿔주는 함수
DateTime convertEndTimeFromIndex(String date, int index) {
  int hour = 9 + (index - 1) ~/ 2; // 9시부터 시작하므로
  int minute = (index % 2 == 1) ? 30 : 0;
  hour = (minute == 0) ? hour + 1 : hour; // 30분인 경우 시간 추가
  return DateTime.parse(
      '$date ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00');
}
