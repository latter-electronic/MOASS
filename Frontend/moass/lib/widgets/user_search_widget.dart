// user_search_widget.dart
import 'package:flutter/material.dart';
import 'package:moass/model/user_info.dart';
import 'package:moass/services/user_info_api.dart';
import 'package:moass/widgets/user_box.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSearchWidget extends StatefulWidget {
  final Function(Map<String, String>) onUserSelected; // 사용자 선택 처리를 위한 콜백 함수

  const UserSearchWidget({super.key, required this.onUserSelected});

  @override
  _UserSearchWidgetState createState() => _UserSearchWidgetState();
}

class _UserSearchWidgetState extends State<UserSearchWidget> {
  String? inputText;
  late Future<List<UserInfo>> searchedUserList;
  bool isOpenedButtonWidget = false;

  void searchUser(String? value) {
    searchedUserList =
        UserInfoApi(dio: Dio(), storage: const FlutterSecureStorage())
            .fetchUserProfile(value);
    setState(() {});
  }

  // 수정된 openButtonWidget 메서드
  void openButtonWidget(UserInfo userInfo) {
    setState(() {
      isOpenedButtonWidget = !isOpenedButtonWidget;
    });
    // 콜백 함수 호출, userInfo 객체를 맵으로 전달
    widget.onUserSelected({
      'userName': userInfo.userName,
      'userId': userInfo.userId.toString(),
      'teamCode': userInfo.teamCode
    });
  }

  @override
  void initState() {
    super.initState();
    searchedUserList = Future.value([]); // 초기 빈 리스트 설정
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TextField(
            decoration: InputDecoration(
              icon: const Icon(Icons.search),
              hintText: "교육생 이름을 입력하세요",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onChanged: (value) => searchUser(value),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: FutureBuilder<List<UserInfo>>(
              future: searchedUserList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('한글자 이상 입력해 주세요!'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Column(
                    children: snapshot.data!.map((userInfo) {
                      return Material(
                        color: Colors.transparent, // 기본 배경색을 투명으로 설정
                        child: InkWell(
                          onTap: () => openButtonWidget(userInfo),
                          highlightColor: Colors.blue.withOpacity(0.3), // 강조 색상
                          splashColor: Colors.blue.withOpacity(0.2), // 물결 효과 색상
                          borderRadius: BorderRadius.circular(10), // 경계면 둥글게 처리
                          child: UserBox(
                            username: userInfo.userName,
                            team: userInfo.teamCode,
                            role: userInfo.positionName,
                            userstatus: userInfo.statusId,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text('검색된 유저가 없습니다.'),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
