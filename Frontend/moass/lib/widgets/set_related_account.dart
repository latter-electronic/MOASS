import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SetRelatedAccount extends StatefulWidget {
  final String service;
  const SetRelatedAccount({super.key, required this.service});

  @override
  State<SetRelatedAccount> createState() => _SetRelatedAccountState();
}

class _SetRelatedAccountState extends State<SetRelatedAccount> {
  bool isOpenedButtonWidget = false;

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
                    widget.service == 'gitlab'
                        ? const Text(
                            '연결된 hook URL이 없습니다',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : const Text(
                            '연결된 계정이 없습니다',
                            style: TextStyle(
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
          isOpenedButtonWidget
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {},
                        style: const ButtonStyle(),
                        child: widget.service == 'gitlab'
                            ? const Text('URL 등록')
                            : const Text('계정 연동'),
                      ),
                    )
                  ],
                )
              : const Row()
        ],
      ),
    );
  }
}
