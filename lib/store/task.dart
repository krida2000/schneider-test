import 'package:schneider_test/utils/obs_list.dart';
import 'package:uuid/uuid.dart';

import '../domain/model/task.dart';
import 'hive/task.dart';

class TaskRepository {
  TaskRepository(this.hiveTaskProvider);

  HiveTaskProvider hiveTaskProvider;

  ObsList<Task> tasks = ObsList<Task>();

  ObsList<Task> doneTasks = ObsList<Task>();

  void init() {
    tasks.addAll(hiveTaskProvider.valuesSafe.where((task) => !task.done));
    doneTasks.addAll(hiveTaskProvider.valuesSafe.where((task) => task.done));
  }

  void add(String title) {
    Task task = Task(id: TaskId(const Uuid().v4()), title: title);

    tasks.add(task);
    hiveTaskProvider.put(task);
  }

  void remove(TaskId id) {
    tasks.removeWhere((task) => task.id == id);
    doneTasks.removeWhere((task) => task.id == id);
    hiveTaskProvider.delete(id);
  }

  void update(TaskId id, String title) {
    Task task = tasks.firstWhere((task) => task.id == id);
    task.title = title;
    hiveTaskProvider.put(task);
  }

  void updateDone(TaskId id, bool done) {
    Task task;
    if (done) {
      task = tasks.firstWhere((task) => task.id == id);
      task.done = done;
      tasks.remove(task);
      doneTasks.add(task);
    } else {
      task = doneTasks.firstWhere((task) => task.id == id);
      task.done = done;
      doneTasks.remove(task);
      tasks.add(task);
    }

    hiveTaskProvider.put(task);
  }
}
