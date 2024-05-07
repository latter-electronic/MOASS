import 'package:flutter/material.dart';
import 'package:moass/screens/reservation_admin_create.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/reservation_box.dart';
import 'package:moass/widgets/top_bar.dart';

class ReservationAdminScreen extends StatelessWidget {
  ReservationAdminScreen({super.key});

  final List<Map<String, dynamic>> reservations = [
    {'type': '팀 미팅', 'time': '11:30 - 12:30'},
    {'type': '보드 예약', 'time': '14:00 - 15:00'},
    {'type': '팀 미팅', 'time': '15:30 - 16:30'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const TopBar(title: '시설/미팅 관리', icon: Icons.edit_calendar_outlined),
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
                        builder: (context) => const ReservationAdminCreate()),
                  );
                },
                child: const Text('시설/팀미팅 생성하기'),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CategoryText(text: '시설 / 팀미팅'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                return ReservationBox(title: '${reservations[index]['type']}');
              },
            ),
          ),
        ],
      ),
    );
  }
}
