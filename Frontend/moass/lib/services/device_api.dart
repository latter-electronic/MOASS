import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/device_info.dart';

class DeviceApi {
  final Dio dio;
  final FlutterSecureStorage storage;
  static const String baseUrl = 'https://k10e203.p.ssafy.io';

  // dio와 storage에 담긴 데이터 활용하겠다 선언
  DeviceApi({required this.dio, required this.storage});

  // 우리반 기기 조회
  Future<List<DeviceInfo>> fetchClassDevices(String? classcode) async {
    List<DeviceInfo> deviceInstances = [];
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        return [];
      }

      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/device/search?classcode=$classcode',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> deviceInfos = response.data['data'];
        for (var deviceInfo in deviceInfos) {
          deviceInstances.add(DeviceInfo.fromJson(deviceInfo));
        }
        // print(userProfileInstances);
        return deviceInstances;
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw Exception('clssView failed with error: $e');
      // return [];
    }
  }

  // 유저 호출
  callUser(String userId, String? message) async {
    try {
      Map data = {'userId': userId, 'message': ''};
      var body = json.encode(data);
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        return [];
      }
      // print(accessToken);
      // API요청, 헤더에 토큰 넣기
      final response = await dio.post('$baseUrl/api/user/call',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch callUser: $e');
      // return null;
    }
  }

  // 디바이스 로그아웃
  disconnectDevice() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');

      final response = await dio.post(
        '$baseUrl/api/device/logout',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        return response.data["message"];
      }
    } on DioException catch (e) {
      throw Exception('Login failed with error: $e');
    }
  }
}
