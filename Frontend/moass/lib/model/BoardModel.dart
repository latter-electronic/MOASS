// 보드 방 리스트 모델
class BoardModel {
  final int boardUserId;
  final int boardId;
  final String? boardName; // nullable 변경
  final String boardUrl;
  final bool? isActive; // nullable 변경
  final DateTime? completedAt;

  BoardModel({
    required this.boardUserId,
    required this.boardId,
    this.boardName,
    required this.boardUrl,
    this.isActive,
    this.completedAt,
  });

  factory BoardModel.fromJson(Map<String, dynamic> json) {
    return BoardModel(
      boardUserId: json['boardUserId'],
      boardId: json['boardId'],
      boardName: json['boardName'],
      boardUrl: json['boardUrl'],
      isActive: json['isActive'],
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'boardUserId': boardUserId,
      'boardId': boardId,
      'boardName': boardName,
      'boardUrl': boardUrl,
      'isActive': isActive,
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}

// 보드 스크린샷 리스트 모델
class ScreenshotModel {
  final int screenshotId;
  final String screenshotUrl;

  ScreenshotModel({
    required this.screenshotId,
    required this.screenshotUrl,
  });

  factory ScreenshotModel.fromJson(Map<String, dynamic> json) {
    return ScreenshotModel(
      screenshotId: json['screenshotId'],
      screenshotUrl: json['screenshotUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'screenshotId': screenshotId,
      'screenshotUrl': screenshotUrl,
    };
  }
}


// // 보드 스크린샷 상세 모델
// class ScreenshotDetailModel {
//   final int screenshotId;
//   final String screenshotUrl;

//   ScreenshotModel({
//     required this.screenshotId,
//     required this.screenshotUrl,
//   });

//   factory ScreenshotModel.fromJson(Map<String, dynamic> json) {
//     return ScreenshotModel(
//       screenshotId: json['screenshotId'],
//       screenshotUrl: json['screenshotUrl'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'screenshotId': screenshotId,
//       'screenshotUrl': screenshotUrl,
//     };
//   }
// }
