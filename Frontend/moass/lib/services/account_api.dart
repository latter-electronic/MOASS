// 계정 관련 API 요청

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moass/model/token_interceptor.dart';

class AccountApi {
  final Dio dio;

  AccountApi({required this.dio}) {
    _initializeInterceptors();
  }

  void _initializeInterceptors() async {
    final prefs = await SharedPreferences.getInstance();
    dio.interceptors.add(TokenInterceptor(dio, prefs));
  }

  Future<bool> login(String userEmail, String password) async {
    const apiUrl = 'https://k10e203.p.ssafy.io/api/user/login';
    try {
      final response = await dio.post(apiUrl, data: {
        'userEmail': userEmail,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('accessToken', data['accessToken']);
        await prefs.setString('refreshToken', data['refreshToken']);
        return true;
      }
      return false;
    } on DioException catch (e) {
      print('Login failed with error: ${e.response?.statusCode}');
      return false;
    }
  }

  Future<bool> signUp(String ssafy, String email, String password) async {
    const String apiUrl = 'https://k10e203.p.ssafy.io/api/user/signup';
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
