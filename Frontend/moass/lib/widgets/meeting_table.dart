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

  // 현재 시간과 인덱스 시간
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
    String timeSlot = formatTimeSlot(infoTime);
    DateTime now = DateTime.now();
    DateTime baseTime = DateTime(now.year, now.month, now.day, 9, 0);
    DateTime startTime = baseTime.add(Duration(minutes: 30 * (infoTime - 1)));
    DateTime endTime = startTime.add(const Duration(minutes: 30));

    if (now.isAfter(endTime)) {
      return Container(); // 시간이 지난 슬롯은 표시하지 않음
    }

    double elapsedRatio = (now.isAfter(startTime) && now.isBefore(endTime))
        ? (now.difference(startTime).inMinutes /
            endTime.difference(startTime).inMinutes)
        : (now.isAfter(endTime) ? 1.0 : 0.0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      child: Stack(
        children: [
          Container(
            height: 72,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: backgroundColor),
            ),
          ),
          Positioned.fill(
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: elapsedRatio,
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: backgroundColor,
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
