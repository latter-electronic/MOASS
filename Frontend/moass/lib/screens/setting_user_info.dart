import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/services/myinfo_api.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/top_bar.dart';

const List<Widget> roles = <Widget>[
  Text('FE'),
  Text('BE'),
  Text('EM'),
  Text('FULL'),
];

class SettingUserInfoScreen extends StatefulWidget {
  final String teamName;

  const SettingUserInfoScreen({
    super.key,
    required this.teamName,
  });

  @override
  State<SettingUserInfoScreen> createState() => _SettingUserInfoScreenState();
}

class _SettingUserInfoScreenState extends State<SettingUserInfoScreen> {
  @override
  Widget build(BuildContext context) {
    // 팀 명 수정을 위한 변수들
    String basicTeamName = '없음';

    final formKey = GlobalKey<FormState>();

    String textFormFieldValue = widget.teamName;

    // 회원 정보 내의 position index에 맞게 정해줄 것.
    late List<bool> selectedRole = <bool>[false, false, false, false];

    void changeRoleState(int index) {
      setState(() {
        for (int i = 0; i < selectedRole.length; i++) {
          if (index == i) {
            selectedRole[i] = true;
          } else {
            selectedRole[i] = false;
          }
        }
      });
    }

    return Scaffold(
      appBar: const TopBar(
        title: '회원 정보 관리',
        icon: Icons.settings,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CategoryText(text: '팀 이름 설정'),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Text(
                  '팀 이름',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                width: 250,
                height: 50,
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '한 글자 이상 입력해주세요';
                      }
                      return null;
                    },
                    controller: TextEditingController(
                      text: widget.teamName.isNotEmpty
                          ? widget.teamName
                          : basicTeamName,
                    ),
                    obscureText: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) async {
                      setState(() {
                        textFormFieldValue = value!;
                      });
                      MyInfoApi(
                              dio: Dio(), storage: const FlutterSecureStorage())
                          .patchUserTeamName(textFormFieldValue);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const CategoryText(text: '역할 설정'),
          Center(
            child: ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) => {changeRoleState(index)},
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.red[700],
              selectedColor: Colors.white,
              fillColor: Colors.red[200],
              color: Colors.red[400],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 80.0,
              ),
              isSelected: selectedRole,
              children: roles,
            ),
          ),
        ],
      ),
      bottomSheet: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            final formKeyState = formKey.currentState!;
            if (formKeyState.validate()) {
              formKeyState.save();
            }
          },
          child: const Text('수정하기'),
        ),
      ),
    );
  }
}
