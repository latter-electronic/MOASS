import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // DateFormat을 사용하기 위해 추가
import 'package:moass/widgets/reservation_box.dart';

class ReservationUserStep1 extends StatefulWidget {
  const ReservationUserStep1({super.key});

  @override
  _ReservationUserStep1State createState() => _ReservationUserStep1State();
}

class _ReservationUserStep1State extends State<ReservationUserStep1> {
  DateTime selectedDate = DateTime.now(); // 현재 날짜로 초기화

  void _changeDate(bool next) {
    setState(() {
      // next가 true면 다음 날, false면 이전 날
      selectedDate = next
          ? selectedDate.add(const Duration(days: 1))
          : selectedDate.subtract(const Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('yyyy. MM. dd').format(selectedDate); // 날짜 포맷 설정

    return Scaffold(
      appBar: AppBar(
        title: const Text('시설 / 팀미팅 예약'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => _changeDate(false), // 이전 날짜
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () => _changeDate(true), // 다음 날짜
                  ),
                ],
              ),
            ),
            const ReservationBox(
              title: '팀 미팅',
            ),
          ],
        ),
      ),
    );
  }
}
