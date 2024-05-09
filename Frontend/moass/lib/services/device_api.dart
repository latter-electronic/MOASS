import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/device_info.dart';

class DeviceApi {
  final Dio dio;
  final FlutterSecureStorage storage;
  static const String baseUrl = 'https://k10e203.p.ssafy.io';

  // dio와 storage에 담긴 데이터 활용하겠다 선언
  DeviceApi({required this.dio, required this.storage});

  // 우리반 조회
  Future<List<DeviceInfo>> fetchClassDevices(String? classcode) async {
    List<DeviceInfo> deviceInstances = [];
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
        print('조회 성공!');
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
}
