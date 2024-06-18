import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/domain/model/task.dart';
import '/ui/page/task/edit/view.dart';
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
              bottom: TabBar(
                tabs: const [
                  Tab(icon: Icon(Icons.calendar_month)),
                  Tab(icon: Icon(Icons.task)),
                ],
                onTap: (i) => c.pageController.animateToPage(
                  i,
                  duration: 200.milliseconds,
                  curve: Curves.linear,
                ),
              ),
            ),
            body: PageView(
              controller: c.pageController,
              onPageChanged: (i) => c.tab.value = TaskTab.values[i],
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
            floatingActionButton: Obx(() {
              return c.tab.value == TaskTab.main
                  ? FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () => AddTaskView.show(context),
                    )
                  : const SizedBox();
            }),
          ),
        );
      },
    );
  }
}
