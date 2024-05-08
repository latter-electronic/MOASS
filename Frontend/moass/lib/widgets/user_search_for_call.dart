// user_search_widget.dart
import 'package:flutter/material.dart';
import 'package:moass/model/user_info.dart';
import 'package:moass/services/user_info_api.dart';
import 'package:moass/widgets/user_box.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSearchForCallWidget extends StatefulWidget {
  const UserSearchForCallWidget({super.key});

  @override
  _UserSearchWidgetState createState() => _UserSearchWidgetState();
}

class _UserSearchWidgetState extends State<UserSearchForCallWidget> {
  String? inputText;
  late Future<List<UserInfo>> searchedUserList;
  bool isOpenedButtonWidget = false;

  void searchUser(String? value) {
    searchedUserList =
        UserInfoApi(dio: Dio(), storage: const FlutterSecureStorage())
            .fetchUserProfile(value);
    setState(() {});
  }

  void openButtonWidget() {
    setState(() {
      isOpenedButtonWidget = !isOpenedButtonWidget;
    });
  }

  @override
  void initState() {
    super.initState();
    searchedUserList = Future.value([]); // 초기 빈 리스트
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
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Column(
                    children: snapshot.data!.map((userInfo) {
                      return GestureDetector(
                        onTap: openButtonWidget,
                        child: UserBox(
                            username: userInfo.userName,
                            team: userInfo.teamCode,
                            role: userInfo.positionName,
                            userstatus: userInfo.statusId),
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
