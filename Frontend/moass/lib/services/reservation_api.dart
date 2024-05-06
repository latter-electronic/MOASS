// 계정 관련 API 요청
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ReservationApi {
  final Dio dio;
  final FlutterSecureStorage storage;

  static const String baseUrl = 'https://k10e203.p.ssafy.io';

  ReservationApi({required this.dio, required this.storage});

  // 특정 날짜 예약조회
  Future<bool> reservationinfoDay(String userEmail, String password) async {
    const apiUrl = '$baseUrl/reservationinfo/search?date=';
    try {
      final response = await dio.get(apiUrl, data: {
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
