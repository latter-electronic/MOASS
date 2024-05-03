// 모음보드 모델 임시

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

  factory BoardModel.fromJson(Map<String, dynamic> json) => BoardModel(
        boardId: json['boardId'],
        boardName: json['boardName'],
        memberImages: List<MemberImage>.from(
          json['memberimg'].map((x) => MemberImage.fromJson(x)),
        ),
        images: List<ImageDetail>.from(
          json['images'].map((x) => ImageDetail.fromJson(x)),
        ),
      );
}

class MemberImage {
  final int userId;
  final String url;

  MemberImage({required this.userId, required this.url});

  factory MemberImage.fromJson(Map<String, dynamic> json) => MemberImage(
        userId: json['userId'],
        url: json['url'],
      );
}

class ImageDetail {
  final int imageId;
  final String url;

  ImageDetail({required this.imageId, required this.url});

  factory ImageDetail.fromJson(Map<String, dynamic> json) => ImageDetail(
        imageId: json['imageId'],
        url: json['url'],
      );
}
