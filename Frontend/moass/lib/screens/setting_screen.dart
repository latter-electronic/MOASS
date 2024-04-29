import 'package:flutter/material.dart';
import 'package:moass/screens/setting_related_account.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/top_bar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(
        title: '설정',
        icon: Icons.settings,
      ),
      body: Column(
        children: [
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.5)))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CategoryText(text: '연결 기기 관리'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: <Widget>[
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: 30,
                              height: 20,
                              decoration:
                                  const BoxDecoration(color: Colors.blue),
                            ),
                            const Text('n번 기기'),
                          ]),
                          TextButton(
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('기기 연결 해제'),
                                content: SizedBox(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/img/crying_mozzi.png',
                                        height: 200,
                                      ),
                                      const Text('정말로 기기와의 연결을 해제하시겠어요?'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, '취소'),
                                    child: const Text('취소'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, '확인'),
                                    child: const Text('확인'),
                                  ),
                                ],
                              ),
                            ),
                            child: const Text(
                              '연결 해제',
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.5)))),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: CategoryText(text: '명패 설정'),
              )),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.5)))),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: CategoryText(text: '위젯 사진 설정'),
              )),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.5)))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // fullscreenDialog: true,
                          builder: (context) =>
                              const SettingRelatedAccountScreen(),
                        ),
                      );
                    },
                    child: const CategoryText(text: '연동 계정 관리')),
              )),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.5)))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: GestureDetector(
                    onTap: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('기기 연결 해제'),
                            content: SizedBox(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/img/crying_mozzi.png',
                                    height: 200,
                                  ),
                                  const Text('앱에서 로그아웃 하시겠어요?'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, '취소'),
                                child: const Text('취소'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, '확인'),
                                child: const Text('확인'),
                              ),
                            ],
                          ),
                        ),
                    child: const CategoryText(text: '로그아웃')),
              )),
        ],
      ),
    );
  }
}
