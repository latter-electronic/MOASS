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
    // print('검색 클래스 코드 : $classcode');
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print('No access token available');
        return [];
      }

      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/device/search?classcode=$classcode',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        // print('기기 정보 조회 성공!');
        print('기기정보리스트:${response.data['data']}');

        final List<dynamic> deviceInfos = response.data['data'];
        for (var deviceInfo in deviceInfos) {
          deviceInstances.add(DeviceInfo.fromJson(deviceInfo));
        }
        // print(userProfileInstances);
        return deviceInstances;
      } else {
        print('Failed to load device info');
        return [];
      }
    } on DioException catch (e) {
      print('Error fetching device info: ${e.message}');
      return [];
    }
  }

  // 유저 호출
  callUser(String userId) async {
    try {
      Map data = {'userId': userId};
      var body = json.encode(data);
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        // print('No access token available');
        return [];
      }
      // print(accessToken);
      // API요청, 헤더에 토큰 넣기
      final response = await dio.post('$baseUrl/api/device/call',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: body);

      if (response.statusCode == 200) {
        print('유저 호출 성공!');
        return response;
      } else {
        print('유저 호출 실패');
        return [];
      }
    } on DioException catch (e) {
      print('호출 에러: ${e.message}');
      return null;
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
        print('로그아웃 성공!');
        print('response.data["message"]');
        return response.data["message"];
      }
    } on DioException catch (e) {
      print('로그아웃 실패');
    }
  }
}
