import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/related_MM_account.dart';

class MatterMostApi {
  final Dio dio;
  final FlutterSecureStorage storage;
  static const String baseUrl = 'https://k10e203.p.ssafy.io';

  MatterMostApi({required this.dio, required this.storage});

  // MM 계정 등록
  connectMMAcount(String loginId, String password) async {
    try {
      Map data = {'loginId': loginId, 'password': password};
      var body = json.encode(data);
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        // print('No access token available');
        return [];
      }
      // print(accessToken);
      // API요청, 헤더에 토큰 넣기
      final response = await dio.post('$baseUrl/api/oauth2/mm/connect',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: body);

      if (response.statusCode == 200) {
        print('MM 연동 성공!');
        return response.statusCode;
      } else {
        print('MM 연동 실패');
        return response.statusCode;
      }
    } on DioException catch (e) {
      print('Error fetching user status: ${e.message}');
      return null;
    }
  }

  // MM 채널 조회
  Future<List<MattermostTeam>?> fetchMatterMostChannels() async {
    List<MattermostTeam> matterMostTeamListInstance = [];
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print('No access token available');
        return null;
      }
      // print(accessToken);
      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/oauth2/mm/channels',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> mattermostTeamList = response.data['data'];
        // print('MM 채널 정보 : ${response.data['data'].toString()}');
        for (var mattermostTeam in mattermostTeamList) {
          matterMostTeamListInstance
              .add(MattermostTeam.fromJson(mattermostTeam));
        }
        return matterMostTeamListInstance;
      } else {
        print('Failed to load user profile');
        return null;
      }
    } on DioException catch (e) {
      print('Error fetching user profile: ${e.message}');
      return null;
    }
  }
}
