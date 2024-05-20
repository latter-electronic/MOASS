// 계정 관련 API 요청
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio dio;
  final FlutterSecureStorage storage;
  static const String baseUrl = 'https://k10e203.p.ssafy.io';
  ApiService({required this.dio, required this.storage});

  // 토큰 리프레쉬
  Future<void> manualRefresh() async {
    String? accessToken = await storage.read(key: 'accessToken');
    String? refreshToken = await storage.read(key: 'refreshToken');
    if (accessToken == null) {
      throw Exception('No access token available');
    }
    try {
      final response = await dio.post(
        '$baseUrl/api/user/refresh',
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['data']['accessToken'];
        final newRefreshToken = response.data['data']['refreshToken'];
        await storage.write(key: 'accessToken', value: newAccessToken);
        await storage.write(key: 'refreshToken', value: newRefreshToken);
        print('엑세토큰: $newAccessToken');
      } else {
        throw Exception('Failed to register reservation');
      }
    } on DioException catch (e) {
      throw Exception('Error making reservation request: ${e.message}');
    }
  }
}
