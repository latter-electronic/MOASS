import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:moass/model/myprofile.dart';
import 'package:moass/screens/login_screen.dart';
import 'package:moass/screens/reservation_admin_screen.dart';
import 'package:moass/screens/work_admin_screen.dart';
import 'package:moass/screens/seat_admin_screen.dart';
import 'package:moass/screens/work_screen.dart';
import 'package:moass/screens/reservation_screen.dart';
import 'package:moass/screens/main_home_screen.dart';
import 'package:moass/screens/seat_screen.dart';
import 'package:moass/screens/board_screen.dart';
import 'package:moass/services/myinfo_api.dart';
import 'package:moass/services/sse_listener_api.dart';
import 'package:moass/widgets/bottom_navbar.dart';
import 'package:moass/widgets/top_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;
  List<Widget> _widgetOptions = [];
  final MyInfoApi _api =
      MyInfoApi(dio: Dio(), storage: const FlutterSecureStorage());

  @override
  void initState() {
    super.initState();
    // SSE 구독
    // SSEListener(storage: const FlutterSecureStorage()).connectUserEvent();
    SSEListener(storage: const FlutterSecureStorage()).connectTeamEvent();

    fetchUserProfileAndSetup();
  }

  void fetchUserProfileAndSetup() async {
    MyProfile? profile = await _api.fetchUserProfile();
    if (profile != null) {
      setupWidgetOptions(profile.jobCode);
    }
  }

  void setupWidgetOptions(int jobCode) {
    setState(() {
      _widgetOptions = [
        (jobCode == 1) ? const WorkScreen() : const WorkAdminScreen(),
        (jobCode == 1)
            ? const ReservationScreen()
            : const ReservationAdminScreen(),
        const MainHomeScreen(),
        jobCode == 1 ? const SeatScreen() : const SeatAdminScreen(),
        const BoardScreen(),
      ];
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _requestStoragePermission(context); // 저장소 권한 요청

    return Scaffold(
      body: Center(
        child: _widgetOptions.isNotEmpty
            ? _widgetOptions.elementAt(_selectedIndex)
            // 무한로딩시 => 로그인으로 이동 IF 바텀네브바 보이면 다시 수정
            : const LoginScreen(),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }

  // 저장소 권한 확인
  // void _requestStoragePermission(BuildContext context) async {
  //   if (await Permission.storage.isDenied) {
  //     final status = await Permission.storage.request();
  //     if (status.isGranted) {
  //       print('Storage permission granted');
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('저장소 권한이 필요합니다.'),
  //         ),
  //       );
  //     }
  //   }
  // }
}
