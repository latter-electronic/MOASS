// 예약 관련 API 요청
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/reservation_model.dart';

class ReservationApi {
  // 필요한 라이브러리 및 베이스 URL 설정
  final Dio dio;
  final FlutterSecureStorage storage;
  static const String baseUrl = 'https://k10e203.p.ssafy.io';

  ReservationApi({required this.dio, required this.storage});

  // 내 예약 조회
  Future<MyReservationModel?> myReservationinfo() async {
    // const apiUrl = '$baseUrl/reservationinfo/search?date=';
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print('No access token available');
        return null;
      }
      print(accessToken);
      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/reservationinfo',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        return MyReservationModel.fromJson(response.data['data']);
      } else {
        print('내 예약정보 불러오기 실패');
        return null;
      }
    } on DioException catch (e) {
      print('Error myReservationinfo: ${e.message}');
      return null;
    }
  }

  // 특정 날짜 예약 조회
  Future<ReservationDayModel?> reservationinfoDay() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print('No access token available');
        return null;
      }
      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
          '$baseUrl/api/reservationinfo/search?date=YYYY-MM-DD',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      if (response.statusCode == 200) {
        print('해당 날짜 예약정보 불러오기 성공!');
        return ReservationDayModel.fromJson(response.data['data']);
      } else {
        print('해당날짜 유저정보 불러오기 실패');
        return null;
      }
    } on DioException catch (e) {
      print('Error fetching user status: ${e.message}');
      return null;
    }
  }
}
