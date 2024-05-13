import 'package:flutter/material.dart';

class CustomLoginFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode; // FocusNode 추가
  final Function(String)? onFieldSubmitted; // onFieldSubmitted 추가
  final TextInputAction? textInputAction; // TextInputAction 추가

  const CustomLoginFormField({
    required this.onChanged,
    this.obscureText = false,
    this.autofocus = false,
    this.hintText,
    this.errorText,
    this.focusNode, // constructor에 FocusNode 추가
    this.onFieldSubmitted, // constructor에 onFieldSubmitted 추가
    this.textInputAction = TextInputAction.next, // 기본값으로 next 설정
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 테두리가 있는 입력 가능한 보더
    const baseBorder = OutlineInputBorder(
        borderSide: BorderSide(
      color: Colors.black,
      width: 1.3,
    ));

    // 메테리얼에서 가져올수 있는 텍스트 폼 위젯
    return TextFormField(
      // 비밀번호를 입력할때 사용함 true시 동그라미로 가림
      obscureText: obscureText,
      // 해당 화면 갔을때 자동으로 위젯 클릭을 시행할지
      autofocus: autofocus,
      // 값이 바뀔때마다 상태가 변하는거
      onChanged: onChanged,
      cursorColor: Colors.blue.shade400,
      focusNode: focusNode, // TextFormField에 focusNode 설정
      onFieldSubmitted: onFieldSubmitted, // onFieldSubmitted 설정
      textInputAction: textInputAction, // 키보드 액션 설정
      // 텍스트 폼 '안' 에서의 스타일
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade300,
          fontSize: 14.0,
        ),
        // 에러 메세지 관리
        errorText: errorText,
        // 인풋 폼 배경색 관리 filled를 true로 해줘야 보임
        fillColor: Colors.white,
        filled: true,

        // 기본상태의 보더 상태
        border: baseBorder,
        // 선택되지 않은 보더의 상태
        enabledBorder: baseBorder,
        // 선택된 보더 상태 + copyWith은 똑같이 가져오고 일부분을 바꾸겠다 선언
        focusedBorder: baseBorder.copyWith(
          borderSide:
              baseBorder.borderSide.copyWith(color: Colors.blue.shade400),
        ),
      ),
    );
  }
}
