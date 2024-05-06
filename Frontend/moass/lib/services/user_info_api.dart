import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/myprofile.dart';
import 'package:moass/model/user_info.dart';

class UserInfoApi {
  // 필요한 라이브러리 및 베이스 URL 설정
  final Dio dio;
  final FlutterSecureStorage storage;
  static const String baseUrl = 'https://k10e203.p.ssafy.io';

  // dio와 storage에 담긴 데이터 활용하겠다 선언
  UserInfoApi({required this.dio, required this.storage});

  Future<List<UserInfo>> fetchUserProfile(String? username) async {
    List<UserInfo> userProfileInstances = [];
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print('No access token available');
        return [];
      }
      // print(accessToken);
      print('검색어: $username');
      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/user?username=$username',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        print('검색 성공!');
        final List<dynamic> userInfos = response.data['data'];
        // print(userInfos);
        for (var userInfo in userInfos) {
          print('API 안임 - 유저 정보 : $userInfo');
          userProfileInstances.add(UserInfo.fromJson(userInfo));
        }
        // print(userProfileInstances);
        return userProfileInstances;
      } else {
        print('Failed to load user profile');
        return [];
      }
    } on DioException catch (e) {
      print('Error fetching user profile: ${e.message}');
      return [];
    }
  }
}
