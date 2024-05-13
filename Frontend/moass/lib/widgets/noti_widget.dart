import 'package:flutter/material.dart';

class NotiWidget extends StatelessWidget {
  const NotiWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF6ECEF5), width: 2.0),
            borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Image.asset(
                      'assets/img/noti_icon.png',
                      width: 30,
                    ),
                  ),
                  const Text(
                    '알림',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Text('알림 내용'))
            ],
          ),
        ),
      ),
    );
  }
}
