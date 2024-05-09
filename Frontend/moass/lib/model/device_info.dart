import 'package:moass/model/user_info.dart';

class DeviceInfo {
  final String deviceId;
  final String? userId;
  final int? xcoord;
  final int? ycoord;
  final String classCode;
  final UserInfo? userSearchDetail;

  DeviceInfo({
    required this.deviceId,
    required this.classCode,
    required this.userId,
    required this.xcoord,
    required this.ycoord,
    required this.userSearchDetail,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      deviceId: json['deviceId'],
      classCode: json['classCode'],
      userId: json['userId'],
      xcoord: json['xcoord'],
      ycoord: json['ycoord'],
      userSearchDetail: json['userSearchDetail'] != null
          ? UserInfo.fromJson(json['userSearchDetail'])
          : null,
    );
  }
}
