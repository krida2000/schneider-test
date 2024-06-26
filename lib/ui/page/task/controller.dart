import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '/domain/model/task.dart';
import '/store/task.dart';
import '/utils/obs_list.dart';

class TasksController extends GetxController {
  TasksController(
    this._taskRepository, {
    required this.removeBuilder,
  });

  final GlobalKey<AnimatedListState> tasksListKey =
      GlobalKey<AnimatedListState>();

  final GlobalKey<AnimatedListState> doneTasksListKey =
      GlobalKey<AnimatedListState>();

  final Rx<TaskTab> tab = Rx(TaskTab.main);

  final PageController pageController = PageController();

  final Widget Function(BuildContext, Animation<double>, Task) removeBuilder;

  StreamSubscription? tasksSubscription;

  StreamSubscription? doneTasksSubscription;

  final TaskRepository _taskRepository;

  ObsList<Rx<Task>> get tasks => _taskRepository.tasks;

  ObsList<Rx<Task>> get doneTasks => _taskRepository.doneTasks;

  @override
  void onInit() {
    tasksSubscription = tasks.changes.listen((e) {
      switch (e.op) {
        case OperationKind.added:
          tasksListKey.currentState?.insertItem(e.pos);
          break;
        case OperationKind.removed:
          tasksListKey.currentState?.removeItem(
            e.pos,
            (context, animation) =>
                removeBuilder(context, animation, e.element.value),
          );
          break;
        case OperationKind.updated:
          // TODO: Implement updated
          break;
      }
    });

    doneTasksSubscription = doneTasks.changes.listen((e) {
      switch (e.op) {
        case OperationKind.added:
          doneTasksListKey.currentState?.insertItem(e.pos);
          break;
        case OperationKind.removed:
          doneTasksListKey.currentState?.removeItem(
            e.pos,
            (context, animation) =>
                removeBuilder(context, animation, e.element.value),
          );
          break;
        case OperationKind.updated:
          // TODO: Implement updated
          break;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    tasksSubscription?.cancel();
    super.onClose();
  }

  Future<void> remove(TaskId id) async => _taskRepository.remove(id);

  Future<void> updateDone(TaskId id, bool done) async =>
      _taskRepository.updateDone(id, done);

  Future<void> updateTask(TaskId id, String title) async =>
      _taskRepository.update(id, title);
}

enum TaskTab {
  main,
  done,
}
