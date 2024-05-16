import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:moass/model/notification_model.dart';
import 'package:moass/services/notification_api.dart';

class NotiWidget extends StatefulWidget {
  final Noti noti;
  const NotiWidget({super.key, required this.noti});

  @override
  State<NotiWidget> createState() => _NotiWidgetState();
}

class _NotiWidgetState extends State<NotiWidget> {
  String? formattedDate = "";

  @override
  void initState() {
    super.initState();
    convertDate();
  }

  String _formatDate(String dateString) {
    DateTime createdAt = DateTime.parse(dateString);

    // 한국 시간대로 변환
    createdAt = createdAt.add(const Duration(hours: 9));
    DateTime now = DateTime.now();

    if (createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day) {
      // 오늘
      return DateFormat.jm().format(createdAt); // 오전 (시간) : (분)
    } else if (createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day - 1) {
      // 어제
      return '어제';
    } else {
      // 그 이전
      return DateFormat('yyyy-MM-dd').format(createdAt);
    }
  }

  convertDate() {
    setState(() {
      formattedDate = _formatDate(widget.noti.createdAt);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        NotiApi(dio: Dio(), storage: const FlutterSecureStorage())
            .deleteNoti(widget.noti.notificationId);
      },
      direction: DismissDirection.horizontal,
      key: ValueKey(widget.noti.notificationId),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF6ECEF5), width: 2.0),
              borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Image.asset(
                        'assets/img/noti_icon.png',
                        width: 30,
                      ),
                    ),
                    Text(
                      widget.noti.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(widget.noti.body)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text(formattedDate!)],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
