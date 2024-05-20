class MyProfile {
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
  final String? backgroundImg;
  final int jobCode;
  final int connectFlag;

  MyProfile({
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
    this.backgroundImg,
    required this.jobCode,
    required this.connectFlag,
  });

  factory MyProfile.fromJson(Map<String, dynamic> json) {
    return MyProfile(
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
      backgroundImg: json['backgroundImg'],
      jobCode: json['jobCode'],
      connectFlag: json['connectFlag'],
    );
  }
}
