import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/myprofile.dart';

class MyInfoApi {
  final Dio dio;
  final FlutterSecureStorage storage;
  static const String baseUrl = 'https://k10e203.p.ssafy.io';

  MyInfoApi({required this.dio, required this.storage});

  Future<MyProfile?> fetchUserProfile() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print('No access token available');
        return null;
      }

      final response = await dio.get(
        '$baseUrl/api/user',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        return MyProfile.fromJson(response.data['data']);
      } else {
        print('Failed to load user profile');
        return null;
      }
    } on DioException catch (e) {
      print('Error fetching user profile: ${e.message}');
      return null;
    }
  }
}
