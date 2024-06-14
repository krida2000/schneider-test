import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/domain/model/task.dart';
import 'add/view.dart';
import 'controller.dart';
import 'widget/keep_alive.dart';
import 'widget/task.dart';

class TasksView extends StatelessWidget {
  const TasksView({super.key});

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
                      Task task = c.tasks[i];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TaskView(
                          task: task,
                          animation: animation,
                          onDelete: () => c.remove(task.id),
                          onEdit: () async => {},
                          onDoneUpdate: (done) => c.updateDone(task.id, done),
                        ),
                      );
                    },
                  ),
                ),
                KeepAliveWidget(
                  child: AnimatedList(
                    key: c.doneTasksListKey,
                    initialItemCount: c.doneTasks.length,
                    itemBuilder: (_, i, animation) {
                      Task task = c.doneTasks[i];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TaskView(
                          task: task,
                          animation: animation,
                          onDelete: () => c.remove(task.id),
                          onEdit: () async => {},
                          onDoneUpdate: (done) => c.updateDone(task.id, done),
                        ),
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
