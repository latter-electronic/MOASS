import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:moass/model/myprofile.dart';
import 'package:moass/model/reservation_model.dart';
import 'package:moass/services/myinfo_api.dart';
import 'package:moass/services/user_info_api.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/user_search_widget.dart';

class ReservationUserStep2 extends StatefulWidget {
  final ReservationDayModel reservation;
  final DateTime selectedDate;

  const ReservationUserStep2(
      {super.key, required this.reservation, required this.selectedDate});

  @override
  _ReservationUserStep2State createState() => _ReservationUserStep2State();
}

class _ReservationUserStep2State extends State<ReservationUserStep2> {
  // 내 정보 API 요청
  MyProfile? userProfile;
  // 선택 교육생들 리스트
  List<Map<String, String>> selectMembers = [];

  Future<void> fetchUserProfile() async {
    final profile =
        await MyInfoApi(dio: Dio(), storage: const FlutterSecureStorage())
            .fetchUserProfile();
    if (profile != null) {
      setState(() {
        userProfile = profile;
        selectMembers.add({
          'userName': profile.userName,
          'userId': profile.userId,
          'teamCode': profile.teamCode
        });
      });
    }
  }

// 팀 맴버 API 요청
  Future<void> fetchTeamMembers() async {
    final teamInfo =
        await UserInfoApi(dio: Dio(), storage: const FlutterSecureStorage())
            .getMyTeam();

    if (teamInfo != null) {
      setState(() {
        for (var user in teamInfo.users) {
          // 중복되는 userId가 있는지 확인
          var isUserExist =
              selectMembers.any((element) => element['userId'] == user.userId);

          // 중복되는 userId가 없으면 리스트에 추가
          if (!isUserExist) {
            selectMembers.add({
              'userName': user.userName,
              'userId': user.userId,
              'teamCode': user.teamCode
            });
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    fetchTeamMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('시설 / 팀미팅 예약')),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CategoryText(
                  text: DateFormat('yyyy.MM.dd').format(widget.selectedDate)),
            ],
          ),
          ReservationBox(
              reservation: widget.reservation,
              selectedDate: widget.selectedDate),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '참가자 설정',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // 배경색 설정
                borderRadius: BorderRadius.circular(10), // 경계면 둥글게 처리
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 70, // 최대 높이 설정
                  maxWidth: double.infinity, // 최대 너비 설정
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // 가로 스크롤 설정
                  child: Wrap(
                    spacing: 4.0, // 간격
                    runSpacing: 4.0, // 줄 간격
                    children: selectMembers
                        .map((member) => Chip(
                              labelPadding: const EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 0.0),
                              label: Text(
                                  '${member['teamCode']} ${member['userName']}',
                                  style: const TextStyle(fontSize: 12)),
                              deleteIcon: const Icon(Icons.close, size: 14),
                              onDeleted: () {
                                setState(() {
                                  selectMembers.removeWhere((element) =>
                                      element['userId'] == member['userId']);
                                });
                              },
                              backgroundColor: Colors.green[400],
                              labelStyle: const TextStyle(color: Colors.white),
                              deleteIconColor: Colors.white,
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
          const UserSearchWidget(),
        ],
      ),
    );
  }
}

// 예약 박스 class
class ReservationBox extends StatefulWidget {
  final ReservationDayModel reservation;
  final DateTime selectedDate;

  const ReservationBox({
    super.key,
    required this.reservation,
    required this.selectedDate,
  });

  @override
  _ReservationBoxState createState() => _ReservationBoxState();
}

class _ReservationBoxState extends State<ReservationBox> {
  List<int> selectedTimes = [];

  @override
  Widget build(BuildContext context) {
    List<String> times = generateTimes();
    int timeLimit = widget.reservation.timeLimit; // 예약 가능한 최대 시간 수

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 130,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(int.parse(
                  widget.reservation.colorCode.replaceAll('#', '0xff'))),
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(10)),
            ),
            child: Text(
              widget.reservation.reservationName,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Wrap(
              children: times.map((time) {
                int index = times.indexOf(time) + 1;
                bool isReserved = widget.reservation.reservationInfoList
                    .any((info) => info.infoTime == index);
                bool isSelected = selectedTimes.contains(index);

                // 클릭해서 리스트에 담을 수 있도록 + 리무브를 먼저 여부 확인 후 최대 시간에 미치는지 확인으로 동작오류 해결
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedTimes.remove(index);
                      } else {
                        if (!isReserved && selectedTimes.length < timeLimit) {
                          if (!isSelected) {
                            selectedTimes.add(index);
                          }
                        }
                      }
                    });
                    // 시간 선택이 맞게 들어갔는지 확인
                    print(selectedTimes);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: isReserved
                          ? Colors.blue.withOpacity(0.3)
                          : isSelected
                              ? Colors.blue[900] // 선택된 시간에 더 어두운 색상 적용
                              : Colors.blue,
                    ),
                    child:
                        Text(time, style: const TextStyle(color: Colors.white)),
                  ),
                );
              }).toList(),
            ),
          )
        ],
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
