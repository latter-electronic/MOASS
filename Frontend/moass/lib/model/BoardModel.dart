class BoardModel {
  final int boardId;
  final String boardName;
  final List<MemberImage> memberImages;
  final List<ImageDetail> images;

  BoardModel({
    required this.boardId,
    required this.boardName,
    required this.memberImages,
    required this.images,
  });

  // JSON 데이터를 BoardModel 객체로 변환
  factory BoardModel.fromJson(Map<String, dynamic> json) => BoardModel(
        boardId: json['boardId'] ?? 0, // API 응답에 따라 'boardId' 항목 확인 필요
        boardName: json['boardName'] ?? 'Unknown Board', // 기본값 설정
        memberImages: (json['memberImages'] as List<dynamic>?)
                ?.map((x) => MemberImage.fromJson(x))
                .toList() ??
            [], // 회원 이미지 리스트, API 응답에 따라 조정 필요
        images: List<ImageDetail>.from(
          json['images'].map((x) => ImageDetail.fromJson(x)),
        ),
      );
}

class MemberImage {
  final int userId;
  final String url;

  MemberImage({required this.userId, required this.url});

  // JSON 데이터를 MemberImage 객체로 변환
  factory MemberImage.fromJson(Map<String, dynamic> json) => MemberImage(
        userId: json['userId'],
        url: json['url'],
      );
}

class ImageDetail {
  final int imageId;
  final String url;

  ImageDetail({required this.imageId, required this.url});

  // JSON 데이터를 ImageDetail 객체로 변환
  factory ImageDetail.fromJson(Map<String, dynamic> json) => ImageDetail(
        imageId: json['screenshotId'],
        url: json['screenshotUrl'],
      );
}
