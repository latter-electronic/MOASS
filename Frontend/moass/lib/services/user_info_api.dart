import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
        return [];
      }
      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/user?username=$username',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> userInfos = response.data['data'];
        for (var userInfo in userInfos) {
          userProfileInstances.add(UserInfo.fromJson(userInfo));
        }
        return userProfileInstances;
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw Exception('Error fetchUserProfile: ${e.message}');

      // return [];
    }
  }

  // 캠퍼스 반 목록 조회
  Future<CampusInfo?> getCampusClasses(String? locationCode) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {}

      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/user/locationinfo',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        // CampusInfo campusA = response.data['data']['A'];
        // CampusInfo campusB = response.data['data']['B'];
        // CampusInfo campusC = response.data['data']['C'];
        // CampusInfo campusD = response.data['data']['D'];
        // CampusInfo campusE = response.data['data']['E'];

        var campusInfo = response.data['data'][locationCode];
        CampusInfo campusInfoInstance = CampusInfo.fromJson(campusInfo);

        // campusClassesListInstance = response.data['classes'];

        return campusInfoInstance;
      } else {}
    } on DioException catch (e) {
      throw Exception('Error getCampusClasses: ${e.message}');
      // return null;
    }
    return null;
  }

  // 캠퍼스 조회
  Future<List<Map<String, dynamic>>> fetchCampusInfo(
      String? locationCode) async {
    List<Map<String, dynamic>> campusClassesListInstance = [];
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        return [];
      }

      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/user/search?locationcode=$locationCode',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        // campusClassesListInstance = response.data['classes'];

        return campusClassesListInstance;
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw Exception('Error fetchCampusInfo: ${e.message}');
      // return [];
    }
  }

  // 우리반 조회
  Future<List<List<UserInfo>>> fetchMyClass(String? classcode) async {
    List<List<UserInfo>> myClassInstances = [];
    List<UserInfo> teamInstances = [];
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        return [];
      }

      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/user/search?classcode=$classcode',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> teamInfos = response.data['data']['teams'];
        for (var teamInfo in teamInfos) {
          for (var userInfo in teamInfo['users']) {
            teamInstances.add(UserInfo.fromJson(userInfo));
          }
          myClassInstances.add(teamInstances);
          teamInstances = [];
          // userProfileInstances.add(UserInfo.fromJson(teamInfo));
        }
        return myClassInstances;
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw Exception('Error fetchMyClass: ${e.message}');
      // return [];
    }
  }

  // 우리 팀 조회
  Future<MyTeam?> getMyTeam() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        return null;
      }
      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/user/team',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        return MyTeam.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on DioException catch (e) {
      throw Exception('Error getMyTeam: ${e.message}');
      // return null;
    }
  }

  // 선택한 유저 정보 수정
  // 유저 상태 수정
  patchUserStatus(String userId) async {
    try {
      Map data = {'statusId': 4};
      var body = json.encode(data);
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        return [];
      }
      // API요청, 헤더에 토큰 넣기
      final response = await dio.patch('$baseUrl/api/user/$userId/status',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: body);

      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } on DioException catch (e) {
      throw Exception('Error patchUserStatus: ${e.message}');
      // return null;
    }
  }
}
