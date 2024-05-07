import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationUserStep1 extends StatefulWidget {
  const ReservationUserStep1({super.key});

  @override
  _ReservationUserStep1State createState() => _ReservationUserStep1State();
}

class _ReservationUserStep1State extends State<ReservationUserStep1> {
  DateTime selectedDate = DateTime.now();

  void _changeDate(bool next) {
    setState(() {
      selectedDate = next
          ? selectedDate.add(const Duration(days: 1))
          : selectedDate.subtract(const Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy. MM. dd').format(selectedDate);

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
                    onPressed: () => _changeDate(false),
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () => _changeDate(true),
                  ),
                ],
              ),
            ),
            const ReservationBox(title: '팀 미팅'),
          ],
        ),
      ),
    );
  }
}

class ReservationBox extends StatelessWidget {
  final String title;

  const ReservationBox({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    List<String> times = [
      "09:00",
      "09:30",
      "10:00",
      "10:30",
      "11:00",
      "11:30",
      "12:00",
      "12:30",
      "13:00",
      "13:30",
      "14:00",
      "14:30",
      "15:00",
      "15:30",
      "16:00",
      "16:30",
      "17:00",
      "17:30"
    ];

    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.5),
          )
        ],
        color: Colors.white,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 100,
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Wrap(
                spacing: 3,
                runSpacing: 3,
                children: times
                    .map((time) => Padding(
                          padding: const EdgeInsets.all(1),
                          child: Container(
                            width:
                                (MediaQuery.of(context).size.width - 140) / 4,
                            height: 20,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              color: Colors.green,
                            ),
                            alignment: Alignment.center,
                            child: Text(time,
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
