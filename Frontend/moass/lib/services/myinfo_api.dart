import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyInfoApi {
  final Dio dio;
  final FlutterSecureStorage storage;

  static const String baseUrl =
      'https://k10e203.p.ssafy.io'; // Base URL as a constant

  MyInfoApi(this.dio, this.storage);

  Future<void> fetchUserProfile() async {
    try {
      // Retrieve the access token from secure storage
      String? accessToken = await storage.read(key: 'accessToken');

      if (accessToken == null) {
        print('No access token available');
        return;
      }

      // Set up headers with the retrieved access token
      final response = await dio.get(
        '$baseUrl/api/user/profile',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      if (response.statusCode == 200) {
        // 성공적으로 데이터를 받아옴
        print('User profile: ${response.data}');
      } else {
        // 서버 응답에 문제가 있는 경우
        print('Failed to load user profile');
      }
    } on DioException catch (e) {
      // 네트워크 또는 요청 관련 오류 처리
      print('Error fetching user profile: ${e.message}');
      if (e.response?.statusCode == 401) {
        // Handle token expiration or unauthorized access
        print('Unauthorized request, token might be expired');
      }
    }
  }
}
