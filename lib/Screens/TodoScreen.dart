import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoey/Utilities/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todoey/Utilities/task_model.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {

  String inputTask;
  Task task;
  Box taskBox;
  bool done = false;
  ValueNotifier<List<String>> taskList = ValueNotifier([]);

  void _addTodo(Task inputTodo) {
    taskBox.add(Task(task: inputTodo.task));
  }

  Widget buildCheckBox(Task todo, int index){
    return ValueListenableBuilder(
        valueListenable: taskList,
        builder: (context, List taskName, child){
          print(taskName);
          return ListTile(
            title: Text(todo.task == null ? 'null': todo.task, style: TextStyle(
              color: Colors.white,
              decoration: taskName.contains(todo.task) ? TextDecoration.lineThrough : TextDecoration.none,
            )),
            leading: IconButton(
                onPressed: (){
//                  print(taskList);
                  print(taskName);
                   if (taskName.contains(todo.task)){
                     taskName.remove(todo.task);
                     print('$taskName was removed');
                   }
                  taskName.add(todo.task);
//                   else{
//                     taskName.add(todo.task);
//                     print('added');
//                   }
                },
                icon: FaIcon(taskName.contains(todo.task) ? FontAwesomeIcons.check :FontAwesomeIcons.circle, color: kIndigo,)),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kDarkBg,
        body: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('Todo',
                      style: TextStyle(
                        color: kIndigo,
                        fontSize: 30,
                      ))),
              ValueListenableBuilder(
                  valueListenable: Hive.box('TasksBox').listenable(),
                  builder: (context, Box _todoBox, _) {
                    taskBox = _todoBox;
                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: ListView.builder(
                            itemCount: _todoBox.values.length,
                            itemBuilder: (BuildContext context, int index) {
                              final todo = taskBox.getAt(index);
                              return Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  decoration: BoxDecoration(
                                      color: kIndigo,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  padding: EdgeInsets.only(right: 10),
                                  alignment: Alignment.centerRight,
                                  child: FaIcon(
                                    FontAwesomeIcons.trash,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (direction){
                                  setState(() {
                                    taskBox.deleteAt(index);
                                  });
                                },
                                child: buildCheckBox(todo, index),
                              );
                            }),
                      ),
                    );
                  }
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kIndigo,
          onPressed: () => _simpleDialog(),
          tooltip: 'AddNewTODOTask',
          child: Icon(Icons.add),
        ));
  }

  _simpleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create new task!'),
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter the task',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: kIndigo,
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => inputTask = value,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                            color: kIndigo,
                            onPressed: () {
                              task = Task(task: inputTask);
                              _addTodo(task);
                              Navigator.pop(context);
                            },
                            child: Text('Add'),
                          ),
                          FlatButton(
                            color: kIndigo,
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

