import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // For secure storage
import 'package:moass/screens/home_screen.dart';
import 'package:moass/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  void _navigateToNextPage() async {
    // Check if the token or login state is present
    String? isLoggedIn = await _storage.read(key: 'isLoggedIn');
    // Use a delay to simulate the splash screen effect
    await Future.delayed(const Duration(seconds: 3));

    if (isLoggedIn != null && isLoggedIn == 'true') {
      // If the user is logged in, navigate to the HomeScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // If the user is not logged in, navigate to the LoginScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xff6ECEF5), // Background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/img/splashLogo.png'), // Your logo here
              const SizedBox(height: 20),
              // const Text(
              //   '우리의 더 커진 공간 세상을 위해,',
              //   style: TextStyle(
              //     color: Color(0xff6ECEF5),
              //     fontSize: 16,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
