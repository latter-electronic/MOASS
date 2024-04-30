import 'package:flutter/material.dart';

class SetRelatedAccount extends StatelessWidget {
  const SetRelatedAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5)))),
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
                  backgroundColor: Colors.white,
                  child: Image.asset('assets/img/logo_jira.png')),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '연결된 계정이 없습니다',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Jira',
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              )
            ],
          ),
        ],
      ),
    );
  }
}
