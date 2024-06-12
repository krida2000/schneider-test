import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schneider_test/ui/task/add/view.dart';

import 'controller.dart';

class TasksView extends StatelessWidget {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: TasksController(Get.find()),
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
                Obx(() {
                  return ListView.builder(
                    itemCount: c.tasks.length,
                    itemBuilder: (_, i) {
                      return ListTile(
                        title: Text(c.tasks[i].title),
                      );
                    },
                  );
                }),
                Obx(() {
                  return ListView.builder(
                    itemCount: c.doneTasks.length,
                    itemBuilder: (_, i) {
                      return ListTile(
                        title: Text(c.doneTasks[i].title),
                      );
                    },
                  );
                }),
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
