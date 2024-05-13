import 'package:flutter/material.dart';
import 'package:moass/widgets/custom_login_form.dart';
import 'package:moass/services/account_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final AccountApi _accountApi;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String ssafy = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String? passwordErrorText;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    _accountApi = AccountApi(dio: dio, storage: _storage);
  }

  void checkPassword() {
    if (password != confirmPassword) {
      setState(() {
        passwordErrorText = '비밀번호가 일치하지 않습니다';
      });
    } else {
      setState(() {
        passwordErrorText = null;
      });
    }
  }

  void signUp() async {
    if (password == confirmPassword && password.isNotEmpty) {
      bool isSignedUp = await _accountApi.signUp(ssafy, email, password);
      if (isSignedUp) {
        Navigator.pop(context);
        // You might want to automatically navigate to the login screen or show a message
      } else {
        setState(() {
          passwordErrorText = '회원가입에 실패하였습니다.';
        });
      }
    } else {
      setState(() {
        passwordErrorText = '비밀번호를 확인해주세요.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("회원가입"),
      ),
      body: SingleChildScrollView(
        // 스크롤 가능하도록 SingleChildScrollView 추가
        child: Padding(
          padding: const EdgeInsets.all(20.0), // 패딩 추가
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SubTitle(text: 'SSAFY 학번'),
              CustomLoginFormField(
                hintText: 'SSAFY 학번',
                onChanged: (String value) {
                  ssafy = value;
                },
                obscureText: false,
                textInputAction: TextInputAction.next, // 비밀번호 입력 후 다음 필드로 이동
              ),
              const SizedBox(height: 20.0), // 필드 사이 간격 추가
              const SubTitle(text: '사용하실 e-mail'),
              CustomLoginFormField(
                hintText: 'E-mail',
                onChanged: (String value) {
                  email = value;
                },
                obscureText: false, // 이메일 입력 필드이므로 가릴 필요 없음
                textInputAction: TextInputAction.next, // 비밀번호 입력 후 다음 필드로 이동
              ),
              const SizedBox(height: 20.0), // 필드 사이 간격 추가
              const SubTitle(
                text: '사용하실 비밀번호',
              ),
              CustomLoginFormField(
                hintText: 'Password',
                onChanged: (String value) {
                  password = value;
                },
                obscureText: true, // 비밀번호 필드는 가려야 함
                textInputAction: TextInputAction.next, // 비밀번호 입력 후 다음 필드로 이동
              ),
              const SizedBox(height: 20.0),
              const SubTitle(text: '비밀번호 확인'),
              CustomLoginFormField(
                hintText: 'Confirm Password',
                onChanged: (String value) {
                  confirmPassword = value;
                  checkPassword(); // 비밀번호 확인
                },
                obscureText: true,
                errorText: passwordErrorText, // 비밀번호 일치 오류 메시지
                textInputAction: TextInputAction.done, // 비밀번호 입력 후 다음 필드로 이동
              ),
              const SizedBox(height: 40.0), // 버튼 전 간격 추가
              ElevatedButton(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text("회원가입"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubTitle extends StatelessWidget {
  final String text; // 이제 텍스트를 외부에서 받아올 수 있습니다.
  const SubTitle({
    super.key,
    required this.text, // text를 필수 인자로 받습니다.
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text, // 전달받은 text를 사용합니다.
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }
}
