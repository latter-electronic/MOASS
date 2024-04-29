import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moass/model/token_interceptor.dart';
import 'package:moass/screens/home_screen.dart';
import 'package:moass/screens/signup_screen.dart';
import 'package:moass/services/account_api.dart';
import 'package:moass/widgets/custom_login_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AccountApi _accountApi = AccountApi(dio: Dio());
  // 이메일과 비밀번호
  String username = '';
  String password = '';

  // 에러 메시지를 위한 상태 변수
  String? _errorMessage;

  // 로그인 버튼 함수
  Future<void> _login() async {
    bool isLoggedIn = await _accountApi.login(username, password);
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      setState(() {
        _errorMessage = '로그인에 실패했습니다. 이메일, 비밀번호를 확인해주세요';
      });
    }
  }

  // 회원가입 함수
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
              const _Title(),
              const SizedBox(height: 16.0),
              const _SubTitleId(),
              // 여기서부턴 이미같은거 넣을경우 넣으면됨
              // 로그인 폼
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
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(3), // 버튼의 각 꼭지점을 둥글게 만듭니다.
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ), // 버튼의 패딩을 조절할 수 있습니다.
                ),
                child: const Text(
                  '로그인',
                  style: TextStyle(
                      fontSize: 24, // '로그인' 텍스트의 크기를 20폰트로 설정합니다.
                      color: Colors.black, // '로그인' 텍스트의 색상을 검정색으로 설정합니다.
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: _signup,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  '회원가입',
                ),
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
            fontSize: 36,
            fontWeight: FontWeight.w500,
            color: Colors.blue,
          ),
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
