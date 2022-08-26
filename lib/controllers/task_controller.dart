import 'package:get/get.dart';
import 'package:todoapp/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController {
  RxList listTask = [].obs;
  void getTasks() {}

  Future<int?> addTask({required Task task}) {
    return DBHelper().insertTask(task);
  }

  Future<void> setTaskInList() async {
    List<Map<String, dynamic>>? AllTask = await DBHelper().selectAllTask();
    AllTask?.forEach((task) {
      listTask.assignAll(AllTask.map((data) {
        print('>>>>>>>>>>${data.toString()}');
        return Task.fromJson(data);
      }).toList());
    });
  }

  void deleteTask({required Task task}) async {
    await DBHelper().deleteTask(task);
  }

  void deleteAllTask() async {
    await DBHelper().deleteAllTask();
  }

  void updateTask({required Task task}) async {
    await DBHelper().updateRowTask(task);
  }
}


/*
Task(
        //id: 1,
        title: 'Test Task 1',
        color: 0,
        date: DateTime.now().toString(),
        endTime: '08:55',
        startTime: '12:38',
        isCompleted: 1,
        note: 'Write code that calculate two number',
        remind: 0,
        repeat: 'none'),
        */