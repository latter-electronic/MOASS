import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/firebase_options.dart';
import 'package:moass/model/token_interceptor.dart';
import 'package:moass/screens/login_screen.dart';
import 'package:moass/screens/home_screen.dart';
import 'package:moass/screens/setting_screen.dart';
import 'package:moass/services/account_api.dart';
import 'package:permission_handler/permission_handler.dart';

// 백그라운드 메시지 설정
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin _local =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  const storage = FlutterSecureStorage();
  final dio = Dio();
  dio.interceptors.add(TokenInterceptor(dio, storage));

  final bool isLoggedIn = await checkLoginStatus(storage);
  final bool isTokenValid =
      isLoggedIn ? await checkTokenValidityAndRefresh(dio, storage) : false;

  // FCM 토큰 설정
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  // 스토리지에 담기
  await storage.write(key: 'fcmToken', value: fcmToken);
  print('FCM Token: $fcmToken');

  // 권한 요청
  FirebaseMessaging.instance.requestPermission(
    badge: true,
    alert: true,
    sound: true,
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
    RemoteNotification? notification = message?.notification;
    if (message != null) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data["click_action"]);
      }
    }

    if (notification != null) {
      _local
          .show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  importance: Importance.max,
                  priority: Priority.high,
                ),
              ))
          .then((_) {
        Future.delayed(const Duration(seconds: 5), () {
          _local.cancel(notification.hashCode);
        });
      });
    }
  });

  // 백그라운드 메시지 관련
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
    if (message != null) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data["click_action"]);
      }
    }
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data["click_action"]);
      }
    }
  });

  runApp(MyApp(isLoggedIn: isLoggedIn));
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
    print("엑세스 토큰: $accessToken");
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

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Local Notification 초기화

  @override
  void initState() {
    super.initState();
    _permissionWithNotification();
    _initialization();
  }

  void _permissionWithNotification() async {
    if (await Permission.notification.isDenied &&
        !await Permission.notification.isPermanentlyDenied) {
      await [Permission.notification].request();
    }
  }

  void _initialization() async {
    AndroidInitializationSettings android =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings ios = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings settings =
        InitializationSettings(android: android, iOS: ios);
    await _local.initialize(settings);
  }

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
      initialRoute: widget.isLoggedIn ? '/homeScreen' : '/loginScreen',
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
