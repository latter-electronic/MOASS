// 계정 관련 API 요청
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
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
    print('기존 토큰값: $accessToken');
    print('기존 리프레시 값 : $refreshToken');
    if (accessToken == null) {
      throw Exception('No access token available');
    }
    try {
      final response = await dio.post(
        'https://cfe0-59-20-195-127.ngrok-free.app/api/user/refresh',
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      if (response.statusCode == 200) {
        print('리프레쉬 성공!');
        final newAccessToken = response.data['data']['accessToken'];
        final newRefreshToken = response.data['data']['refreshToken'];
        await storage.write(key: 'accessToken', value: newAccessToken);
        await storage.write(key: 'refreshToken', value: newRefreshToken);
        print('새로운 token: $accessToken');
        print('새로운 리프레시 : $refreshToken');
      } else {
        print('토큰요청 실패');
        throw Exception('Failed to register reservation');
      }
    } on DioException catch (e) {
      print('토큰요청 에러: ${e.message}');
      throw Exception('Error making reservation request: ${e.message}');
    }
  }
}
