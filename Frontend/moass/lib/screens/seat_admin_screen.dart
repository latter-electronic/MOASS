import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/myprofile.dart';
import 'package:moass/model/user_info.dart';
import 'package:moass/services/device_api.dart';
import 'package:moass/services/myinfo_api.dart';
import 'package:moass/services/user_info_api.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/seat_map.dart';
import 'package:moass/widgets/top_bar.dart';
import 'package:moass/widgets/user_search_for_call.dart';

class SeatAdminScreen extends StatefulWidget {
  const SeatAdminScreen({
    super.key,
  });

  @override
  State<SeatAdminScreen> createState() => _SeatScreenState();
}

class _SeatScreenState extends State<SeatAdminScreen> {
  MyProfile? myProfile;
  bool isLoading = true;
  late MyInfoApi api;
  FocusNode textfocus = FocusNode();
  CampusInfo? campusInfo;
  List campusList = ['서울캠퍼스', '대전캠퍼스', '광주캠퍼스', '구미캠퍼스', '부울경캠퍼스'];
  List campusCode = ['A', 'B', 'C', 'D', 'E'];
  int? selectedCampusIndex;
  String selectedCampusCode = "";
  List<String> selectedCampusClasses = [];
  String? selectedClass;
  String selectedClassCode = "";

  @override
  void initState() {
    api = MyInfoApi(dio: Dio(), storage: const FlutterSecureStorage());

    fetchMyInfo();
    super.initState();
  }

  Future<void> fetchMyInfo() async {
    setState(() => isLoading = true);
    // var api = ReservationApi(dio: Dio(), storage: const FlutterSecureStorage());
    var result = await api.fetchUserProfile(); // API 호출
    setState(() {
      // null 체크
      myProfile = result;

      isLoading = false;
    });
  }

  // 교육생 검색 관련 변수
  bool isOpenedButtonWidget = false;

  void toggleOpenButtonWidget() {
    setState(() {
      isOpenedButtonWidget = !isOpenedButtonWidget;
    });
  }

  String callUserId = "";

  void setUserId(String value) {
    setState(() {
      callUserId = value;
    });
  }

  String? inputText;
  late Future<List<UserInfo>> searchedUserList =
      UserInfoApi(dio: Dio(), storage: const FlutterSecureStorage())
          .fetchUserProfile(inputText);

  searchUser(value) {
    searchedUserList =
        UserInfoApi(dio: Dio(), storage: const FlutterSecureStorage())
            .fetchUserProfile(value);
  }

  // Refresh 아이콘을 누를 때 호출되는 콜백 함수
  void handleRefresh() {
    fetchMyInfo(); // 사용자 정보를 다시 불러옴
    selectedCampusIndex = null;
    selectedClass = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TopBar(
          title: '좌석',
          icon: Icons.calendar_view_month_rounded,
        ),
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              textfocus.unfocus();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButton(
                              value: selectedCampusIndex,
                              hint: const Text('캠퍼스를 선택하세요'),
                              items: const [
                                DropdownMenuItem(
                                    value: 1, child: Text('서울캠퍼스')),
                                DropdownMenuItem(
                                    value: 2, child: Text('대전캠퍼스')),
                                DropdownMenuItem(
                                    value: 3, child: Text('광주캠퍼스')),
                                DropdownMenuItem(
                                    value: 4, child: Text('구미캠퍼스')),
                                DropdownMenuItem(
                                    value: 5, child: Text('부울경캠퍼스')),
                              ],
                              onChanged: (int? value) async {
                                setState(() {
                                  // 클래스 코드 초기화
                                  selectedClassCode = "";
                                  // 인덱스 정하고
                                  selectedCampusIndex = value!;
                                  // 코드 설정
                                  selectedCampusCode = campusCode[value - 1];
                                  // 캠퍼스 코드도 설정
                                  selectedClassCode = selectedCampusCode;
                                  selectedCampusClasses.clear();
                                  selectedClass = null;
                                });
                                var selectedCampusInfo = await UserInfoApi(
                                        dio: Dio(),
                                        storage: const FlutterSecureStorage())
                                    .getCampusClasses(selectedCampusCode);
                                setState(() {
                                  campusInfo = selectedCampusInfo;
                                  for (var classes
                                      in selectedCampusInfo!.classes) {
                                    selectedCampusClasses.add(
                                        '${classes.toString().split('').last}반');
                                  }
                                });
                              }),
                          if (selectedCampusIndex != null && campusInfo != null)
                            DropdownButton(
                              value: selectedClass,
                              hint: const Text('반을 선택하세요'),
                              items: selectedCampusClasses
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                var tempSelectedClass =
                                    selectedCampusCode + value!.split("").first;
                                setState(() {
                                  selectedClass = value;
                                  selectedClassCode = tempSelectedClass;
                                });
                                tempSelectedClass = "";
                              },
                            ),
                          IconButton(
                            color: Theme.of(context).colorScheme.primary,
                            onPressed: handleRefresh,
                            icon: const Icon(Icons.refresh),
                            style: ButtonStyle(
                              iconColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // 상태 처리 및 DropdownButton 작업 해야함

                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: myProfile != null
                      ? SeatMapWidget(
                          toggleOpenButtonWidget: toggleOpenButtonWidget,
                          setUserId: setUserId,
                          classCode: selectedClassCode,
                          callUserId: callUserId,
                          jobCode: myProfile?.jobCode,
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),

                const CategoryText(text: '교육생 조회'),
                UserSearchForCallWidget(
                  toggleOpenButtonWidget: toggleOpenButtonWidget,
                  setUserId: setUserId,
                  textFocus: textfocus,
                ),
              ],
            ),
          ),
        ),
        bottomSheet: isOpenedButtonWidget
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: FloatingActionButton.extended(
                    backgroundColor: const Color(0xFF3DB887),
                    foregroundColor: Colors.white,
                    onPressed: () {
                      DeviceApi(
                              dio: Dio(), storage: const FlutterSecureStorage())
                          .callUser(callUserId, "");
                      setState(() {
                        isOpenedButtonWidget = !isOpenedButtonWidget;
                      });
                    },
                    icon: const Icon(Icons.notifications_on),
                    label: Text(
                      '$callUserId 호출',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
            : const SizedBox());
  }
}
