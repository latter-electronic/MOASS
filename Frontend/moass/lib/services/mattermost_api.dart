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
        return [];
      }
      // API요청, 헤더에 토큰 넣기
      final response = await dio.post('$baseUrl/api/oauth2/mm/connect',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: body);

      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } on DioException catch (e) {
      throw Exception('connectMMAcount failed with error: $e');

      // return null;
    }
  }

// MM 채널 조회
  Future<List<MattermostTeam>?> fetchMatterMostChannels() async {
    List<MattermostTeam> matterMostTeamListInstance = [];
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        return null;
      }
      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/oauth2/mm/channels',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> mattermostTeamList = response.data['data'];
        for (var mattermostTeam in mattermostTeamList) {
          matterMostTeamListInstance
              .add(MattermostTeam.fromJson(mattermostTeam));
        }
        return matterMostTeamListInstance;
      } else {
        return null;
      }
    } on DioException catch (e) {
      throw Exception('fetchMatterMostChannels failed with error: $e');

      // return null;
    }
  }

  // 채널 구동 및 취소 요청
  connectMMchannel(String channelId) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        return [];
      }
      // API요청, 헤더에 토큰 넣기
      final response = await dio.post(
        '$baseUrl/api/oauth2/mm/channel/$channelId',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } on DioException catch (e) {
      throw Exception('connectMMchannel failed with error: $e');

      // return null;
    }
  }

  // MM 계정 연동 확인
  Future<MattermostConnectionStatus?> checkMattermostConnection() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        return null;
      }

      final response = await dio.get(
        '$baseUrl/api/oauth2/mm/isconnected',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        return MattermostConnectionStatus.fromJson(response.data);
      } else {
        return MattermostConnectionStatus.fromJson(response.data);
      }
    } on DioException catch (e) {
      // throw Exception('checkMattermostConnection failed with error: $e');

      return null;
    }
  }
}
