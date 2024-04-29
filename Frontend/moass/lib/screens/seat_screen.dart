import 'package:flutter/material.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/top_bar.dart';
import 'package:moass/widgets/user_box.dart';

class SeatScreen extends StatelessWidget {
  const SeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TopBar(
          title: '좌석',
          icon: Icons.calendar_view_month_rounded,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상태 처리 및 DropdownButton 작업 해야함
              const CategoryText(text: '부울경캠퍼스 10기 2반'),
              Container(
                height: 400,
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.grey),
              ),
              const CategoryText(text: '교육생 조회'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: SearchBar(
                  leading: Icon(Icons.search),
                ),
              ),
              const UserBox(
                  username: '김싸피', team: 'E203', role: 'FE', userstatus: 'here')
            ],
          ),
        ));
  }
}
