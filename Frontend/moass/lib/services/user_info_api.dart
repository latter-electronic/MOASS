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

  // 유저 정보 불러오기

  // 키워드 검색 API
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

  // 캠퍼스 조회
  Future<List<Map<String, dynamic>>> fetchCampusInfo(
      String? locationCode) async {
    List<Map<String, dynamic>> campusClassesListInstance = [];
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print('No access token available');
        return [];
      }
      print('요청 코드 : $locationCode');

      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/user/search?locationcode=$locationCode',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      print('리턴 코드 : ${response.statusCode}');

      if (response.statusCode == 200) {
        print(response.data);

        // campusClassesListInstance = response.data['classes'];

        return campusClassesListInstance;
      } else {
        print('Failed to load user profile');
        return [];
      }
    } on DioException catch (e) {
      print(' 캠퍼스 정보 조회 실패 ${e.message}');
      return [];
    }
  }

  // 우리반 조회
  Future<List<List<UserInfo>>> fetchMyClass(String? classcode) async {
    List<List<UserInfo>> myClassInstances = [];
    List<UserInfo> teamInstances = [];
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print('No access token available');
        return [];
      }

      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/user/search?classcode=$classcode',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        print('조회 성공!');
        final List<dynamic> teamInfos = response.data['data']['teams'];
        // print(userInfos);
        for (var teamInfo in teamInfos) {
          for (var userInfo in teamInfo['users']) {
            // print('API 안임 - 유저 정보 : $userInfo');
            teamInstances.add(UserInfo.fromJson(userInfo));
          }
          myClassInstances.add(teamInstances);
          teamInstances = [];
          // print('API 안임 - 팀 정보 : ${teamInfo['users']}');
          // userProfileInstances.add(UserInfo.fromJson(teamInfo));
        }
        // print(userProfileInstances);
        return myClassInstances;
      } else {
        print('Failed to load user profile');
        return [];
      }
    } on DioException catch (e) {
      print('Error fetching user profile: ${e.message}');
      return [];
    }
  }

  // 우리 팀 조회
  Future<MyTeam?> getMyTeam() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print('No access token available');
        return null;
      }
      print(accessToken);
      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/user/team',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        return MyTeam.fromJson(response.data['data']);
      } else {
        print('팀 정보를 받아오는데 실패했습니다.');
        return null;
      }
    } on DioException catch (e) {
      print('팀 정보를 받아오는데 문제가 생겼습니다.: ${e.message}');
      return null;
    }
  }
}
