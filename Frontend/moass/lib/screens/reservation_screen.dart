import 'package:flutter/material.dart';
import 'package:moass/screens/reservation_user_step1.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/top_bar.dart';

class ReservationScreen extends StatelessWidget {
  ReservationScreen({super.key});

  final List<Map<String, dynamic>> reservations = [
    {'type': '팀 미팅', 'time': '11:30 - 12:30'},
    {'type': '보드 예약', 'time': '14:00 - 15:00'},
    {'type': '팀 미팅', 'time': '15:30 - 16:30'},
  ];

  @override
  Widget build(BuildContext context) {
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
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 10.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReservationUserStep1()),
                  );
                },
                child: const Text('시설/팀미팅 예약하기'),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CategoryText(text: '나의 예약 리스트'),
            ),
          ),
          Expanded(
            child: Padding(
              // ListView 전체를 Padding으로 감싸기
              padding: const EdgeInsets.symmetric(horizontal: 8.0), // 좌우 여백 조정
              child: ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  var reservation = reservations[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 8.0, // 여기서 그림자 효과의 깊이를 조절합니다.
                    child: Material(
                      color: Colors.transparent, // Material의 배경색을 투명하게 설정
                      borderRadius: BorderRadius.circular(10.0), // 모서리를 둥글게 처리
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.blue, // Ink의 배경색 지정
                          borderRadius:
                              BorderRadius.circular(10.0), // 여기도 모서리 둥글게 처리
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                reservation['type'],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(10.0)),
                              ),
                              child: Text(reservation['time']),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
