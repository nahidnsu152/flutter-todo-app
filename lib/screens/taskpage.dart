import 'package:flutter/material.dart';
import '../widgets/todo.dart';
import '../database/database_helper.dart';
import '../models/task.dart';
import '../models/todoTask.dart';

class Taskpage extends StatefulWidget {
  final Task? task;
  const Taskpage({Key? key, this.task}) : super(key: key);

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  String _taskTitle = "";
  String _taskDescription = "";
  int _taskId = 0;

  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    if (widget.task != null) {
      _contentVisible = true;
      _taskTitle = widget.task!.title;
      _taskDescription = widget.task!.description;
      _taskId = widget.task!.id!;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24,
                      bottom: 6,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Image(
                                image: AssetImage(
                                    "assets/images/back_arrow_icon.png")),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async {
                              if (value != "") {
                                if (widget.task == null) {
                                  DatabaseHelper _dbHelper = DatabaseHelper();
                                  Task _newTask = Task(
                                    title: value,
                                    description: _taskDescription,
                                  );
                                  _taskId =
                                      await _dbHelper.insertTask(_newTask);
                                  setState(() {
                                    _contentVisible = true;
                                    _taskTitle = value;
                                  });
                                  print("New Task Created, id: $_taskId");
                                } else {
                                  await _dbHelper.updateTitle(_taskId, value);
                                  print("Updated!");
                                }
                                _descriptionFocus.requestFocus();
                              }
                            },
                            controller: TextEditingController()
                              ..text = _taskTitle,
                            decoration: InputDecoration(
                              hintText: "Enter the title",
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF211511),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async {
                          if (value != "") {
                            if (_taskId != 0) {
                              await _dbHelper.updateDescription(_taskId, value);
                              _taskDescription = value;
                            }
                          }
                          _todoFocus.requestFocus();
                        },
                        controller: TextEditingController()
                          ..text = _taskDescription,
                        decoration: InputDecoration(
                            hintText: "Enter Description for the task",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24,
                            )),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                      future: _dbHelper.getTodoTasks(_taskId),
                      builder: (context, AsyncSnapshot snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  if (snapshot.data[index].isDone == 0) {
                                    await _dbHelper.updateTodoIsDone(
                                        snapshot.data[index].id, 1);
                                  } else {
                                    await _dbHelper.updateTodoIsDone(
                                        snapshot.data[index].id, 1);
                                  }
                                  setState(() {});
                                },
                                child: Todo(
                                  text: snapshot.data[index].title,
                                  isDone: snapshot.data[index].isDone == 0
                                      ? false
                                      : true,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 16),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Color(0xFF86829D),
                                width: 1.5,
                              ),
                            ),
                            child: Image(
                              image: AssetImage("assets/images/check_icon.png"),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController()..text = "",
                              focusNode: _todoFocus,
                              onSubmitted: (value) async {
                                if (value != "") {
                                  if (_taskId != 0) {
                                    TodoTask _newTodoTask = TodoTask(
                                      taskId: _taskId,
                                      title: value,
                                      isDone: 0,
                                    );
                                    await _dbHelper
                                        .insertTodoTask(_newTodoTask);
                                    print("New todo item created");
                                    setState(() {});
                                    _todoFocus.requestFocus();
                                  } else {
                                    print("New todo unable to create");
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Enter ToDo Item",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 24,
                  right: 24,
                  child: GestureDetector(
                    onTap: () async {
                      if (_taskId != 0) {
                        await _dbHelper.deleteTask(_taskId);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFFFE3577),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image(
                        image: AssetImage("assets/images/delete_icon.png"),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
