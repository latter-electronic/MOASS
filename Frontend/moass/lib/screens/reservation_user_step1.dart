import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:moass/model/myprofile.dart';
import 'package:moass/model/reservation_model.dart';
import 'package:moass/screens/reservation_user_step2.dart';
import 'package:moass/services/myinfo_api.dart';
import 'package:moass/services/reservation_api.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/top_bar.dart';

class ReservationUserStep1 extends StatefulWidget {
  const ReservationUserStep1({super.key});

  @override
  _ReservationUserStep1State createState() => _ReservationUserStep1State();
}

class _ReservationUserStep1State extends State<ReservationUserStep1> {
  DateTime selectedDate = DateTime.now();
  List<ReservationDayModel> reservationDayData = [];
  late ReservationApi api;
  MyProfile? userProfile;

  @override
  void initState() {
    super.initState();
    api = ReservationApi(
        dio: Dio(), storage: const FlutterSecureStorage()); // Initialize
    fetchReservationData();
    fetchUserProfile();
  }

  // 개인 정보를 불러오는 요청 함수
  Future<void> fetchUserProfile() async {
    final profile =
        await MyInfoApi(dio: Dio(), storage: const FlutterSecureStorage())
            .fetchUserProfile();
    if (profile != null) {
      setState(() {
        userProfile = profile;
        // 'userName': profile.locationName;
        // 'userId': profile.classCode;
      });
    }
  }

// 날짜가 바뀔때마다 새로운 API요청
  void _changeDate(bool next) {
    setState(() {
      selectedDate = next
          ? selectedDate.add(const Duration(days: 1))
          : selectedDate.subtract(const Duration(days: 1));
    });
    fetchReservationData();
  }

  Future<void> fetchReservationData() async {
    var formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    var fetchedData = await api.reservationinfoDay(formattedDate);
    setState(() {
      reservationDayData = fetchedData ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(
        title: '시설 / 팀미팅 예약',
        icon: Icons.edit_calendar_outlined,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CategoryText(
                text:
                    '${userProfile?.locationName} / ${userProfile?.classCode} 반 예약 가능 목록'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => _changeDate(false)),
                  Text(DateFormat('yyyy-MM-dd').format(selectedDate),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () => _changeDate(true)),
                ],
              ),
            ),
            ...reservationDayData.map((data) =>
                ReservationBox(reservation: data, selectedDate: selectedDate)),
          ],
        ),
      ),
    );
  }
}

class ReservationBox extends StatelessWidget {
  final ReservationDayModel reservation;
  final DateTime selectedDate; // 부모 위젯에서 전달받음

  const ReservationBox(
      {super.key, required this.reservation, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    List<String> times = generateTimes();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReservationUserStep2(
              reservation: reservation,
              selectedDate: selectedDate,
            ),
          ),
        );
      },
      child: Container(
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 130,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(
                    int.parse(reservation.colorCode.replaceAll('#', '0xff'))),
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(10)),
              ),
              child: Text(
                reservation.reservationName,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Wrap(
                children: times.map((time) {
                  int index = times.indexOf(time) + 1;
                  bool isReserved = reservation.reservationInfoList
                      .any((info) => info.infoTime == index);
                  Color bgColor =
                      isReserved ? Colors.green.withOpacity(0.3) : Colors.green;
                  return Container(
                    margin: const EdgeInsets.all(2),
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: bgColor,
                    ),
                    child:
                        Text(time, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<String> generateTimes() {
    List<String> times = [];
    int startHour = 9; // 시작 시간 (9시)
    int endHour = 17; // 종료 시간 (17시 30분까지니까)

    for (int hour = startHour; hour <= endHour; hour++) {
      times.add('${hour.toString().padLeft(2, '0')}:00'); // 정시 추가
      if (hour < endHour || (hour == endHour && hour == 17)) {
        // 17:30도 포함
        times.add('${hour.toString().padLeft(2, '0')}:30'); // 30분 추가
      }
    }

    return times;
  }
}
