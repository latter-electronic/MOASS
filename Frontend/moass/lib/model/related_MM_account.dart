class MattermostTeam {
  final String mmTeamName;
  final String mmTeamId;
  final String mmTeamIcon;
  final List<MattermostChannel> mmChannelList;

  MattermostTeam({
    required this.mmTeamName,
    required this.mmTeamId,
    required this.mmTeamIcon,
    required this.mmChannelList,
  });

  factory MattermostTeam.fromJson(Map<String, dynamic> json) {
    List<dynamic> channelList = json['mmChannelList'];
    List<MattermostChannel> channels = channelList
        .map((channel) => MattermostChannel.fromJson(channel))
        .toList();
    return MattermostTeam(
      mmTeamName: json['mmTeamName'],
      mmTeamId: json['mmTeamId'],
      mmTeamIcon: json['mmTeamIcon'],
      mmChannelList: channels,
    );
  }
}

class MattermostChannel {
  final String mmChannelId;
  final String channelName;
  final String mmTeamId;
  final bool isSubscribed;

  MattermostChannel({
    required this.mmChannelId,
    required this.channelName,
    required this.mmTeamId,
    required this.isSubscribed,
  });

  factory MattermostChannel.fromJson(Map<String, dynamic> json) {
    return MattermostChannel(
      mmChannelId: json['mmChannelId'],
      channelName: json['channelName'],
      mmTeamId: json['mmTeamId'],
      isSubscribed: json['isSubscribed'],
    );
  }
}

// MM 연동상태확인 요청
class MattermostConnectionStatus {
  final MattermostConnectionData? data;
  final String message;
  final String timestamp;
  final int status;

  MattermostConnectionStatus({
    required this.data,
    required this.message,
    required this.timestamp,
    required this.status,
  });

  factory MattermostConnectionStatus.fromJson(Map<String, dynamic> json) {
    return MattermostConnectionStatus(
      data: json['data'] != null
          ? MattermostConnectionData.fromJson(json['data'])
          : null,
      message: json['message'],
      timestamp: json['timestamp'],
      status: json['status'],
    );
  }
}

class MattermostConnectionData {
  final String createdAt;
  final String updatedAt;
  final int mmTokenId;
  final String sessionToken;
  final String userId;

  MattermostConnectionData({
    required this.createdAt,
    required this.updatedAt,
    required this.mmTokenId,
    required this.sessionToken,
    required this.userId,
  });

  factory MattermostConnectionData.fromJson(Map<String, dynamic> json) {
    return MattermostConnectionData(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      mmTokenId: json['mmTokenId'],
      sessionToken: json['sessionToken'],
      userId: json['userId'],
    );
  }
}
