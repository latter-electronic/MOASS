import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/firebase_options.dart';
import 'package:moass/model/token_interceptor.dart';
import 'package:moass/screens/login_screen.dart';
import 'package:moass/screens/home_screen.dart';
import 'package:moass/screens/setting_screen.dart';
import 'package:moass/services/account_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  const storage = FlutterSecureStorage();
  final dio = Dio();
  dio.interceptors.add(TokenInterceptor(dio, storage));

  final bool isLoggedIn = await checkLoginStatus(storage);
  final bool isTokenValid =
      isLoggedIn ? await checkTokenValidityAndRefresh(dio, storage) : false;

  runApp(MyApp(isLoggedIn: isTokenValid));
}

// 로그인 상태 확인
Future<bool> checkLoginStatus(FlutterSecureStorage storage) async {
  final isLoggedIn = await storage.read(key: 'isLoggedIn');
  print("isLoggedIn: $isLoggedIn"); // 로그 출력
  return isLoggedIn == 'true';
}

// 토큰 유효성 검사 및 갱신
Future<bool> checkTokenValidityAndRefresh(
    Dio dio, FlutterSecureStorage storage) async {
  try {
    final accessToken = await storage.read(key: 'accessToken');
    final refreshToken = await storage.read(key: 'refreshToken');

    if (accessToken == null || refreshToken == null) {
      return false;
    }

    // accessToken 유효성 검사 시도
    var response = await dio.get('https://k10e203.p.ssafy.io/api/user');
    if (response.statusCode == 200) {
      return true; // 토큰이 유효한 경우
    }
  } catch (e) {
    // 유효하지 않거나 오류 발생 시, refreshToken 요청
    if (await refreshTokenRequest(dio, storage)) {
      return true; // 토큰 갱신 성공
    }
  }
  return false; // 토큰 유효하지 않음
}

// Refresh 토큰으로 Access 토큰 갱신
Future<bool> refreshTokenRequest(Dio dio, FlutterSecureStorage storage) async {
  try {
    final refreshToken = await storage.read(key: 'refreshToken');
    print("refreshToken: $refreshToken"); // 로그 출력
    final response = await dio.post(
      'https://k10e203.p.ssafy.io/api/user/refresh',
      options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),

      // data: {'refreshToken': refreshToken}
    );

    print("Response Status: ${response.statusCode}"); // 응답 상태 로그 출력
    if (response.statusCode == 200) {
      final newAccessToken = response.data['accessToken'];
      await storage.write(key: 'accessToken', value: newAccessToken);
      return true;
    }
  } catch (e) {
    print('Refresh token failed: $e'); // 에러 로그 출력
  }
  return false;
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
      // home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
