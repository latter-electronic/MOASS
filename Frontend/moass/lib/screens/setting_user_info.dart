import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

const List rolesString = ['FE', 'BE', 'EM', 'FULL'];

class SettingUserInfoScreen extends StatefulWidget {
  final String teamName;
  final dynamic positionName;

  const SettingUserInfoScreen({
    super.key,
    required this.teamName,
    required this.positionName,
  });

  @override
  _SettingUserInfoScreenState createState() => _SettingUserInfoScreenState();
}

class _SettingUserInfoScreenState extends State<SettingUserInfoScreen> {
  late List<bool> selectedRole = <bool>[false, false, false, false];

  late String textFormFieldValue;
  late String? currentRole;

  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 초기 팀 이름 설정
    myController.text = widget.teamName;

    // 초기 역할 설정
    if (widget.positionName != null) {
      for (int i = 0; i < rolesString.length; i++) {
        if (widget.positionName == rolesString[i]) {
          setState(() {
            selectedRole[i] = true;
            currentRole = rolesString[i];
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

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
                    controller: myController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      textFormFieldValue = value;
                    },
                    onSaved: (value) {
                      textFormFieldValue = value!;
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
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < selectedRole.length; i++) {
                    selectedRole[i] = i == index;
                    if (i == index) {
                      currentRole = rolesString[i];
                    }
                  }
                });
              },
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
              MyInfoApi(dio: Dio(), storage: const FlutterSecureStorage())
                  .patchUserTeamName(textFormFieldValue, currentRole);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('수정 완료'),
                    content: const Text('회원 정보가 성공적으로 수정되었습니다.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('확인'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: const Text('수정하기'),
        ),
      ),
    );
  }
}
