import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/token_interceptor.dart';
import 'package:moass/screens/login_screen.dart';
import 'package:moass/screens/home_screen.dart';
import 'package:moass/screens/setting_screen.dart';
import 'package:moass/services/account_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const storage = FlutterSecureStorage();
  final dio = Dio();
  dio.interceptors.add(TokenInterceptor(dio, storage));

  final accountApi = AccountApi(dio: dio, storage: storage);
  final bool isLoggedIn = await _getLoginStatus(storage);

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

Future<bool> _getLoginStatus(FlutterSecureStorage storage) async {
  final isLoggedIn = await storage.read(key: 'isLoggedIn');
  return isLoggedIn == 'true';
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moass',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6ECEF5),
            primary: const Color(0xFF6ECEF5)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: isLoggedIn ? '/homeScreen' : '/loginScreen',
      routes: {
        // 메인에서 뒤로가기 버튼 생기는 원인 나중에 확인되면 지우기
        '/homeScreen': (context) => const HomeScreen(),
        '/loginScreen': (context) => const LoginScreen(),
        '/settingScreen': (context) => const SettingScreen(),
        // 추가 라우트 필요할 경우 추가
      },
      // 메인화면 중첩을 피하기 위한 주석처리 만약 어플 켰을때 무한로딩 돌면 앱 삭제 후 여기 주석 풀기
      // home: FutureBuilder<bool>(
      //     future: _getLoginStatus(),
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.done) {
      //         print(ConnectionState.done);
      //         print(snapshot.data);
      //         return snapshot.data ?? false
      //             ? const HomeScreen()
      //             : const LoginScreen();
      //       } else {
      //         return const CircularProgressIndicator();
      //       }
      //     }),
    );
  }

  Future<bool> _getLoginStatus() async {
    const storage = FlutterSecureStorage();
    final isLoggedIn = await storage.read(key: 'isLoggedIn');
    return isLoggedIn == 'true';
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
