import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/domain/model/task.dart';
import '/ui/widget/popup.dart';
import 'controller.dart';

class EditTaskView extends StatelessWidget {
  const EditTaskView({super.key, required this.task});

  final Task task;

  static Future<void> show(BuildContext context, Task task) {
    return Popup.show(context: context, child: EditTaskView(task: task));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditTasksController(Get.find(), task),
      builder: (EditTasksController c) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const Key('Title'),
              controller: c.titleController,
              onSubmitted: (_) {
                c.editTask();
                Navigator.of(context).pop();
              },
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                label: Text('Title'),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              return OutlinedButton(
                key: const Key('EditTask'),
                onPressed: c.isValid.isTrue
                    ? () {
                        c.editTask();
                        Navigator.of(context).pop();
                      }
                    : null,
                child: const Text('Submit'),
              );
            }),
          ],
        );
      },
    );
  }
}
