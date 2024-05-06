class UserInfo {
  final String locationCode;
  final String locationName;
  final String classCode;
  final String teamCode;
  final String teamName;
  final String userId;
  final String userEmail;
  final String userName;
  final String? positionName;
  final int statusId;
  final String? profileImg;
  final int jobCode;
  final int connectFlag;
  final String? xcoord;
  final String? ycoord;

  UserInfo({
    required this.locationCode,
    required this.locationName,
    required this.classCode,
    required this.teamCode,
    required this.teamName,
    required this.userId,
    required this.userEmail,
    required this.userName,
    this.positionName,
    required this.statusId,
    this.profileImg,
    required this.jobCode,
    required this.connectFlag,
    this.xcoord,
    this.ycoord,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      locationCode: json['locationCode'],
      locationName: json['locationName'],
      classCode: json['classCode'],
      teamCode: json['teamCode'],
      teamName: json['teamName'],
      userId: json['userId'],
      userEmail: json['userEmail'],
      userName: json['userName'],
      positionName: json['positionName'],
      statusId: json['statusId'],
      profileImg: json['profileImg'],
      jobCode: json['jobCode'],
      connectFlag: json['connectFlag'],
      xcoord: json['xcoord'],
      ycoord: json['ycoord'],
    );
  }
}
