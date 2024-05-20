import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/to_do.dart';
import 'package:moass/services/todo_api.dart';
import 'package:moass/widgets/check_box.dart';

class ToDoListWidget extends StatefulWidget {
  const ToDoListWidget({
    super.key,
  });

  @override
  State<ToDoListWidget> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoListWidget> {
  Future<List<ToDo>> toDoList =
      ToDoListApi(dio: Dio(), storage: const FlutterSecureStorage())
          .getUserToDoList();

  final _formKey = GlobalKey<FormState>();

  String _textFormFieldValue = '';

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
    return FutureBuilder(
        future: toDoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var userToDoList = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: const Color(0xFF6ECEF5), width: 2.0)),
                child: Column(
                  children: [
                    userToDoList!.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text('등록된 할 일이 없습니다'),
                          )
                        : Column(
                            children: [
                              for (var todo in userToDoList)
                                if (todo.completedFlag == false)
                                  CheckboxWidget(
                                      text: todo.content,
                                      completedFlag: todo.completedFlag,
                                      todoId: todo.todoId),
                              for (var todo in userToDoList)
                                if (todo.completedFlag == true)
                                  CheckboxWidget(
                                      text: todo.content,
                                      completedFlag: todo.completedFlag,
                                      todoId: todo.todoId),
                            ],
                          ),
                    Container(
                      child: isAddInputAvailable
                          ? SizedBox(
                              height: 40,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '한 글자 이상 입력해주세요';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration.collapsed(
                                        border: UnderlineInputBorder(),
                                        hintText: '오늘 할 일은 뭔가요?'),
                                    textInputAction: TextInputAction.done,
                                    onSaved: (value) async {
                                      setState(() {
                                        _textFormFieldValue = value!;
                                      });
                                      await ToDoListApi(
                                              dio: Dio(),
                                              storage:
                                                  const FlutterSecureStorage())
                                          .postUserToDoList(
                                              _textFormFieldValue);
                                      setState(() {
                                        toDoList = ToDoListApi(
                                                dio: Dio(),
                                                storage:
                                                    const FlutterSecureStorage())
                                            .getUserToDoList();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )
                          : null,
                    ),
                    isAddInputAvailable
                        ? GestureDetector(
                            onTap: () {
                              final formKeyState = _formKey.currentState!;
                              if (formKeyState.validate()) {
                                formKeyState.save();
                              }
                              completeAddToDo();
                            },
                            child: Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xFF3DB887)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF3DB887),
                                    ),
                                    Text(
                                      '할 일 등록하기',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
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
          } else {
            return const Center(child: Text('No data available'));
          }
        });
  }
}
