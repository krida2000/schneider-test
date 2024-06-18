import 'package:get/get.dart';
import 'package:schneider_test/utils/obs_list.dart';
import 'package:uuid/uuid.dart';

import '/domain/model/task.dart';
import 'hive/task.dart';

class TaskRepository {
  TaskRepository(this.hiveTaskProvider);

  HiveTaskProvider hiveTaskProvider;

  ObsList<Rx<Task>> tasks = ObsList<Rx<Task>>();

  ObsList<Rx<Task>> doneTasks = ObsList<Rx<Task>>();

  void init() {
    tasks.addAll(
      hiveTaskProvider.valuesSafe.where((task) => !task.done).map((e) => Rx(e)),
    );
    doneTasks.addAll(
      hiveTaskProvider.valuesSafe.where((task) => task.done).map((e) => Rx(e)),
    );
  }

  void add(String title) {
    Task task = Task(id: TaskId(const Uuid().v4()), title: title);

    tasks.add(Rx(task));
    hiveTaskProvider.put(task);
  }

  void remove(TaskId id) {
    tasks.removeWhere((task) => task.value.id == id);
    doneTasks.removeWhere((task) => task.value.id == id);
    hiveTaskProvider.delete(id);
  }

  void update(TaskId id, String title) {
    Rx<Task> task = tasks.firstWhere((task) => task.value.id == id);
    task.value.title = title;
    task.refresh();

    hiveTaskProvider.put(task.value);
  }

  void updateDone(TaskId id, bool done) {
    Rx<Task> task;
    if (done) {
      task = tasks.firstWhere((task) => task.value.id == id);
      task.value.done = done;
      tasks.remove(task);
      doneTasks.add(task);
    } else {
      task = doneTasks.firstWhere((task) => task.value.id == id);
      task.value.done = done;
      doneTasks.remove(task);
      tasks.add(task);
    }

    hiveTaskProvider.put(task.value);
  }
}
