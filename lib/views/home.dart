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
                  return ListTile(
                    title: Text(tasks[index].taskName!),
                    subtitle: Text(tasks[index].isDone.toString()),
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
