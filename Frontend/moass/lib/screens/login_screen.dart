import 'package:flutter/material.dart';
import 'package:moass/model/token_interceptor.dart';
import 'package:moass/screens/home_screen.dart';
import 'package:moass/screens/signup_screen.dart';
import 'package:moass/services/account_api.dart';
import 'package:moass/widgets/custom_login_form.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AccountApi _accountApi;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String username = '';
  String password = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    dio.interceptors.add(TokenInterceptor(dio, _storage));
    _accountApi = AccountApi(dio: dio, storage: _storage);
  }

  Future<void> _login() async {
    bool isLoggedIn = await _accountApi.login(username, password);
    if (isLoggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false, // 모든 그 전의경로를 삭제
      );
    } else {
      setState(() {
        _errorMessage = '로그인에 실패했습니다. 이메일, 비밀번호를 확인해주세요';
      });
    }
  }

  void _signup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 160,
              ),
              Image.asset('assets/img/logo_basic.png'),
              const SizedBox(height: 16.0),
              const _SubTitleId(),
              CustomLoginFormField(
                hintText: 'e-mail',
                onChanged: (String value) {
                  username = value;
                },
              ),
              const SizedBox(height: 4.0),
              const _SubTitlePw(),
              CustomLoginFormField(
                hintText: 'Password',
                onChanged: (String value) {
                  password = value;
                },
                obscureText: true,
              ),
              const SizedBox(height: 25.0),
              ElevatedButton(
                onPressed: () async {
                  await _login();
                  await AccountApi(
                          dio: Dio(), storage: const FlutterSecureStorage())
                      .postFCMToken();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: const Text(
                  '로그인',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: _signup,
                style: TextButton.styleFrom(foregroundColor: Colors.black),
                child: const Text('회원가입'),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Moass',
          style: TextStyle(
              fontSize: 36, fontWeight: FontWeight.w500, color: Colors.blue),
        ),
      ],
    );
  }
}

class _SubTitleId extends StatelessWidget {
  const _SubTitleId({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      // 줄바꿈은 \n
      'ID (e-mail)',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitlePw extends StatelessWidget {
  const _SubTitlePw({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      // 줄바꿈은 \n
      'PW',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }
}
