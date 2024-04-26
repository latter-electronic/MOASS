import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  bool isAddInputAvailable = false;

  void tapAddToDo() {
    setState(() {
      isAddInputAvailable = true;
    });
  }

  void completeAddToDo() {
    setState(() {
      isAddInputAvailable = false;
    });
  }

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
            Container(
              child: isAddInputAvailable
                  ? SizedBox(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: TextFormField(
                          decoration: const InputDecoration.collapsed(
                              border: UnderlineInputBorder(),
                              hintText: '오늘 할 일은 뭔가요?'),
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    )
                  : null,
            ),
            isAddInputAvailable
                ? GestureDetector(
                    onTap: completeAddToDo,
                    child: Container(
                      decoration: const BoxDecoration(color: Color(0xFF3DB887)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Color(0xFF3DB887),
                            ),
                            Text('완료!'),
                          ],
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: tapAddToDo,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_box_outlined),
                          Text('할 일 추가'),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
