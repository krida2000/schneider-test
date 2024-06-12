import 'package:get/get.dart';

import '/store/task.dart';
import '../../domain/model/task.dart';

class TasksController extends GetxController {
  TasksController(this.taskRepository);

  TaskRepository taskRepository;

  RxList<Task> get tasks => taskRepository.tasks;

  RxList<Task> get doneTasks => taskRepository.doneTasks;

  void addTask() {}

  void removeItem() {}
}
