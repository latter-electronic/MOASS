import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/scheduleModel.dart';

class ScheduleApi {
  final Dio dio;
  final FlutterSecureStorage storage;
  final String baseUrl = "https://k10e203.p.ssafy.io/api";

  ScheduleApi({required this.dio, required this.storage});

  // 스케쥴 API
  Future<Schedule> fetchSchedule(String date) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception('No access token available');
      }

      final response = await dio.get('$baseUrl/schedule/curriculum/$date',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data == null) {
          throw Exception('Schedule data is null');
        }
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
