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
      // throw Exception('requestConnectGitlab failed with error: $e');

      return null;
    }
  }

  Future<RelatedGitlabAccount?> fetchGitlabAccount() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        return null;
      }
      // print(accessToken);
      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/oauth2/gitlab/isconnected',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        return RelatedGitlabAccount.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on DioException catch (e) {
      // throw Exception('fetchGitlabAccount failed with error: $e');

      return null;
    }
  }

  requestSubmitProject(String projectname) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        return null;
      }
      final response = await dio.post(
        '$baseUrl/api/oauth2/gitlab/projects?projectname=$projectname',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        var message = response.data['status'];
        return message;
      } else {
        var message = response.data['status'];
        return message;
      }
    } on DioException catch (e) {
      // throw Exception('requestSubmitProject failed with error: $e');

      return null;
    }
  }

  // 등록 프로젝트 이슈, 머지 리퀘스트 가져오기
  Future<ProjectModel?> fetchGitlabProjectInfo(String projectName) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        return null;
      }
      // print(accessToken);
      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/oauth2/gitlab/projectinfos',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        return ProjectModel.fromJson(response.data['data'][projectName].first);
      } else {
        return null;
      }
    } on DioException catch (e) {
      // throw Exception('fetchGitlabProjectInfo failed with error: $e');
      return null;
    }
    // return null;
  }
}
