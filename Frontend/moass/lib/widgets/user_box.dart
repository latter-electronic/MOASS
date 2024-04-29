import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserBox extends StatelessWidget {
  // 유저 객체로 수정해줄 것
  final String username, team, role, userstatus;
  const UserBox({
    super.key,
    required this.username,
    required this.team,
    required this.role,
    required this.userstatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              offset: const Offset(0, 2),
              color: Colors.black.withOpacity(0.5),
            )
          ]),
      clipBehavior: Clip.hardEdge,
      width: 350,
      height: 50,
      child: Row(
        children: [
          Container(
              width: 100,
              height: 50,
              decoration: const BoxDecoration(color: Color(0xFFD70000)),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      team,
                      style: const TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ],
                ),
              )),
          Container(
            width: 250,
            height: 50,
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          width: 40,
                          height: 20,
                          decoration: const BoxDecoration(
                              color: Color(0xffD93030),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: const Center(
                              child: Text(
                            'FE',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          )),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: userstatus == 'here'
                            ? const Color(0xFF3DB887)
                            : userstatus == 'nothere'
                                ? const Color(0xFFFFBC1F)
                                : Colors.grey),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
