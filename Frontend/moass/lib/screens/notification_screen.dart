import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/services/notification_api.dart';
import 'package:moass/widgets/noti_widget.dart';
import 'package:moass/widgets/top_bar.dart';
import 'package:moass/model/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotiApi api;
  List<Noti>? notiLists = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    api = NotiApi(dio: Dio(), storage: const FlutterSecureStorage());
    getNotiList();
    // print('알림 리스트 : $notiLists');
  }

  Future<void> getNotiList() async {
    var result = await api.fetchNotification();
    setState(() {
      notiLists = result;
      print('알림 리스트 : $notiLists');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TopBar(
          title: '알림',
          icon: Icons.notifications,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (notiLists!.isNotEmpty)
                for (var noti in notiLists!) const NotiWidget()
              else
                const Center(child: Text('읽지 않은 알림이 없습니다'))
            ],
          ),
        ));
  }
}
