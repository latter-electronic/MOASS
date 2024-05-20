import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/myprofile.dart';
import 'package:moass/riverpod/my_profile_river.dart';
import 'package:moass/screens/setting_background_photo.dart';
import 'package:moass/screens/setting_profile_photo.dart';
import 'package:moass/screens/setting_related_account.dart';
import 'package:moass/screens/setting_user_info.dart';
import 'package:moass/screens/setting_widget_photo.dart';
import 'package:moass/services/device_api.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/top_bar.dart';
import 'package:moass/services/account_api.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myInfoApi = ref.read(myInfoApiProvider);
    final accountApi = AccountApi(
      dio: Dio(), // 이 부분은 실제 앱 설정에 따라 변경 가능
      storage: const FlutterSecureStorage(),
    );

    void performLogout(BuildContext context) async {
      bool loggedOut = await accountApi.logout();
      if (loggedOut) {
        Navigator.pushReplacementNamed(context, '/loginScreen');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("로그아웃 실패. 다시 시도해주세요.")),
        );
      }
    }

    return Scaffold(
      appBar: const TopBar(
        title: '설정',
        icon: Icons.settings,
      ),
      body: FutureBuilder<MyProfile?>(
          future: myInfoApi.fetchUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              var userProfile = snapshot.data;
              return Column(
                children: [
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.5)))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6ECEF5),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.device_hub_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '연결 기기 관리',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        child: Text(
                                          '연결된 명패를 확인하세요',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 30.0, horizontal: 40.0),
                              child: userProfile!.connectFlag == 1
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            width: 30,
                                            height: 20,
                                            decoration: const BoxDecoration(
                                                color: Colors.blue),
                                          ),
                                          const Text('명패'),
                                        ]),
                                        TextButton(
                                          onPressed: () => showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: const Text('기기 연결 해제'),
                                              content: SizedBox(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.asset(
                                                      'assets/img/crying_mozzi.png',
                                                      height: 200,
                                                    ),
                                                    const Text(
                                                        '정말로 기기와의 연결을 해제하시겠어요?'),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, '취소'),
                                                  child: const Text('취소'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    // String response =
                                                    DeviceApi(
                                                            dio: Dio(),
                                                            storage:
                                                                const FlutterSecureStorage())
                                                        .disconnectDevice();
                                                    // if (response == '200') {
                                                    Navigator.pop(
                                                        context, '확인');
                                                    // }
                                                  },
                                                  child: const Text('확인'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          child: const Text(
                                            '연결 해제',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        )
                                      ],
                                    )
                                  : const Center(child: Text('연결된 기기가 없습니다')),
                            )
                          ],
                        ),
                      )),
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.5)))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // fullscreenDialog: true,
                                builder: (context) => SettingUserInfoScreen(
                                  teamName: userProfile.teamName,
                                  positionName: userProfile.positionName,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6ECEF5),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.person_2,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '내 정보 관리',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 1.0),
                                      child: Text(
                                        '내 정보를 수정해보세요',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.5)))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // fullscreenDialog: true,
                                builder: (context) => SettingProfilePhotoScreen(
                                    profileImg: userProfile.profileImg),
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6ECEF5),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.portrait_sharp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '프로필 사진 설정',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 1.0),
                                      child: Text(
                                        '프로필 사진을 수정해보세요',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.5)))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // fullscreenDialog: true,
                                builder: (context) => SettingWidgetPhotoScreen(
                                    profileImg: userProfile.profileImg),
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6ECEF5),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.photo_library_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '위젯 사진 수정',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 1.0),
                                      child: Text(
                                        '기기 위젯에 들어갈 사진을 수정해보세요',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.5)))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // fullscreenDialog: true,
                                builder: (context) =>
                                    SettingBackgroundPhotoScreen(
                                        backgroundImg:
                                            userProfile.backgroundImg),
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6ECEF5),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.photo_camera_back_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '기기 배경 사진 설정',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 1.0),
                                      child: Text(
                                        '명패 배경 사진을 바꿔보세요',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.5)))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // fullscreenDialog: true,
                                builder: (context) =>
                                    const SettingRelatedAccountScreen(),
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6ECEF5),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.account_tree_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '연동 계정 관리',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 1.0),
                                      child: Text(
                                        'Jira, MatterMost, Gitlab 계정을 관리하세요',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.5)))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20),
                        child: GestureDetector(
                          onTap: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('앱 로그아웃'),
                              content: SizedBox(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/img/crying_mozzi.png',
                                      height: 200,
                                    ),
                                    const Text('앱에서 로그아웃 하시겠어요?'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, '취소'),
                                  child: const Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // 대화 상자 닫기
                                    performLogout(context); // 로그아웃 실행
                                  },
                                  // onPressed: () => Navigator.pop(context, '확인'),
                                  child: const Text('확인'),
                                ),
                              ],
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6ECEF5),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.logout_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '로그아웃',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 1.0),
                                      child: Text(
                                        '진심이세요?',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              );
            } else {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: GestureDetector(
                    onTap: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('기기 연결 해제'),
                            content: SizedBox(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/img/crying_mozzi.png',
                                    height: 200,
                                  ),
                                  const Text('앱에서 로그아웃 하시겠어요?'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800)),
                                onPressed: () => Navigator.pop(context, '취소'),
                                child: const Text(
                                  '취소',
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // 대화 상자 닫기
                                  performLogout(context); // 로그아웃 실행
                                },
                                // onPressed: () => Navigator.pop(context, '확인'),
                                child: const Text('확인'),
                              ),
                            ],
                          ),
                        ),
                    child: const CategoryText(text: '로그아웃')),
              ));
            }
          }),
    );
  }
}
