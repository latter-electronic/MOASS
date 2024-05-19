import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/services/gitlab_api.dart';
import 'package:moass/services/jira_api.dart';
import 'package:moass/services/mattermost_api.dart';
import 'package:moass/widgets/custom_login_form.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:moass/screens/setting_mm_subscript_screen.dart';

class SetRelatedAccount extends StatefulWidget {
  final String service;
  final String? userJiraMail;
  final String? userGitlabMail;
  final List? userGitlabProject;
  final String? userMattermostMail;

  const SetRelatedAccount({
    super.key,
    required this.service,
    this.userJiraMail,
    this.userGitlabMail,
    this.userGitlabProject,
    this.userMattermostMail,
  });

  @override
  State<SetRelatedAccount> createState() => _SetRelatedAccountState();
}

class _SetRelatedAccountState extends State<SetRelatedAccount> {
  bool isOpenedButtonWidget = false;
  late String textformFieldValue;
  String mmUserId = '';
  String mmPassword = '';

  void openButtonWidget() {
    setState(() {
      isOpenedButtonWidget = !isOpenedButtonWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5))),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              openButtonWidget();
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(1, 1),
                          blurRadius: 1,
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: widget.service == 'mattermost'
                          ? const Color(0xFF28427b)
                          : Colors.white,
                      child: Image.asset(
                        'assets/img/logo_${widget.service}.png',
                        width: 35,
                        height: 35,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.service == 'jira')
                      if (widget.userJiraMail == null)
                        const Text(
                          '연결된 계정이 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else
                        Text(
                          widget.userJiraMail!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                    else if (widget.service == 'mattermost')
                      if (widget.userMattermostMail == null)
                        const Text(
                          '연결된 계정이 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userMattermostMail!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // 여기에 서버 설정버튼 추가해보기
                            // 채널 구독 이동버튼
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blue,
                                backgroundColor: Colors.white,
                                elevation: 10.0,
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 1, vertical: 1),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingMMSubscriptScreen(),
                                  ),
                                );
                              },
                              child: const Text('알림 채널 설정'),
                            ),
                          ],
                        )
                    else if (widget.userGitlabMail == null)
                      const Text(
                        '연결된 계정이 없습니다',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    else
                      Text(
                        widget.userGitlabMail!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    Text(
                      widget.service,
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                    if (widget.userGitlabProject != null)
                      if (widget.userGitlabProject!.isNotEmpty)
                        Row(
                          children: [
                            for (var project in widget.userGitlabProject!)
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF66A26),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  project.gitlabProjectName.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                          ],
                        ),
                  ],
                ),
              ],
            ),
          ),
          if (isOpenedButtonWidget)
            if (widget.service == 'jira')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.userJiraMail == null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () async {
                          String JiraConnectUrl = await JiraApi(
                                  dio: Dio(),
                                  storage: const FlutterSecureStorage())
                              .requestConnectJira();
                          await launchUrlString(JiraConnectUrl);
                          setState(() {
                            isOpenedButtonWidget = false;
                          });
                        },
                        style: const ButtonStyle(),
                        child: const Text('계정 연동'),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          // 계정 연동 해제 로직 추가
                        },
                        style: const ButtonStyle(),
                        child: const Text('계정 연동 해제'),
                      ),
                    ),
                ],
              )
            else if (widget.service == 'mattermost')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.userMattermostMail == null)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'MatterMost ID',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            CustomLoginFormField(
                              hintText: 'MatterMost 계정',
                              onChanged: (String value) {
                                mmUserId = value;
                              },
                            ),
                            const SizedBox(height: 4.0),
                            const Text(
                              'MatterMost PW',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            CustomLoginFormField(
                              hintText: 'MatterMost Password',
                              onChanged: (String value) {
                                mmPassword = value;
                              },
                              obscureText: true,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OutlinedButton(
                                  onPressed: () async {
                                    var response = await MatterMostApi(
                                            dio: Dio(),
                                            storage:
                                                const FlutterSecureStorage())
                                        .connectMMAcount(mmUserId, mmPassword);
                                    if (response == 200) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        backgroundColor: Color(0xFF3DB887),
                                        content: Text('MatterMost 계정 연결 성공!'),
                                        duration: Duration(seconds: 3),
                                      ));
                                      setState(() {
                                        isOpenedButtonWidget = false;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor:
                                            const Color(0xFFD24B4E),
                                        content: Text(
                                            'MatterMost 계정 연동에 실패했습니다. 에러 : ${response.toString()}'),
                                        duration: const Duration(seconds: 1),
                                      ));
                                    }
                                  },
                                  style: const ButtonStyle(),
                                  child: const Text('계정 연동'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          // 계정 연동 해제 로직 추가
                        },
                        style: const ButtonStyle(),
                        child: const Text('계정 연동 해제'),
                      ),
                    ),
                ],
              )
            else if (widget.userGitlabMail != null)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        label: Text(
                          '등록할 레포지토리 이름을 입력하세요',
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                      controller: TextEditingController(),
                      onChanged: (value) {
                        textformFieldValue = value;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () async {
                            int statusCode = await GitlabApi(
                                    dio: Dio(),
                                    storage: const FlutterSecureStorage())
                                .requestSubmitProject(textformFieldValue);
                            if (statusCode == 200) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                backgroundColor: Color(0xFF3DB887),
                                content: Text('프로젝트 등록 성공!'),
                                duration: Duration(seconds: 3),
                              ));
                            }
                            setState(() {
                              isOpenedButtonWidget = false;
                            });
                          },
                          style: const ButtonStyle(),
                          child: const Text('프로젝트 등록'),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      onPressed: () async {
                        String gitlabConnectUrl = await GitlabApi(
                                dio: Dio(),
                                storage: const FlutterSecureStorage())
                            .requestConnectGitlab();
                        await launchUrlString(gitlabConnectUrl);
                        setState(() {
                          isOpenedButtonWidget = false;
                        });
                      },
                      style: const ButtonStyle(),
                      child: const Text('계정 연동'),
                    ),
                  )
                ],
              )
          else
            const Row(),
        ],
      ),
    );
  }
}
