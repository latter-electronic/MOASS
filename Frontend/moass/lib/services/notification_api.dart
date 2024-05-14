import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/notification_model.dart';

class NotiApi {
  final Dio dio;
  final FlutterSecureStorage storage;
  static const String baseUrl = 'https://k10e203.p.ssafy.io';

  // dio와 storage에 담긴 데이터 활용하겠다 선언
  NotiApi({required this.dio, required this.storage});

  Future<List<Noti>?> fetchNotification() async {
    try {
      List<Noti>? notiListsInstance = [];
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print('No access token available');
        return [];
      }

      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/notification/search',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        print('알림 리스트 조회 성공!');
        // print(response.data.toString());
        final List<dynamic> notiLists = response.data['data']['notifications'];
        for (var notiInfo in notiLists) {
          notiListsInstance.add(Noti.fromJson(notiInfo));
        }

        return notiListsInstance;
      }
    } on DioException catch (e) {
      print('Error: ${e.message}');
      return [];
    }
    return null;
  }
}
