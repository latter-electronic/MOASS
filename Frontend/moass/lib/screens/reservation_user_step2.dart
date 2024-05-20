import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:moass/model/myprofile.dart';
import 'package:moass/model/reservation_model.dart';
import 'package:moass/screens/home_screen.dart';
import 'package:moass/services/myinfo_api.dart';
import 'package:moass/services/user_info_api.dart';
import 'package:moass/services/reservation_api.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/top_bar.dart';
import 'package:moass/widgets/user_search_widget.dart';

class ReservationUserStep2 extends StatefulWidget {
  final ReservationDayModel reservation;
  final DateTime selectedDate;

  const ReservationUserStep2({
    super.key,
    required this.reservation,
    required this.selectedDate,
  });

  @override
  _ReservationUserStep2State createState() => _ReservationUserStep2State();
}

class _ReservationUserStep2State extends State<ReservationUserStep2> {
  // 내 정보 API 요청
  MyProfile? userProfile;
  // 버튼 활성화 상태
  bool isButtonActive = false;
  // 예약 이름(기본값은 팀 코드로)
  late TextEditingController _reservationNameController;
  // 예약하기 API
  late ReservationApi api;
  // 선택 교육생들 리스트
  List<Map<String, String>> selectMembers = [];
  // 선택한 시간을 받아올 리스트
  List<int> selectedTimes = [];
  // ScrollController 추가
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _reservationNameController = TextEditingController(); // 초기에 빈 컨트롤러 생성
    api = ReservationApi(
        dio: Dio(), storage: const FlutterSecureStorage()); // 사용할 API파일 가져오기
    _scrollController = ScrollController(); // ScrollController 초기화
    fetchUserProfile().then((value) => fetchTeamMembers());
  }

  // 개인 정보를 불러오는 요청 함수
  Future<void> fetchUserProfile() async {
    final profile =
        await MyInfoApi(dio: Dio(), storage: const FlutterSecureStorage())
            .fetchUserProfile();
    if (profile != null) {
      setState(() {
        userProfile = profile;
        _reservationNameController.text =
            profile.teamCode ?? ''; // 사용자 정보가 로드된 후에 텍스트 업데이트
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
              selectMembers.any((profile) => profile["userId"] == user.userId);

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

  // 예약하기 API 호출
  Future<void> sendReservationRequest() async {
    try {
      Map<String, dynamic> requestData = {
        "reservationId": widget.reservation.reservationId,
        "infoName": _reservationNameController.text,
        "infoTimes": selectedTimes,
        "infoDate": DateFormat('yyyy-MM-dd').format(widget.selectedDate),
        "infoUsers": selectMembers
            .map(
              (user) => user['userId'],
            )
            .toList()
      };
      await api.reservationRequest(requestData);
      completeReservation(context);
      // 성공 다이얼로그 표시
    } catch (e) {
      // 실패 다이얼로그 표시
      showErrorDialog();
    }
  }

  @override
  void dispose() {
    // 위젯이 dispose 될 때 컨트롤러도 dispose 해줍니다.
    _reservationNameController.dispose();
    _scrollController.dispose(); // ScrollController도 dispose
    super.dispose();
  }

  // 예약 완료 팝업
  void completeReservation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('예약 완료'),
          content: const Text('예약이 성공적으로 등록되었습니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  // 예약 실패 팝업
  void showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('예약 실패'),
          content: const Text('예약 등록에 실패하였습니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  void onTimeSelected(int time) {
    setState(() {
      if (selectedTimes.contains(time)) {
        selectedTimes.remove(time);
      } else if (selectedTimes.length < widget.reservation.timeLimit) {
        selectedTimes.add(time);
      }
      updateButtonState();
    });
  }

  void updateButtonState() {
    setState(() {
      isButtonActive = selectedTimes.isNotEmpty;
    });
  }

  // 검색해서 데이터를 담아올 함수
  void addUserToSelectedList(Map<String, String> userData) {
    // 같은 userId를 가진 사용자가 리스트에 이미 있는지 검사
    bool userExists =
        selectMembers.any((member) => member['userId'] == userData['userId']);

    if (!userExists) {
      setState(() {
        selectMembers.add(userData);
        _scrollToEnd(); // 새 사용자를 추가한 후에 스크롤을 오른쪽 끝으로 이동
      });
    } else {}
  }

  // 새 사용자를 추가한 후에 스크롤을 오른쪽 끝으로 이동하는 함수
  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 예약 위젯 시작점
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
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CategoryText(
                //     text: DateFormat('yyyy.MM.dd').format(widget.selectedDate)),
                CategoryText(text: '시간 선택'),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                children: [
                  // Text(DateFormat('yyyy.MM.dd').format(widget.selectedDate)),
                  Text(
                      '시간을 선택해 주세요. (최대 ${widget.reservation.timeLimit * 30} 분)')
                ],
              ),
            ),
            ReservationBox(
              reservation: widget.reservation,
              selectedDate: widget.selectedDate,
              selectedTimes: selectedTimes,
              onTimeSelected: onTimeSelected,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryText(text: '회의 이름'),
              ],
            ),
            // 인풋 박스 아래에 넣기
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _reservationNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '회의 이름 : 최대 4글자',
                ),
              ),
            ),

            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CategoryText(
                    text: '참가자 설정',
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
                    controller: _scrollController, // ScrollController 추가
                    child: Wrap(
                      spacing: 4.0, // 간격
                      runSpacing: 4.0, // 줄 간격
                      children: selectMembers.map((member) {
                        bool isMyself = member['userId'] ==
                            userProfile?.userId; // 현재 사용자와 같은지 검사
                        return Chip(
                          labelPadding: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 0.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 1, vertical: 0),
                          side: const BorderSide(style: BorderStyle.none),
                          label: Text(
                              '${member['teamCode']} ${member['userName']}',
                              style: const TextStyle(fontSize: 12)),
                          deleteIcon: isMyself
                              ? const Icon(
                                  Icons.school_rounded,
                                  size: 14,
                                )
                              : const Icon(Icons.close,
                                  size: 14), // 조건에 따라 deleteIcon 설정
                          onDeleted: isMyself
                              ? () {}
                              : () {
                                  // 삭제 함수도 조건에 따라 설정
                                  setState(() {
                                    selectMembers.removeWhere((element) =>
                                        element['userId'] == member['userId']);
                                  });
                                },
                          backgroundColor: Colors.grey[200],
                          labelStyle: const TextStyle(color: Colors.black),
                          deleteIconColor: Colors.red,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            UserSearchWidget(
              onUserSelected: addUserToSelectedList,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: isButtonActive ? () => sendReservationRequest() : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isButtonActive ? Colors.blue : Colors.grey,
          ),
          child: Text('예약하기',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isButtonActive ? Colors.white : Colors.grey)),
        ),
      ),
    );
  }
}

// 예약 박스 class
class ReservationBox extends StatefulWidget {
  final ReservationDayModel reservation;
  final DateTime selectedDate;
  final List<int> selectedTimes;
  final Function(int) onTimeSelected;

  const ReservationBox({
    super.key,
    required this.reservation,
    required this.selectedDate,
    required this.selectedTimes,
    required this.onTimeSelected,
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
                      widget.onTimeSelected(index);
                      setState(() {});
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: isReserved
                          ? Colors.green.withOpacity(0.3)
                          : isSelected
                              ? Colors.green[900] // 선택된 시간에 더 어두운 색상 적용
                              : Colors.green,
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
