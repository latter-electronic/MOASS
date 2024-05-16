import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/related_gitlab_account.dart';

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

  Future<RelatedGitlabAccount?> fetchGitlabAccount() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print('No access token available');
        return null;
      }
      // print(accessToken);
      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/oauth2/gitlab/isconnected',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        print('깃랩 정보 가져오기 성공!');
        return RelatedGitlabAccount.fromJson(response.data['data']);
      } else {
        print('깃랩 정보를 가져오지 못했습니다');
        return null;
      }
    } on DioException catch (e) {
      print('깃렙 정보 에러 ${e.message}');
      return null;
    }
  }

  requestSubmitProject(String projectname) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print('No access token available');
        return null;
      }
      final response = await dio.post(
        '$baseUrl/api/oauth2/gitlab/projects?projectname=$projectname',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        var message = response.data['message'];
        return message;
      } else {
        var message = response.data['message'];
        return message;
      }
    } on DioException catch (e) {
      print('Gitlab 프로젝트 연동 실패: ${e.message}');
      return null;
    }
  }
}
