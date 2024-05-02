class ToDoList {
  final List data;

  ToDoList({required this.data});

  factory ToDoList.fromJson(Map<String, dynamic> json) {
    return ToDoList(data: json['data']);
  }
}
