import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/to_do.dart';

class ToDoListApi {
  final Dio dio;
  final FlutterSecureStorage storage;
  static const String baseUrl = 'https://k10e203.p.ssafy.io';

  ToDoListApi({required this.dio, required this.storage});

  Future<List<ToDo>> getUserToDoList() async {
    List<ToDo> todoInstances = [];
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        return [];
      }
      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/schedule/todo',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> todos = response.data['data'];
        for (var todo in todos) {
          todoInstances.add(ToDo.fromJson(todo));
        }
        return todoInstances;
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw Exception('Error getUserToDoList: ${e.message}');
      // return [];
    }
  }

  postUserToDoList(String content) async {
    try {
      Map data = {'content': content};
      var body = json.encode(data);
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        return [];
      }
      // API요청, 헤더에 토큰 넣기
      final response = await dio.post('$baseUrl/api/schedule/todo',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw Exception('Error postUserToDoList: ${e.message}');
      // return [];
    }
  }

  deleteUserToDoList(var todoId) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        return [];
      }
      // API요청, 헤더에 토큰 넣기
      final response = await dio.delete('$baseUrl/api/schedule/todo/$todoId',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      if (response.statusCode == 200) {
        return response;
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw Exception('Error deleteUserToDoList: ${e.message}');
      // return [];
    }
  }

  patchUserToDoList(String todoId, bool completedFlag) async {
    try {
      Map data = {'todoId': todoId, 'completedFlag': completedFlag};
      var body = json.encode(data);
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        return [];
      }
      // API요청, 헤더에 토큰 넣기
      final response = await dio.patch('$baseUrl/api/schedule/todo',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw Exception('Error patchUserToDoList: ${e.message}');
      // return [];
    }
  }
}
