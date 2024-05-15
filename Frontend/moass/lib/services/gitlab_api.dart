import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GitlabApi {
  final Dio dio;
  final FlutterSecureStorage storage;
  static const String baseUrl = 'https://k10e203.p.ssafy.io';

  // dio와 storage에 담긴 데이터 활용하겠다 선언
  GitlabApi({required this.dio, required this.storage});

  requestConnectGitlab() async {
    String gitlabAuthURL = "";
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print('No access token available');
        return null;
      }
      final response = await dio.get(
        '$baseUrl/api/oauth2/gitlab/connect',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        gitlabAuthURL = response.data['data'];
        return gitlabAuthURL;
      }
    } on DioException catch (e) {
      print('Error fetching user profile: ${e.message}');
      return null;
    }
  }
}
