class ToDo {
  final todoId,
      userId,
      content,
      completedFlag,
      createdAt,
      updatedAt,
      completedAt;

  // ToDo(
  //     {required this.todoId,
  //     required this.userId,
  //     required this.content,
  //     required this.completedFlag,
  //     required this.createdAt,
  //     required this.updatedAt,
  //     required this.completedAt});

  ToDo.fromJson(Map<String, dynamic> json)
      : todoId = json['todoId'],
        userId = json['userId'],
        content = json['content'],
        completedFlag = json['completedFlag'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'],
        completedAt = json['completedAt'];
}
