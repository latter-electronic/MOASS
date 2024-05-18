import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:moass/model/myprofile.dart';
import 'package:moass/model/reservation_model.dart';
import 'package:moass/screens/reservation_admin_create.dart';
import 'package:moass/screens/reservation_admin_fix.dart';
import 'package:moass/services/myinfo_api.dart';
import 'package:moass/services/reservation_api.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/top_bar.dart';

class ReservationAdminScreen extends StatefulWidget {
  const ReservationAdminScreen({super.key});

  @override
  State<ReservationAdminScreen> createState() => _ReservationAdminScreenState();
}

class _ReservationAdminScreenState extends State<ReservationAdminScreen> {
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
    // 시간 여기 한번 지워보기
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    return Scaffold(
      appBar:
          const TopBar(title: '시설/미팅 관리', icon: Icons.edit_calendar_outlined),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 지역,반정보 확인
            Center(
              child: CategoryText(
                text:
                    '${userProfile?.locationName} / ${userProfile?.classCode}반 시설/미팅',
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey, // 구분선 색상
                    width: 1.0, // 구분선 두께
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  // 시설 생성 버튼
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF6ECEF5)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                            builder: (context) =>
                                const ReservationAdminCreate()),
                      );
                    },
                    child: const Text('시설/팀미팅 생성하기'),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => _changeDate(false)),
                  Text(formattedDate,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () => _changeDate(true)),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text('*시설 예약 현황 및 수정'),
            ),
            // 시설 목록 현황박스
            ...reservationDayData.map((data) =>
                ReservationBox(reservation: data, selectedDate: formattedDate)),
          ],
        ),
      ),
    );
  }
}

class ReservationBox extends StatelessWidget {
  final ReservationDayModel reservation;
  final String selectedDate; // 부모 위젯에서 전달받음

  const ReservationBox({
    super.key,
    required this.reservation,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    List<String> times = generateTimes();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReservationAdminFix(
              reservation: reservation,
              selectedDate: selectedDate,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
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
                // 각각의 시간 테이블에 빈문자열과 0으로 정의를 해줘야 탐색이 돌아감...
                children: times.map((time) {
                  int index = times.indexOf(time) + 1;
                  var info = reservation.reservationInfoList.firstWhere(
                    (i) => i.infoTime == index,
                    orElse: () => ReservationInfoListDto(
                      createdAt: '',
                      updatedAt: '',
                      infoId: 0,
                      reservationId: reservation.reservationId,
                      userId: '',
                      infoState: 0,
                      infoName: '',
                      infoDate: '',
                      infoTime: index,
                    ), // Default values if not found
                  );

                  Color bgColor = Colors.green;
                  String text = time;
                  TextStyle textStyle = const TextStyle(color: Colors.black);

                  if (info.infoState == 1) {
                    String suffix =
                        info.infoName.substring(info.infoName.length - 2);
                    switch (suffix) {
                      case '01':
                        bgColor = Colors.orange;
                        text = info
                            .infoName; // Show name or any status description
                        textStyle = const TextStyle(color: Colors.black26);
                        break;

                      case '02':
                        bgColor = Colors.yellow;
                        text = info
                            .infoName; // Show name or any status description
                        textStyle = const TextStyle(color: Colors.black26);
                        break;

                      case '03':
                        bgColor = Colors.blue.withOpacity(0.3);
                        text = info
                            .infoName; // Show name or any status description
                        textStyle = const TextStyle(color: Colors.black26);
                        break;

                      case '04':
                        bgColor = Colors.indigo.withOpacity(0.3);
                        text = info
                            .infoName; // Show name or any status description
                        textStyle = const TextStyle(color: Colors.black26);
                        break;

                      case '05':
                        bgColor = Colors.purple.withOpacity(0.3);
                        text = info
                            .infoName; // Show name or any status description
                        textStyle = const TextStyle(color: Colors.black26);
                        break;

                      case '06':
                        bgColor = Colors.pink.withOpacity(0.3);
                        text = info
                            .infoName; // Show name or any status description
                        textStyle = const TextStyle(color: Colors.black26);
                        break;

                      case '07':
                        bgColor = Colors.lime.withOpacity(0.3);
                        text = info
                            .infoName; // Show name or any status description
                        textStyle = const TextStyle(color: Colors.black26);
                        break;

                      case '08':
                        bgColor = Colors.brown.withOpacity(0.3);
                        text = info
                            .infoName; // Show name or any status description
                        textStyle = const TextStyle(color: Colors.black26);
                        break;

                      case '09':
                        bgColor = Colors.teal.withOpacity(0.3);
                        text = info
                            .infoName; // Show name or any status description
                        textStyle = const TextStyle(color: Colors.black26);
                        break;

                      case '10':
                        bgColor = Colors.cyan.withOpacity(0.3);
                        text = info
                            .infoName; // Show name or any status description
                        textStyle = const TextStyle(color: Colors.black26);
                        break;

                      case != '':
                        bgColor = Colors.green.withOpacity(0.3);
                        text = info
                            .infoName; // Show name or any status description
                        textStyle = const TextStyle(color: Colors.black26);
                        break;
                    }
                  } else if (info.infoState == 2 || info.infoState == 3) {
                    bgColor = Colors.grey.withOpacity(0.3);
                    textStyle = const TextStyle(color: Colors.black26);
                  }

                  return Container(
                    width: 57,
                    height: 22,
                    margin: const EdgeInsets.all(2),
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: bgColor,
                    ),
                    child: FittedBox(
                      fit: BoxFit
                          .scaleDown, // Ensures the text does not overflow and scales down
                      child: Text(text, style: textStyle),
                    ),
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
