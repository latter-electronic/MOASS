import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/boardModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BoardApi {
  final Dio dio;
  final FlutterSecureStorage storage;
  final String baseUrl = "https://k10e203.p.ssafy.io/api";

  BoardApi({required this.dio, required this.storage});

  // 모음보드 방 목록 들어오는 함수
  Future<List<BoardModel>> fetchBoards() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {}

      final response = await dio.get('$baseUrl/board',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      if (response.statusCode == 200) {
        List<dynamic> boardsJson = response.data['data'];
        return boardsJson.map((json) => BoardModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load boards');
      }
    } catch (e) {
      throw Exception('Failed to fetch boards: $e');
    }
  }

  // 보드 사진 리스트
  Future<List<ScreenshotModel>> boardScreenshotList(int boardUserId) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {}
      final response = await dio.get('$baseUrl/board/$boardUserId',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      if (response.statusCode == 200) {
        List<dynamic> boardsJson = response.data['data'];
        return boardsJson
            .map((json) => ScreenshotModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load screenshots');
      }
    } catch (e) {
      throw Exception('Failed to fetch screenshots: $e');
    }
  }

  // 보드 사진 상세
  Future<ScreenshotModel> boardScreenshotDetail(int screenshotId) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {}

      final response = await dio.get('$baseUrl/board/screenshot/$screenshotId',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      if (response.statusCode == 200) {
        return ScreenshotModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load screenshot');
      }
    } catch (e) {
      throw Exception('Failed to fetch screenshot: $e');
    }
  }

  // 보드 사진 삭제
  Future<ScreenshotModel> boardScreenshotDelete(int screenshotId) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {}

      final response = await dio.delete(
          '$baseUrl/board/screenshot/$screenshotId',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      if (response.statusCode == 200) {
        return ScreenshotModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load screenshot');
      }
    } catch (e) {
      throw Exception('Failed to fetch screenshot: $e');
    }
  }
}

// Provider 정의
final dioProvider = Provider((ref) => Dio());
final storageProvider = Provider((ref) => const FlutterSecureStorage());

final boardApiProvider = Provider<BoardApi>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(storageProvider);
  return BoardApi(dio: dio, storage: storage);
});
