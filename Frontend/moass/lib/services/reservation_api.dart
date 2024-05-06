// 계정 관련 API 요청
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ReservationApi {
  final Dio dio;
  final FlutterSecureStorage storage;

  static const String baseUrl = 'https://k10e203.p.ssafy.io';

  ReservationApi({required this.dio, required this.storage});

  // 로그인 함수
  Future<bool> login(String userEmail, String password) async {
    const apiUrl = '$baseUrl/api/user/login';
    try {
      final response = await dio.post(apiUrl, data: {
        'userEmail': userEmail,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data['data'];
        await storage.write(key: 'isLoggedIn', value: 'true');
        await storage.write(key: 'accessToken', value: data['accessToken']);
        await storage.write(key: 'refreshToken', value: data['refreshToken']);
        return true;
      } else {
        throw Exception(response.data['message'] ?? "로그인 실패");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? '로그인에 실패했습니다.');
    }
  }

  // 로그아웃 함수
  Future<bool> logout() async {
    try {
      await storage.delete(key: 'isLoggedIn');
      await storage.delete(key: 'accessToken');
      await storage.delete(key: 'refreshToken');
      return true; // 로그아웃 성공
    } catch (e) {
      print('Logout failed: $e');
      return false; // 로그아웃 실패
    }
  }

  // 회원가입 함수
  Future<bool> signUp(String ssafy, String email, String password) async {
    const String apiUrl = '$baseUrl/api/user/signup';
    try {
      final response = await dio.post(apiUrl, data: {
        "userEmail": email,
        "userId": ssafy,
        "password": password,
      });

      if (response.statusCode == 200) {
        // 성공적으로 회원가입 처리됨, 필요한 경우 추가 처리
        return true;
      }
      return false;
    } on DioException catch (e) {
      print('Sign Up failed with error: ${e.response?.statusCode}');
      return false;
    }
  }
}
