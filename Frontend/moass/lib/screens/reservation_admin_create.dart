// 장현욱

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/myprofile.dart';
import 'package:moass/screens/home_screen.dart';
import 'package:moass/services/reservation_api.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/services/myinfo_api.dart';

class ReservationAdminCreate extends StatefulWidget {
  const ReservationAdminCreate({super.key});
  @override
  State<ReservationAdminCreate> createState() => _ReservationAdminCreateState();
}

class _ReservationAdminCreateState extends State<ReservationAdminCreate> {
  final TextEditingController _nameController =
      TextEditingController(text: '팀 미팅'); // 올바른 초기화
  Color _currentColor = Colors.blue; // 기본 색상을 보이는 색으로 설정
  int _currentLimit = 30; // 최소 시간 제한으로 기본 설정
  // 예약하기 API
  late ReservationApi api;
  MyProfile? userProfile;
  List<int> _selectedTimes = []; // 여기에 선택된 시간을 저장합니다.
  bool _isNotificationEnabled = false; // 체크박스 상태 변수, 기본값은 true

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateText); // 리스너 추가
    api = ReservationApi(
        dio: Dio(), storage: const FlutterSecureStorage()); // 사용할 API파일 가져오기
    // 아래 코드는 _currentLimit 값이 드롭다운 메뉴 아이템에 포함되지 않은 경우 기본값을 설정합니다.
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

  @override
  void dispose() {
    _nameController.removeListener(_updateText); // 리스너 제거
    _nameController.dispose();
    super.dispose();
  }

  void _updateText() {
    setState(() {
      // 이곳에서는 단순히 setState만 호출합니다. 입력 필드의 변화에 따라 UI를 갱신하기 위함입니다.
    });
  }

  // 이 함수를 자식 위젯에서 호출하여 선택된 시간을 업데이트합니다.
  void updateSelectedTimes(List<int> selectedTimes) {
    setState(() {
      _selectedTimes = selectedTimes;
    });
  }

  // // 예약 수정 요청 API 호출
  // // 예약하기 API 호출
  Future<void> sendReservationCreate() async {
    try {
      Map<String, dynamic> createData = {
        "classCode": userProfile?.classCode,
        "category": _isNotificationEnabled ? '1' : '2',
        "timeLimit": _currentLimit ~/ 30,
        "reservationName": _nameController.text,
        "colorCode":
            '#${_currentColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
        "infoTimes": _selectedTimes
      };
      await api.reservationCreate(createData);
      completeCreate(context);
      // 성공 다이얼로그 표시
    } catch (e) {
      // 실패 다이얼로그 표시
      showErrorDialog();
    }
  }

  // 예약 완료 팝업
  void completeCreate(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('예약 생성 완료'),
          content: const Text('예약 생성이 성공적으로 등록되었습니다.'),
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
          title: const Text('예약 생성 실패'),
          content: const Text('예약 생성에 실패하였습니다.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('예약 생성'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '시설 / 예약 이름',
                ),
              ),
            ),
            ListTile(
              title: const Text('패널 색 변경:'),
              trailing: CircleAvatar(
                backgroundColor: _currentColor,
              ),
              onTap: () async {
                Color? newColor = await pickColor(context, _currentColor);
                if (newColor != null) {
                  setState(() {
                    _currentColor = newColor;
                  });
                }
              },
            ),
            ListTile(
              title: const Text('최대 예약 시간:'),
              trailing: DropdownButton<int>(
                value: _currentLimit,
                items: List.generate(6, (index) => 30 * (index + 1))
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value 분'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _currentLimit = newValue!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('업무 탭에 예약 표출'),
              trailing: Checkbox(
                value: _isNotificationEnabled,
                onChanged: (bool? value) {
                  setState(() {
                    _isNotificationEnabled = value!;
                  });
                },
              ),
            ),
            const CategoryText(
              text: '예약 불가 시간 설정',
              padding: EdgeInsets.only(
                  top: 20.0, bottom: 5, left: 10.0, right: 10.0),
            ),
            const Text('      * 예약을 금지할 시간을 선택해 주세요.',
                style: TextStyle(
                  fontSize: 12,
                )),
            ReservationBox(
              onUpdateSelectedTimes: updateSelectedTimes, // 콜백 함수 전달
              currentColor: _currentColor, // 현재 색상을 전달
              nameController: _nameController, // 컨트롤러를 전달
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: sendReservationCreate,
                child: const Text('생성하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Color?> pickColor(BuildContext context, Color currentColor) async {
  Color? pickedColor = currentColor; // 초기 색상을 임시 변수에 저장

  return showDialog<Color>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('색상 선택'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: (Color color) {
              pickedColor = color; // 사용자가 선택한 색상을 임시 변수에 저장
            },
            enableAlpha: true, // 투명도 조절 가능
          ),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(pickedColor); // 선택한 색상으로 대화상자 닫기
              },
              child: const Text('결정')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 변경 없이 대화상자 닫기
              },
              child: const Text('취소')),
        ],
      );
    },
  );
}

class ReservationBox extends StatefulWidget {
  final Function(List<int>) onUpdateSelectedTimes; // 콜백 함수 타입 정의
  final Color currentColor; // 색상 인자 추가
  final TextEditingController nameController; // TextEditingController 인자 추가

  const ReservationBox({
    super.key,
    required this.onUpdateSelectedTimes, // 콜백 함수를 인자로 추가
    required this.currentColor, // 인자를 필수로 설정
    required this.nameController, // 인자를 필수로 설정
  });

  @override
  _ReservationBoxState createState() => _ReservationBoxState();
}

class _ReservationBoxState extends State<ReservationBox> {
  List<int> selectedTimes = [];

  List<String> generateTimes() {
    List<String> times = [];
    int startHour = 9; // 시작 시간 (9시)
    int endHour = 17; // 종료 시간 (17시 30분까지니까)

    for (int hour = startHour; hour <= endHour; hour++) {
      times.add('${hour.toString().padLeft(2, '0')}:00'); // 정시 추가
      if (hour < endHour || (hour == endHour && hour == 17)) {
        times.add('${hour.toString().padLeft(2, '0')}:30'); // 30분 추가
      }
    }

    return times;
  }

  @override
  Widget build(BuildContext context) {
    List<String> times = generateTimes();

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
              color: widget.currentColor, // widget을 통해 상위에서 전달된 색상 사용
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(10)),
            ),
            child: Text(
              widget.nameController.text, // widget을 통해 전달된 컨트롤러 사용
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

                // 선택 함수
                bool isSelected = selectedTimes.contains(index);
                Color bgColor = isSelected ? Colors.red : Colors.green;
                String text = time;
                TextStyle textStyle = const TextStyle(color: Colors.black);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedTimes.remove(index);
                      } else {
                        selectedTimes.add(index);
                      }
                      widget.onUpdateSelectedTimes(selectedTimes);
                    });
                  },
                  child: Container(
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
                      fit: BoxFit.scaleDown,
                      child: Text(text, style: textStyle),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
