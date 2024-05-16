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
  final int? xcoord;
  final int? ycoord;

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

// 우리팀 정보 모델
class MyTeam {
  final String teamCode;
  final String teamName;
  final List<User> users;

  MyTeam({required this.teamCode, required this.teamName, required this.users});

  factory MyTeam.fromJson(Map<String, dynamic> json) {
    var userList = (json['users'] as List)
        .map((userJson) => User.fromJson(userJson))
        .toList();
    return MyTeam(
      teamCode: json['teamCode'],
      teamName: json['teamName'],
      users: userList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teamCode': teamCode,
      'teamName': teamName,
      'users': users.map((user) => user.toJson()).toList(),
    };
  }
}

class User {
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
  final int? ycoord;
  final int? xcoord;

  User({
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
    this.ycoord,
    this.xcoord,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
      ycoord: json['ycoord']?.toDouble(),
      xcoord: json['xcoord']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locationCode': locationCode,
      'locationName': locationName,
      'classCode': classCode,
      'teamCode': teamCode,
      'teamName': teamName,
      'userId': userId,
      'userEmail': userEmail,
      'userName': userName,
      'positionName': positionName,
      'statusId': statusId,
      'profileImg': profileImg,
      'jobCode': jobCode,
      'connectFlag': connectFlag,
      'ycoord': ycoord,
      'xcoord': xcoord,
    };
  }
}

// 지역 조회
class CampusInfo {
  final String locationName;
  final List<dynamic> classes;

  // CampusInfo({required this.locationCode, required this.locationName, required this.classes});

  CampusInfo.fromJson(Map<String, dynamic> json)
      : locationName = json['locationName'],
        classes = json['classes'];
}
