import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:moass/model/myprofile.dart';
import 'package:moass/model/reservation_model.dart';
import 'package:moass/model/user_info.dart';
import 'package:moass/screens/notification_screen.dart';
import 'package:moass/screens/setting_screen.dart';
import 'package:moass/services/myinfo_api.dart';
import 'package:moass/services/reservation_api.dart';
import 'package:moass/services/user_info_api.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/meeting_table.dart';
import 'package:moass/widgets/seat_map.dart';

class MainAdminScreen extends StatefulWidget {
  const MainAdminScreen({
    super.key,
  });

  @override
  State<MainAdminScreen> createState() => _MainAdminScreenState();
}

class _MainAdminScreenState extends State<MainAdminScreen> {
  MyProfile? myProfile;
  bool isLoading = true;
  late MyInfoApi api;
  FocusNode textfocus = FocusNode();
  List<ReservationDayModel> reservations = [];
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    api = MyInfoApi(dio: Dio(), storage: const FlutterSecureStorage());

    super.initState();
    fetchMyInfo();
    initializeDateFormatting('ko_KR').then((_) {
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      });
      fetchReservations();
    });
  }

  Future<void> fetchReservations() async {
    final api =
        ReservationApi(dio: Dio(), storage: const FlutterSecureStorage());
    final reservationData = await api.reservationinfoDay(formattedDate);
    if (reservationData != null) {
      setState(() {
        reservations =
            reservationData.where((res) => res.category == '1').toList();
        isLoading = false;
      });
    }
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // fullscreenDialog: true,
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              icon: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xFF6ECEF5), width: 2)),
                  child: const Icon(
                    Icons.notifications,
                    color: Color(0xFF6ECEF5),
                  ))),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // fullscreenDialog: true,
                    builder: (context) => const SettingScreen(),
                  ),
                );
              },
              icon: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xFF6ECEF5), width: 2)),
                  child: const Icon(
                    Icons.settings,
                    color: Color(0xFF6ECEF5),
                  ))),
        ],
        title: Image.asset('assets/img/logo_basic.png'),
        centerTitle: true,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CategoryText(
                          text:
                              '${myProfile?.locationName}캠퍼스 ${myProfile?.classCode.split('').last}반'),
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
                        classCode: myProfile!.classCode,
                        callUserId: callUserId,
                        jobCode: myProfile!.jobCode,
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),

              const CategoryText(text: '오늘의 예약 일정'),
              ...reservations.expand((reservation) => reservation
                  .reservationInfoList
                  .where((info) => info.infoState == 1)
                  .map((info) => MeetingTable(
                        boxColor: reservation.colorCode,
                        reservationName: reservation.reservationName,
                        infoName: info.infoName,
                        infoTime: info.infoTime,
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
