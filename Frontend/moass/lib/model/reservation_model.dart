// 내 예약정보 데이터 모델----------------------------------------------------------------------------------------
// 예약정보의 유저 정보 DTO정의
class UserSearchInfoDto {
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
  final double? ycoord;
  final double? xcoord;

  UserSearchInfoDto({
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

  factory UserSearchInfoDto.fromJson(Map<String, dynamic> json) {
    return UserSearchInfoDto(
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
}

// 내 예약 정보 모델
class MyReservationModel {
  final int infoId;
  final int reservationId;
  final String reservationName;
  final String colorCode;
  final String userId;
  final int infoState;
  final String infoName;
  final String infoDate;
  final int infoTime;
  final List<UserSearchInfoDto> userSearchInfoDtoList;

  MyReservationModel({
    required this.infoId,
    required this.reservationId,
    required this.reservationName,
    required this.colorCode,
    required this.userId,
    required this.infoState,
    required this.infoName,
    required this.infoDate,
    required this.infoTime,
    required this.userSearchInfoDtoList,
  });

  factory MyReservationModel.fromJson(Map<String, dynamic> json) {
    return MyReservationModel(
      infoId: json['infoId'],
      reservationId: json['reservationId'],
      reservationName: json['reservationName'],
      colorCode: json['colorCode'],
      userId: json['userId'],
      infoState: json['infoState'],
      infoName: json['infoName'],
      infoDate: json['infoDate'],
      infoTime: json['infoTime'],
      userSearchInfoDtoList: (json['userSearchInfoDtoList'] as List)
          .map((i) => UserSearchInfoDto.fromJson(i))
          .toList(),
    );
  }
}

// 특정 날짜 예약 조회 데이터 모델 ------------------------------------------------------------------------------------------------------------------------

class ReservationInfoListDto {
  final String createdAt;
  final String updatedAt;
  final int infoId;
  final int reservationId;
  final String userId;
  final int infoState;
  final String infoName;
  final String infoDate;
  final int infoTime;

  ReservationInfoListDto({
    required this.createdAt,
    required this.updatedAt,
    required this.infoId,
    required this.reservationId,
    required this.userId,
    required this.infoState,
    required this.infoName,
    required this.infoDate,
    required this.infoTime,
  });

  factory ReservationInfoListDto.fromJson(Map<String, dynamic> json) {
    return ReservationInfoListDto(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      infoId: json['infoId'],
      reservationId: json['reservationId'],
      userId: json['userId'],
      infoState: json['infoState'],
      infoName: json['infoName'],
      infoDate: json['infoDate'],
      infoTime: json['infoTime'],
    );
  }
  @override
  String toString() {
    return 'ReservationInfoListDto(infoId: $infoId, reservationId: $reservationId, userId: $userId, infoState: $infoState, infoName: $infoName, infoDate: $infoDate, infoTime: $infoTime)';
  }
}

class ReservationDayModel {
  final int reservationId;
  final String classCode;
  final String category;
  final int timeLimit;
  final String reservationName;
  final String colorCode;
  final List<ReservationInfoListDto> reservationInfoList;

  ReservationDayModel({
    required this.reservationId,
    required this.classCode,
    required this.category,
    required this.timeLimit,
    required this.reservationName,
    required this.colorCode,
    required this.reservationInfoList,
  });

// print출력을 위한 코드
  @override
  String toString() {
    return 'ReservationDayModel(reservationId: $reservationId, classCode: $classCode, category: $category, timeLimit: $timeLimit, reservationName: $reservationName, colorCode: $colorCode, reservationInfoList: ${reservationInfoList.map((i) => i.toString()).join(', ')})';
  }

  factory ReservationDayModel.fromJson(Map<String, dynamic> json) {
    return ReservationDayModel(
      reservationId: json['reservationId'] ?? 0,
      classCode: json['classCode'] ?? '',
      category: json['category'] ?? '',
      timeLimit: json['timeLimit'] ?? 0,
      reservationName: json['reservationName'] ?? '',
      colorCode: json['colorCode'] ?? '',
      reservationInfoList: json['reservationInfoList'] != null
          ? (json['reservationInfoList'] as List)
              .map((i) => ReservationInfoListDto.fromJson(i))
              .toList()
          : [],
    );
  }
}
