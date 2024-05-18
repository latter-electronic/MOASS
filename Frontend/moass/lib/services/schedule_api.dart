import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moass/model/scheduleModel.dart';

class ScheduleApi {
  final Dio dio;
  final FlutterSecureStorage storage;
  final String baseUrl = "https://k10e203.p.ssafy.io/api";

  ScheduleApi({required this.dio, required this.storage});

  // 모음보드 방 목록 들어오는 함수
  Future<Schedule> fetchSchedule(String date) async {
    print('날짜 $date');
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception('No access token available');
      }

      final response = await dio.get('$baseUrl/schedule/curriculum/$date',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      print('스케쥴 : ${response.data.toString()}');
      if (response.statusCode == 200) {
        final data = response.data['data'];
        return Schedule.fromJson(data);
      } else {
        throw Exception('Failed to load schedule');
      }
    } catch (e) {
      throw Exception('Failed to fetch schedule: $e');
    }
  }
}

// Provider 정의
final dioProvider = Provider((ref) => Dio());
final storageProvider = Provider((ref) => const FlutterSecureStorage());

final boardApiProvider = Provider<ScheduleApi>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(storageProvider);
  return ScheduleApi(dio: dio, storage: storage);
});
