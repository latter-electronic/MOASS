import 'package:flutter/material.dart';
import 'package:moass/widgets/top_bar.dart';
import 'package:moass/services/myinfo_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/myprofile.dart'; // MyProfile 모델 import 확인

class ReservationScreen extends StatelessWidget {
  const ReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // MyInfoApi 인스턴스를 생성할 때 Dio()와 FlutterSecureStorage()를 전달합니다.
    final myInfoApi =
        MyInfoApi(dio: Dio(), storage: const FlutterSecureStorage());

    return Scaffold(
      appBar: const TopBar(title: '유저 예약', icon: Icons.edit_calendar_outlined),
      body: FutureBuilder<MyProfile?>(
        future: myInfoApi.fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var userProfile = snapshot.data;
            return ListTile(
              title: Text(
                  'Name: ${userProfile?.userName}'), // userName을 MyProfile에서 가져옵니다.
              subtitle: Text(
                  'Email: ${userProfile?.userEmail}, \n 전체: $userProfile'), // userEmail을 MyProfile에서 가져옵니다.
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
