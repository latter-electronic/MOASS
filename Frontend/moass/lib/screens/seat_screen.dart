import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/myprofile.dart';
import 'package:moass/model/user_info.dart';
import 'package:moass/services/myinfo_api.dart';
import 'package:moass/services/user_info_api.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/seat_map.dart';
import 'package:moass/widgets/top_bar.dart';
import 'package:moass/widgets/user_search_for_call.dart';

class SeatScreen extends StatefulWidget {
  const SeatScreen({
    super.key,
  });

  @override
  State<SeatScreen> createState() => _SeatScreenState();
}

class _SeatScreenState extends State<SeatScreen> {
  MyProfile? myProfile;
  bool isLoading = true;
  late MyInfoApi api;

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

  void openButtonWidget(bool value) {
    setState(() {
      isOpenedButtonWidget = value;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TopBar(
          title: '좌석',
          icon: Icons.calendar_view_month_rounded,
        ),
        body: SingleChildScrollView(
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
                        onPressed: () {},
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
                        openButtonWidget: openButtonWidget,
                        setUserId: setUserId,
                        classCode: myProfile!.classCode,
                        callUserId: callUserId,
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),

              const CategoryText(text: '교육생 조회'),
              UserSearchForCallWidget(
                openButtonWidget: openButtonWidget,
                setUserId: setUserId,
              ),
              isOpenedButtonWidget
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: FloatingActionButton.extended(
                          backgroundColor: const Color(0xFF3DB887),
                          foregroundColor: Colors.white,
                          onPressed: () {
                            print('부를 유저 아이디 : $callUserId');
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
                  : const SizedBox()
            ],
          ),
        ));
  }
}
