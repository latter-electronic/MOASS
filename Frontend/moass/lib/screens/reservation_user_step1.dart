import 'package:flutter/material.dart';

class ReservationUserStep1 extends StatelessWidget {
  const ReservationUserStep1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('예약하기: 단계 1'),
      ),
      body: const Center(
        child: Text('여기에 예약 단계별 내용 구현'),
      ),
    );
  }
}
