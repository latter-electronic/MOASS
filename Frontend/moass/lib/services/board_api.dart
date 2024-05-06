// API 임시 설정

import 'package:dio/dio.dart';
import 'package:moass/model/BoardModel.dart';

class BoardApi {
  final Dio dio = Dio();
  final String baseUrl = "https://k10e203.p.ssafy.io/api";

  Future<List<BoardModel>> fetchBoards() async {
    try {
      final response = await dio.get('$baseUrl/boards');
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
