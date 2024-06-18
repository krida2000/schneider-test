import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schneider_test/ui/page/task/edit/view.dart';

import '/domain/model/task.dart';
import 'add/view.dart';
import 'controller.dart';
import 'widget/keep_alive.dart';
import 'widget/task.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: TasksController(
        Get.find(),
        removeBuilder: (_, animation, task) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TaskView(
              task: task,
              animation: animation,
            ),
          );
        },
      ),
      builder: (TasksController c) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.calendar_month)),
                  Tab(icon: Icon(Icons.task)),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                KeepAliveWidget(
                  child: AnimatedList(
                    key: c.tasksListKey,
                    initialItemCount: c.tasks.length,
                    itemBuilder: (_, i, animation) {
                      Rx<Task> task = c.tasks[i];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() {
                          return TaskView(
                            task: task.value,
                            animation: animation,
                            onDelete: () => c.remove(task.value.id),
                            onEdit: () =>
                                EditTaskView.show(context, task.value),
                            onDoneUpdate: (done) =>
                                c.updateDone(task.value.id, done),
                          );
                        }),
                      );
                    },
                  ),
                ),
                KeepAliveWidget(
                  child: AnimatedList(
                    key: c.doneTasksListKey,
                    initialItemCount: c.doneTasks.length,
                    itemBuilder: (_, i, animation) {
                      Rx<Task> task = c.doneTasks[i];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() {
                          return TaskView(
                            task: task.value,
                            animation: animation,
                            onDelete: () => c.remove(task.value.id),
                            onEdit: () async => {},
                            onDoneUpdate: (done) =>
                                c.updateDone(task.value.id, done),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => AddTaskView.show(context),
            ),
          ),
        );
      },
    );
  }
}
