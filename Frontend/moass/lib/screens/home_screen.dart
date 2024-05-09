import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:moass/model/myprofile.dart';
import 'package:moass/screens/reservation_admin_screen.dart';
import 'package:moass/screens/work_screen.dart';
import 'package:moass/screens/reservation_screen.dart';
import 'package:moass/screens/main_home_screen.dart';
import 'package:moass/screens/seat_screen.dart';
import 'package:moass/screens/board_screen.dart';
import 'package:moass/services/myinfo_api.dart';
import 'package:moass/widgets/bottom_navbar.dart';
import 'package:moass/widgets/top_bar.dart'; // Import your CustomAppBar

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
        const WorkScreen(),
        (jobCode == 1) ? const ReservationScreen() : ReservationAdminScreen(),
        const MainHomeScreen(),
        const SeatScreen(),
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
    return Scaffold(
      body: Center(
        child: _widgetOptions.isNotEmpty
            ? _widgetOptions.elementAt(_selectedIndex)
            : const CircularProgressIndicator(),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}
