import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/token_interceptor.dart';
import 'package:moass/screens/login_screen.dart';
import 'package:moass/screens/home_screen.dart';
import 'package:moass/services/account_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const storage = FlutterSecureStorage();
  final dio = Dio();
  dio.interceptors.add(TokenInterceptor(dio, storage));

  final accountApi = AccountApi(dio: dio, storage: storage);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moass',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: const HomeScreen(),
      // FutureBuilder로 비동기 작업의 결과에 따라 다른 페이지 표시
      home: FutureBuilder(
          // _getLoginStatus 함수의 결과를 기다림
          future: _getLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.data == true
                  ? const HomeScreen()
                  : const LoginScreen();
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  // SharedPreferences 라이브러리를 사용해서 저장된 로그인 상태를 불러옴
  Future<bool> _getLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // 로그인 정보가 없다면 false로 변경
    return prefs.getBool('isLogin') ?? false;
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
