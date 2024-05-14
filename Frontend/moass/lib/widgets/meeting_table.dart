import 'package:flutter/material.dart';

class MeetingTable extends StatelessWidget {
  final String boxColor;
  final String reservationName;
  final String infoName;
  final int infoTime;

  const MeetingTable({
    super.key,
    required this.boxColor,
    required this.reservationName,
    required this.infoName,
    required this.infoTime,
  });

// 현재시간과 인덱스 시간
  String formatTimeSlot(int infoTime) {
    DateTime baseTime = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 9, 0);
    DateTime startTime = baseTime.add(Duration(minutes: 30 * (infoTime - 1)));
    DateTime endTime = startTime.add(const Duration(minutes: 30));
    return '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')} ~ ${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Color(int.parse(boxColor.replaceAll('#', '0xff')));
    Color labelColor = Colors.green;

    String timeSlot = formatTimeSlot(infoTime);
    DateTime now = DateTime.now();
    DateTime slotEndTime = DateTime(now.year, now.month, now.day,
        infoTime * 30 ~/ 60 + 9, (infoTime * 30) % 60);

    if (now.isAfter(slotEndTime)) {
      return Container(); // 시간이 지난 슬롯은 표시하지 않음
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 194, 222, 245),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: backgroundColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: labelColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              border: Border.all(color: backgroundColor),
            ),
            child: Text(
              reservationName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
                child: Text(
                  '팀 코드 : $infoName',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30.0, bottom: 3.0),
                child: Text(
                  timeSlot,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
