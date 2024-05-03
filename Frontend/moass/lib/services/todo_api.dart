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
        print('Failed to load user todo list');
        return [];
      }
    } on DioException catch (e) {
      print('Error fetching user todo list: ${e.message}');
      return [];
    }
  }

  postUserToDoList(String content) async {
    try {
      Map data = {'content': content};
      var body = json.encode(data);
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        // print('No access token available');
        return [];
      }
      // print(accessToken);
      // API요청, 헤더에 토큰 넣기
      final response = await dio.post('$baseUrl/api/schedule/todo',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: body);
      // print('응답: $response');

      if (response.statusCode == 200) {
        print('todo 등록 성공!');
        return response;
      } else {
        print('todo 등록 실패');
        return [];
      }
    } on DioException catch (e) {
      print('todo 등록 에러: ${e.message}');
      return [];
    }
  }

  deleteUserToDoList(var todoId) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        // print('No access token available');
        return [];
      }
      // print(accessToken);
      // API요청, 헤더에 토큰 넣기
      final response = await dio.delete('$baseUrl/api/schedule/todo/$todoId',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      if (response.statusCode == 200) {
        print('todo 삭제 성공!');
        return response;
      } else {
        print('todo 삭제 실패');
        return [];
      }
    } on DioException catch (e) {
      print('todo 삭제 에러: ${e.message}');
      return [];
    }
  }

  patchUserToDoList(String todoId, bool completedFlag) async {
    try {
      Map data = {'todoId': todoId, 'completedFlag': completedFlag};
      var body = json.encode(data);
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        // print('No access token available');
        return [];
      }
      // print(accessToken);
      // API요청, 헤더에 토큰 넣기
      final response = await dio.patch('$baseUrl/api/schedule/todo',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: body);

      if (response.statusCode == 200) {
        print('todo 상태변경 성공!');
        return response;
      } else {
        print('todo 상태변경 실패');
        return [];
      }
    } on DioException catch (e) {
      print('todo 상태변경 에러: ${e.message}');
      return [];
    }
  }
}
