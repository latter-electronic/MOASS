import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:moass/model/reservation_model.dart';
import 'package:moass/screens/reservation_screen.dart';
import 'package:moass/services/reservation_api.dart';

class NextReservation extends StatefulWidget {
  const NextReservation({
    super.key,
  });

  @override
  State<NextReservation> createState() => _NextReservationState();
}

class _NextReservationState extends State<NextReservation> {
  DateTime selectedDate = DateTime.now();
  List<MyReservationModel> reservations = [];
  bool isLoading = true;
  late ReservationApi api;

  @override
  void initState() {
    super.initState();
    api = ReservationApi(
        dio: Dio(), storage: const FlutterSecureStorage()); // Initialize here
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    setState(() => isLoading = true);
    var result = await api.myReservationinfo();
    setState(() {
      reservations = result
          .where((res) =>
              DateFormat('yyyy.MM.dd').format(DateTime.parse(res.infoDate)) ==
              DateFormat('yyyy.MM.dd').format(selectedDate))
          .toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // String formattedDate = DateFormat('yyyy. MM. dd').format(selectedDate);

    DateTime now = DateTime.now();

    // 유효한 예약 항목 필터링
    List<MyReservationModel> validReservations = reservations
        .where((reservation) => now.isBefore(convertEndTimeFromIndex(
            reservation.infoDate, reservation.infoTime)))
        .toList();

    return validReservations.isNotEmpty
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.2, // 적절한 높이 설정
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                var reservation = validReservations[index];
                String timeSlot =
                    convertTimeFromIndex(reservation.infoTime); // 시간 변환 함수 호출
                DateTime endTime = convertEndTimeFromIndex(reservation.infoDate,
                    reservation.infoTime); // 끝나는 시간 변환 함수 호출
                DateTime startTime = convertStartTimeFromIndex(
                    reservation.infoDate, reservation.infoTime);

                // 현재 시간과 예약 시간 사이의 경과 비율 계산
                double elapsedRatio =
                    now.isAfter(startTime) && now.isBefore(endTime)
                        ? (now.difference(startTime).inMinutes /
                            endTime.difference(startTime).inMinutes)
                        : now.isAfter(endTime)
                            ? 1.0
                            : 0.0;

                return Card(
                  clipBehavior: Clip.hardEdge,
                  margin: index == 0
                      ? const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
                      : const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 8.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFF6ECEF5),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 10, right: 10, bottom: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(reservation.infoName,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30)),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Color(int.parse(
                                            reservation.colorCode
                                                .replaceAll('#', '0xff'))),
                                        radius: 8,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(reservation.reservationName),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // const SizedBox(height: 8),
                            // 프로필 이미지 리스트
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                // borderRadius: BorderRadius.vertical(
                                //     top: Radius.circular(10.0)),
                              ),
                              child: Row(
                                children: reservation.userSearchInfoDtoList
                                    .map<Widget>((user) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, bottom: 6, top: 6),
                                    child: CircleAvatar(
                                      backgroundImage: user.profileImg != null
                                          ? NetworkImage('${user.profileImg}')
                                          : const AssetImage(
                                                  'assets/img/nullProfile.png')
                                              as ImageProvider,
                                      radius: 15,
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        clipBehavior: Clip.hardEdge,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: const [Color(0xFF00C1A6), Colors.white],
                                stops: [elapsedRatio, elapsedRatio + 0.01],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(10.0),
                                  top: Radius.circular(10.0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                      timeSlot, // 시간 표시
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                Text(
                                  DateFormat('HH:mm').format(endTime),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        : const SizedBox();
  }
}
