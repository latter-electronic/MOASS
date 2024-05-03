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
        print('No access token available');
        return [];
      }
      // print(accessToken);
      // API요청, 헤더에 토큰 넣기
      final response = await dio.get(
        '$baseUrl/api/schedule/todo',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        // print('데이터 : ${response.data['data']}');
        final List<dynamic> todos = response.data['data'];
        // print(todos);
        for (var todo in todos) {
          // print(todo);
          todoInstances.add(ToDo.fromJson(todo));
        }
        // print('투두인스턴스 : $todoInstances');
        return todoInstances;
      } else {
        print('Failed to load user profile');
        return [];
      }
    } on DioException catch (e) {
      print('Error fetching user profile: ${e.message}');
      return [];
    }
  }

  postUserToDoList(var content) async {
    final formData = FormData.fromMap({'content': content});
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print('No access token available');
        return [];
      }
      // print(accessToken);
      // API요청, 헤더에 토큰 넣기
      final response = await dio.post('$baseUrl/api/schedule/todo',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: formData);

      if (response.statusCode == 200) {
        print('할 일 등록 성공!');
        return;
      } else {
        print('To Do 등록 실패');
        return [];
      }
    } on DioException catch (e) {
      print('Error fetching user profile: ${e.message}');
      return [];
    }
  }
}
