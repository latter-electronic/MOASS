import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/myprofile.dart';

class MyInfoApi {
  // 필요한 라이브러리 및 베이스 URL 설정
  final Dio dio;
  final FlutterSecureStorage storage;
  static const String baseUrl = 'https://k10e203.p.ssafy.io';

  // dio와 storage에 담긴 데이터 활용하겠다 선언
  MyInfoApi({required this.dio, required this.storage});

  Future<MyProfile?> fetchUserProfile() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print('No access token available');
        return null;
      }
      print(accessToken);
      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/user',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        return MyProfile.fromJson(response.data['data']);
      } else {
        print('Failed to load user profile');
        return null;
      }
    } on DioException catch (e) {
      print('Error fetching user profile: ${e.message}');
      return null;
    }
  }

  // 유저 상태 수정
  patchUserStatus(int statusId) async {
    try {
      Map data = {'statusId': statusId};
      var body = json.encode(data);
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        // print('No access token available');
        return [];
      }
      // print(accessToken);
      // API요청, 헤더에 토큰 넣기
      final response = await dio.patch('$baseUrl/api/user/status',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: body);

      if (response.statusCode == 200) {
        print('유저 상태변경 성공!');
        return response;
      } else {
        print('유저 상태변경 실패');
        return [];
      }
    } on DioException catch (e) {
      print('Error fetching user status: ${e.message}');
      return null;
    }
  }

  patchUserTeamName(String teamName, String? positionName) async {
    try {
      Map data = {'teamName': teamName, 'positionName': positionName};
      var body = json.encode(data);
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        // print('No access token available');
        return [];
      }
      // print(accessToken);
      // API요청, 헤더에 토큰 넣기
      final response = await dio.patch('$baseUrl/api/user/status',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: body);

      if (response.statusCode == 200) {
        print('유저 정보 변경 성공!');
        return response;
      } else {
        print('유저 정보 변경 실패');
        return [];
      }
    } on DioException catch (e) {
      print(e.message);
      print('Error fetching user status: ${e.message}');
      return null;
    }
  }
}