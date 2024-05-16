import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/services/gitlab_api.dart';
import 'package:moass/services/jira_api.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SetRelatedAccount extends StatefulWidget {
  final String service;
  final String? userJiraMail;
  final String? userGitlabMail;
  const SetRelatedAccount({
    super.key,
    required this.service,
    this.userJiraMail,
    this.userGitlabMail,
  });

  @override
  State<SetRelatedAccount> createState() => _SetRelatedAccountState();
}

class _SetRelatedAccountState extends State<SetRelatedAccount> {
  bool isOpenedButtonWidget = false;
  late String textformFieldValue;

  openButtonWidget() {
    setState(() {
      isOpenedButtonWidget = !isOpenedButtonWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5)))),
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
                            spreadRadius: 1)
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
                        )),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.service == 'jira')
                      if (widget.userJiraMail == 'null')
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
                      const Text('연결된 계정이 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ))
                    else if (widget.service == 'gitlab')
                      if (widget.userGitlabMail == 'null')
                        const Text(
                          '연결된 계정이 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else if (widget.userGitlabMail != 'null')
                        Text(
                          widget.userGitlabMail ?? '연결된 계정이 없습니다',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    Text(
                      widget.service,
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    )
                  ],
                ),
              ],
            ),
          ),
          if (isOpenedButtonWidget == true)
            if (widget.service == 'jira')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.userJiraMail == 'null')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () async {
                          String JiraConnectUrl = await JiraApi(
                                  dio: Dio(),
                                  storage: const FlutterSecureStorage())
                              .requestConnectJira();
                          await launchUrlString(JiraConnectUrl);
                          setState() {
                            isOpenedButtonWidget = false;
                          }
                          // print('지라 url : $JiraConnectUrl');
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
                          () {};
                        },
                        style: const ButtonStyle(),
                        child: const Text('계정 연동 해제'),
                      ),
                    )
                ],
              )
            else if (widget.service == 'mattermost')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      onPressed: () {
                        () {};
                      },
                      style: const ButtonStyle(),
                      child: const Text('계정 연동'),
                    ),
                  )
                ],
              )
            else if (widget.userGitlabMail != null)
              Column(
                children: [
                  TextField(
                    controller: TextEditingController(),
                    onChanged: (value) {
                      textformFieldValue = value;
                    },
                  ),
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
                              setState() {
                                isOpenedButtonWidget = false;
                              }
                            },
                            style: const ButtonStyle(),
                            child: const Text('프로젝트 등록')),
                      )
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
                          setState() {
                            isOpenedButtonWidget = false;
                          }
                        },
                        style: const ButtonStyle(),
                        child: const Text('계정 연동')),
                  )
                ],
              )
          else
            const Row()
        ],
      ),
    );
  }
}
