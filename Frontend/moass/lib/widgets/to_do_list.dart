import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moass/widgets/check_box.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({
    super.key,
  });

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List<String> todoList = <String>['현욱이 괴롭히기', '끝장나게 잠 자기'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF6ECEF5), width: 2.0)),
        child: Column(
          children: [
            for (var todo in todoList) CheckboxWidget(text: todo),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_box_outlined),
                  Text('할 일 추가'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
