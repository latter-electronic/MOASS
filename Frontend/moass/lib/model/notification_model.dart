class Noti {
  final notificationId,
      userId,
      source,
      icon,
      title,
      body,
      sender,
      redirectUrl,
      deletedAt,
      createdAt;

  Noti.fromJson(Map<String, dynamic> json)
      : notificationId = json['notificationId'],
        userId = json['userId'],
        source = json['source'],
        icon = json['icon'],
        title = json['title'],
        body = json['body'],
        sender = json['sender'],
        redirectUrl = json['redirectUrl'],
        deletedAt = json['deletedAt'],
        createdAt = json['createdAt'];
}
