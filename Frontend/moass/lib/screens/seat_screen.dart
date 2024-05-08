import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/myprofile.dart';
import 'package:moass/model/seat.dart';
import 'package:moass/model/user_info.dart';
import 'package:moass/services/myinfo_api.dart';
import 'package:moass/services/user_info_api.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/seat_map.dart';
import 'package:moass/widgets/top_bar.dart';
import 'package:moass/widgets/user_box.dart';
import 'package:moass/widgets/user_search_for_call.dart';

class SeatScreen extends StatefulWidget {
  const SeatScreen({super.key});

  @override
  State<SeatScreen> createState() => _SeatScreenState();
}

class _SeatScreenState extends State<SeatScreen> {
  _SeatScreenState() {
    initSeats();
  }
  final List<Seat> seatList = List.empty(growable: true);

  void initSeats() {
    seatList.clear();
    seatList.add(Seat(683.0, 745.0));
    seatList.add(Seat(593.0, 745.0));
    seatList.add(Seat(680.0, 655.0));
    seatList.add(Seat(593.0, 655.0));
    seatList.add(Seat(683.0, 565.0));
    seatList.add(Seat(593.0, 565.0));
  }

  // 교육생 검색 관련 변수
  bool isOpenedButtonWidget = false;

  void openButtonWidget() {
    setState(() {
      isOpenedButtonWidget = !isOpenedButtonWidget;
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

  late Future<List<List<UserInfo>>> myClass;

  @override
  Widget build(BuildContext context) {
    final myInfoApi =
        MyInfoApi(dio: Dio(), storage: const FlutterSecureStorage());

    return Scaffold(
        appBar: const TopBar(
          title: '좌석',
          icon: Icons.calendar_view_month_rounded,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상태 처리 및 DropdownButton 작업 해야함
              FutureBuilder(
                  future: myInfoApi.fetchUserProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      var userProfile = snapshot.data;
                      var currentClass = userProfile!.classCode.split('').last;

                      myClass = UserInfoApi(
                              dio: Dio(), storage: const FlutterSecureStorage())
                          .fetchMyClass(userProfile.classCode);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CategoryText(
                                  text:
                                      '${userProfile.locationName}캠퍼스 $currentClass반'),
                              IconButton.outlined(
                                onPressed: () {},
                                icon: const Icon(Icons.refresh),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.white)),
                              ),
                            ],
                          ),
                          FutureBuilder(
                              future: myClass,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200),
                                    height: 400,
                                    width: double.infinity,
                                    child: const Center(
                                        child: CircularProgressIndicator()),
                                  );
                                } else if (snapshot.hasError) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200),
                                    height: 400,
                                    width: double.infinity,
                                    child: Center(
                                        child:
                                            Text('Error: ${snapshot.error}')),
                                  );
                                } else if (snapshot.hasData) {
                                  List<List<UserInfo>>? currentClass =
                                      snapshot.data;

                                  return SizedBox(
                                    height: 400,
                                    width: double.infinity,
                                    child: SeatMapWidget(
                                      seatList: seatList,
                                      openButtonWidget: openButtonWidget,
                                    ),
                                  );
                                } else {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200),
                                    height: 400,
                                    width: double.infinity,
                                    child: const Center(
                                        child: Text('데이터를 불러오는 데 문제가 있어요.')),
                                  );
                                }
                              }),
                        ],
                      );
                    } else {
                      return const Center(child: Text('No data available'));
                    }
                  }),

              const CategoryText(text: '교육생 조회'),
              const UserSearchForCallWidget(),
              isOpenedButtonWidget
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: FloatingActionButton.extended(
                          backgroundColor: const Color(0xFF3DB887),
                          foregroundColor: Colors.white,
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_on),
                          label: const Text(
                            '호출',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ));
  }
}
