import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/myprofile.dart';
import 'package:moass/screens/notification_screen.dart';
import 'package:moass/screens/setting_screen.dart';
import 'package:moass/services/myinfo_api.dart';
import 'package:moass/widgets/check_box.dart';
import 'package:moass/widgets/top_bar.dart';

import '../widgets/category_text.dart';
import '../widgets/schedule_box.dart';
import '../widgets/to_do_list.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  late int selectedSeatedState;

// 내상태 설정
// 자리비움으로 바꾸기
  void setStateNotHere() {
    setState(() {
      if (selectedSeatedState == 1) {
        selectedSeatedState = 0;
      }
    });
  }

// 착석으로 바꾸기
  void setStateHere() {
    setState(() {
      if (selectedSeatedState == 0) {
        selectedSeatedState = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final myInfoApi =
        MyInfoApi(dio: Dio(), storage: const FlutterSecureStorage());

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
                        border: Border.all(
                            color: const Color(0xFF6ECEF5), width: 2)),
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
                        border: Border.all(
                            color: const Color(0xFF6ECEF5), width: 2)),
                    child: const Icon(
                      Icons.settings,
                      color: Color(0xFF6ECEF5),
                    ))),
          ],
          title: Image.asset('assets/img/logo_basic.png'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CategoryText(
                text: '내 기기 상태',
              ),
              FutureBuilder<MyProfile?>(
                future: myInfoApi.fetchUserProfile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    var userProfile = snapshot.data;

                    selectedSeatedState = userProfile!.statusId;

                    return Column(
                      children: [
                        userProfile.connectFlag == 0
                            ? Container(
                                height: 200,
                                width: double.infinity,
                                decoration:
                                    const BoxDecoration(color: Colors.black),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 150,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                            color: Colors.white),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                flex: 1,
                                                child: Image.asset(
                                                    'assets/img/logo_ssafy_white.png')),
                                            Flexible(
                                              flex: 3,
                                              child: Transform.translate(
                                                offset: const Offset(0, -10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Transform.translate(
                                                      offset:
                                                          const Offset(0, 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              '${userProfile.teamCode} ${userProfile.teamName}'),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          userProfile.userName,
                                                          style: const TextStyle(
                                                              fontSize: 80,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        Transform.translate(
                                                          offset: const Offset(
                                                              0, -10),
                                                          child: Container(
                                                            width: 30,
                                                            decoration: const BoxDecoration(
                                                                color: Color(
                                                                    0xFFD93030),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50))),
                                                            child: Center(
                                                                child: Text(
                                                              '${userProfile.positionName}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                                flex: 1,
                                                child: Container(
                                                  width: 50,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          selectedSeatedState ==
                                                                  1
                                                              ? const Color(
                                                                  0xFF3DB887)
                                                              : const Color(
                                                                  0xFFFFBC1F)),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            selectedSeatedState ==
                                                                    1
                                                                ? const EdgeInsets
                                                                    .all(14.0)
                                                                : const EdgeInsets
                                                                    .all(17.0),
                                                        child:
                                                            selectedSeatedState ==
                                                                    1
                                                                ? const Text(
                                                                    '착석중',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            25,
                                                                        fontWeight:
                                                                            FontWeight.w900),
                                                                  )
                                                                : const Text(
                                                                    '자리비움',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.w900),
                                                                  ),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        )),
                                  ],
                                ))
                            : Container(
                                height: 200,
                                width: double.infinity,
                                decoration:
                                    BoxDecoration(color: Colors.grey.shade200),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/img/crying_mozzi.png'),
                                    const Text('현재 연결된 기기가 없어요.'),
                                    const Text('명패에 태그하면 기기 상태를 확인할 수 있어요!')
                                  ],
                                )),
                        userProfile.connectFlag == 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CategoryText(text: '내 상태 설정'),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                await myInfoApi
                                                    .patchUserStatus(1);
                                                setState(() {
                                                  myInfoApi.fetchUserProfile();
                                                });
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 30),
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF3DB887),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius
                                                                .circular(10)),
                                                    border: selectedSeatedState ==
                                                            1
                                                        ? Border.all(
                                                            color: const Color(
                                                                0xFF6ECEF5),
                                                            width: 4.0)
                                                        : null),
                                                child: const Center(
                                                    child: Text('착석 중',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white))),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                await myInfoApi
                                                    .patchUserStatus(0);
                                                setState(() {
                                                  myInfoApi.fetchUserProfile();
                                                });
                                              },
                                              child: Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFFFBC1F),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius
                                                                .circular(10)),
                                                    border: selectedSeatedState ==
                                                            0
                                                        ? Border.all(
                                                            color: const Color(
                                                                0xFF6ECEF5),
                                                            width: 4.0)
                                                        : null),
                                                child: const Center(
                                                    child: Text('자리 비움',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: selectedSeatedState == 'notHere'
                                      //       ? 70
                                      //       : 0,
                                      //   child: Column(
                                      //     children:
                                      //         selectedSeatedState == 'notHere'
                                      //             ? [
                                      //                 const Text('사유를 선택하세요'),
                                      //                 const Row(
                                      //                   mainAxisAlignment:
                                      //                       MainAxisAlignment
                                      //                           .center,
                                      //                   children: [
                                      //                     MyStateSelector(
                                      //                         state: '취업면담'),
                                      //                     MyStateSelector(
                                      //                         state: '팀 미팅'),
                                      //                     MyStateSelector(
                                      //                         state: '기타'),
                                      //                   ],
                                      //                 )
                                      //               ]
                                      //             : [],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox()
                      ],
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
              const CategoryText(text: '다음 일정'),
              const SizedBox(
                height: 50,
                child: Center(
                  child: Column(
                    children: [
                      ScheduleBox(
                          title: '[Live] 생성형 AI 특강', time: '14:00-15:00'),
                    ],
                  ),
                ),
              ),
              const CategoryText(text: '할 일 목록'),
              const ToDoListWidget(),
              const CategoryText(text: '오늘 내 예약'),
              const SizedBox(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        ScheduleBox(title: '플립보드 1', time: '10:00 - 11:00'),
                        ScheduleBox(title: '팀 미팅', time: '11:00 - 12:00'),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class MyStateSelector extends StatelessWidget {
  const MyStateSelector({
    super.key,
    required this.state,
  });

  final String state;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 80,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1.0, color: const Color(0xFF6ECEF5)),
          borderRadius: BorderRadius.circular(50)),
      child: Center(
          child: Text(
        state,
        style: const TextStyle(
          color: Color(0xFF6ECEF5),
        ),
      )),
    );
  }
}
