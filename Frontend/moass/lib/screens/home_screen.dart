import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/myprofile.dart';
import 'package:moass/screens/login_screen.dart';
import 'package:moass/screens/main_admin_home_screen.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // SSE 구독
    SSEListener(storage: const FlutterSecureStorage()).connectUserEvent();
    SSEListener(storage: const FlutterSecureStorage()).connectTeamEvent();

    fetchUserProfileAndSetup();
  }

  void fetchUserProfileAndSetup() async {
    MyProfile? profile = await _api.fetchUserProfile();
    if (profile != null) {
      setupWidgetOptions(profile.jobCode);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  void setupWidgetOptions(int jobCode) {
    _widgetOptions = [
      (jobCode == 1) ? const WorkScreen() : const WorkAdminScreen(),
      (jobCode == 1)
          ? const ReservationScreen()
          : const ReservationAdminScreen(),
      (jobCode == 1) ? const MainHomeScreen() : const MainAdminScreen(),
      jobCode == 1 ? const SeatScreen() : const SeatAdminScreen(),
      const BoardScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: MainHomeScreen(),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: _widgetOptions.isNotEmpty
            ? _widgetOptions.elementAt(_selectedIndex)
            : const CircularProgressIndicator(), // 로딩 표시
      ),
      bottomNavigationBar: _widgetOptions.isNotEmpty
          ? BottomNavBar(
              currentIndex: _selectedIndex,
              onItemSelected: _onItemTapped,
            )
          : null,
    );
  }
}
