import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../domain/model/task.dart';
import 'hive/task.dart';

class TaskRepository {
  TaskRepository(this.hiveTaskProvider);

  HiveTaskProvider hiveTaskProvider;

  RxList<Task> tasks = RxList<Task>();

  RxList<Task> doneTasks = RxList<Task>();

  void init() {
    tasks.addAll(hiveTaskProvider.valuesSafe.where((task) => !task.done));
    doneTasks.addAll(hiveTaskProvider.valuesSafe.where((task) => task.done));
  }

  void addTask(String title) {
    Task task = Task(id: const Uuid().v4(), title: title);

    tasks.add(task);
    hiveTaskProvider.put(task);
  }
}
