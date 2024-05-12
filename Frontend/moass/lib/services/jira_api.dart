import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/related_account.dart';

class JiraApi {
  final Dio dio;
  final FlutterSecureStorage storage;
  static const String baseUrl = 'https://k10e203.p.ssafy.io';

  // dio와 storage에 담긴 데이터 활용하겠다 선언
  JiraApi({required this.dio, required this.storage});

  Future<RelatedAccount?> fetchJiraAccount() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print('No access token available');
        return null;
      }
      // print(accessToken);
      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/oauth2/jira/isconnected',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        return RelatedAccount.fromJson(response.data);
      } else {
        print('Failed to load user profile');
        return null;
      }
    } on DioException catch (e) {
      print('Error fetching user profile: ${e.message}');
      return null;
    }
  }

  requestConnectJira() async {
    String jiraAuthURL = "";
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print('No access token available');
        return null;
      }
      final response = await dio.get(
        '$baseUrl/api/oauth2/jira/connect',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        jiraAuthURL = response.data['data'];
        return jiraAuthURL;
      }
    } on DioException catch (e) {
      print('Error fetching user profile: ${e.message}');
      return null;
    }
  }
}
