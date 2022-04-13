import 'package:flutter/material.dart';
import 'package:flutter_sqflite/models/task.dart';

import '../services/db_helper.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController =
      TextEditingController(text: 'Task');
  TextEditingController textEditingControllerIsDone =
      TextEditingController(text: '0');
  TextEditingController textEditingControllerUpdate =
      TextEditingController(text: 'Task');
  TextEditingController textEditingControllerIsDoneUpdate =
      TextEditingController(text: '0');
  List<Task> tasks = [];

  getAllTaskData() async {
    tasks = await DBHelper.dbHelper.getAllTasks();
    setState(() {});
  }

  addTask() {
    Task task = Task(
        taskName: textEditingController.text,
        isDone: int.parse(textEditingControllerIsDone.text));
    DBHelper.dbHelper.addTask(task);
    getAllTaskData();
  }

  deleteTask(int? id) {
    DBHelper.dbHelper.deleteTask(id);
    getAllTaskData();
  }

  updateTask(Task task) {
    DBHelper.dbHelper.updateTask(task);
    getAllTaskData();
  }

  showAlertDialog(BuildContext context, int? id) {


    
    // set up the button
    Widget updateButton = TextButton(
      child: Text("update"),
      onPressed: () {
        Task task = Task(
            id: id,
            taskName: textEditingControllerUpdate.text,
            isDone: int.parse(textEditingControllerIsDoneUpdate.text));
         DBHelper.dbHelper.updateTask(task);
         getAllTaskData();

        Navigator.pop(context);
      },
    );
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Update Task"),
      content: Container(
        height: 200,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(label: Text("Task name")),
                controller: textEditingControllerUpdate,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(label: Text("isDone 0:1")),
                controller: textEditingControllerIsDoneUpdate,
              ),
            ),
          ],
        ),
      ),
      actions: [updateButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllTaskData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (() => showAlertDialog(context, tasks[index].id)),
                    child: ListTile(
                      trailing: IconButton(
                          onPressed: () {
                            deleteTask(tasks[index].id);
                          },
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          )),
                      title: Text(tasks[index].taskName!),
                      subtitle: Text(tasks[index].isDone.toString()),
                    ),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              decoration: InputDecoration(label: Text("Task name")),
              controller: textEditingController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              decoration: InputDecoration(label: Text("isDone 0:1")),
              controller: textEditingControllerIsDone,
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      addTask();
                    },
                    child: Text('insert task')),
                ElevatedButton(
                    onPressed: () async {
                      getAllTaskData();
                    },
                    child: Text('get all task')),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
