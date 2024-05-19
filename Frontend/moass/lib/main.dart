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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moass/services/api_service.dart';

// 백그라운드 메시지 설정
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

final FlutterLocalNotificationsPlugin _local =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  const storage = FlutterSecureStorage();
  final dio = Dio();
  dio.interceptors.add(TokenInterceptor(dio, storage));

  final bool isLoggedIn = await checkLoginStatus(storage);

  if (isLoggedIn) {
    await initializeFirebaseAndNotifications(storage);
  }
  runApp(ProviderScope(
      child: MyApp(isLoggedIn: isLoggedIn, dio: dio, storage: storage)));
}

// Firebase 및 알림 초기화
Future<void> initializeFirebaseAndNotifications(
    FlutterSecureStorage storage) async {
  // FCM 토큰 설정
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  await storage.write(key: 'fcmToken', value: fcmToken);

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
      if (message.notification != null) {}
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
            icon: "@drawable/ic_notification",
          ),
        ),
      )
          .then((_) {
        Future.delayed(const Duration(seconds: 5), () {
          _local.cancel(notification.hashCode);
        });
      });
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
    if (message != null) {
      if (message.notification != null) {}
    }
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      if (message.notification != null) {}
    }
  });
}

// 로그인 상태 확인
Future<bool> checkLoginStatus(FlutterSecureStorage storage) async {
  final isLoggedIn = await storage.read(key: 'isLoggedIn');
  return isLoggedIn == 'true';
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  final Dio dio;
  final FlutterSecureStorage storage;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    required this.dio,
    required this.storage,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(dio: widget.dio, storage: widget.storage);
    if (widget.isLoggedIn) {
      initializeFirebaseAndNotifications(const FlutterSecureStorage());
    }
    mainTokenRefresh();
    // 저장소권한 확인
    // _permissionWithNotification();
  }

  void mainTokenRefresh() async {
    try {
      await apiService.manualRefresh();
    } catch (e) {
      // 로그인이 필요하면 로그인 화면으로 이동
      // Navigator.pushReplacementNamed(context, '/loginScreen');
    }
  }

// // 저장소 권한 확인
//   void _permissionWithNotification() async {
//     if (await Permission.notification.isDenied &&
//         !await Permission.notification.isPermanentlyDenied) {
//       await [Permission.notification].request();
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moass',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6ECEF5),
          primary: const Color(0xFF6ECEF5),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: widget.isLoggedIn ? '/homeScreen' : '/loginScreen',
      routes: {
        '/homeScreen': (context) => const HomeScreen(),
        '/loginScreen': (context) => const LoginScreen(),
        '/settingScreen': (context) => const SettingScreen(),
      },
    );
  }
}
