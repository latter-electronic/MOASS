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

  // 파이어베이스 설정
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  const storage = FlutterSecureStorage();
  final dio = Dio();
  dio.interceptors.add(TokenInterceptor(dio, storage));

  // FCM 토큰 설정
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  // 스토리지에 담기
  await storage.write(key: 'fcmToken', value: fcmToken);
  print('FCM Token: $fcmToken');

  // 알림 권한
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

  final accountApi = AccountApi(dio: dio, storage: storage);
  final bool isLoggedIn = await _getLoginStatus(storage);

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

Future<bool> _getLoginStatus(FlutterSecureStorage storage) async {
  final isLoggedIn = await storage.read(key: 'isLoggedIn');
  print('로그인? ${isLoggedIn.toString()}');
  return isLoggedIn == 'true';
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
