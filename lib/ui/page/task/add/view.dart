import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schneider_test/ui/widget/popup.dart';

import 'controller.dart';

class AddTaskView extends StatelessWidget {
  const AddTaskView({super.key});

  static Future<void> show(BuildContext context) {
    return Popup.show(context: context, child: const AddTaskView());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AddTasksController(Get.find()),
      builder: (AddTasksController c) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const Key('Title'),
              controller: c.titleController,
              onSubmitted: (_) {
                c.addTask();
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
                key: const Key('AddTask'),
                onPressed: c.isValid.isTrue
                    ? () {
                        c.addTask();
                        Navigator.of(context).pop();
                      }
                    : null,
                child: const Text('Add'),
              );
            }),
          ],
        );
      },
    );
  }
}
