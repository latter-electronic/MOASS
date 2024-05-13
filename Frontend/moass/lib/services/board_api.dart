// API 임시 설정

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/BoardModel.dart';
import 'package:moass/services/myinfo_api.dart';
import 'package:moass/model/myprofile.dart';

class BoardApi {
  final Dio dio;
  final FlutterSecureStorage storage;
  final String baseUrl = "https://k10e203.p.ssafy.io/api";

  BoardApi({required this.dio, required this.storage});

  Future<List<BoardModel>> fetchBoards(String userId) async {
    try {
      final response = await dio.get('$baseUrl/board/$userId');
      if (response.statusCode == 200) {
        List<dynamic> boardsJson = response.data['data'];
        return boardsJson.map((json) => BoardModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load boards');
      }
    } catch (e) {
      throw Exception('Failed to fetch boards: $e');
    }
  }
}
