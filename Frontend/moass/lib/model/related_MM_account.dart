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
