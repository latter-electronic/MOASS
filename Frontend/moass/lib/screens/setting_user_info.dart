import 'package:flutter/material.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/top_bar.dart';

class SettingUserInfoScreen extends StatelessWidget {
  const SettingUserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(
        title: '회원 정보 관리',
        icon: Icons.settings,
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryText(text: '팀 이름 설정'),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Text(
                  '팀 이름',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                width: 250,
                height: 50,
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          CategoryText(text: '역할 설정'),
        ],
      ),
      bottomSheet: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('완료'),
        ),
      ),
    );
  }
}
