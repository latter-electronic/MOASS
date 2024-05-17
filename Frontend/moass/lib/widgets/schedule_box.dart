import 'package:flutter/material.dart';

class ScheduleBox extends StatelessWidget {
  final String title, time;

  const ScheduleBox({
    super.key,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.5),
          )
        ],
      ),
      clipBehavior: Clip.hardEdge,
      width: 350,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 스케쥴 이름
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(color: Color(0xFF6ECEF5)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            // 스케쥴 시간
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(time),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
