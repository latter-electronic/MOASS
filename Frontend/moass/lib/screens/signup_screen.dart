import 'package:flutter/material.dart';
import 'package:moass/widgets/custom_login_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String ssafy = '';
  String email = '';
  String password = '';
  String confirmPassword = ''; // 비밀번호 확인을 위한 상태 변수
  String? passwordErrorText; // 비밀번호 오류 메시지
  final FocusNode _ssafyFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

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

  // 다음 폼으로 넘어가기 위한 함수
  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
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
                // focusNode: _ssafyFocus,
                // onFieldSubmitted: (_) =>
                //     FocusScope.of(context).requestFocus(_emailFocus),
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
                // focusNode: _emailFocus,
                // onFieldSubmitted: (_) =>
                //     FocusScope.of(context).requestFocus(_passwordFocus),
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
                // focusNode: _passwordFocus,
                // onFieldSubmitted: (_) =>
                //     FocusScope.of(context).requestFocus(_confirmPasswordFocus),
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
                // focusNode: _confirmPasswordFocus,
                textInputAction: TextInputAction.done, // 비밀번호 입력 후 다음 필드로 이동
              ),
              const SizedBox(height: 40.0), // 버튼 전 간격 추가
              ElevatedButton(
                onPressed: () {
                  // 회원가입 로직 구현 필요
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // 버튼 색상 설정
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
