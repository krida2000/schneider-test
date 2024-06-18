import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '/store/task.dart';

class AddTasksController extends GetxController {
  AddTasksController(this.taskRepository);

  TaskRepository taskRepository;

  TextEditingController titleController = TextEditingController();

  RxBool isValid = RxBool(false);

  @override
  void onInit() {
    titleController
        .addListener(() => isValid.value = titleController.text.isNotEmpty);

    super.onInit();
  }

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }

  void addTask() {
    if (titleController.text.isNotEmpty) {
      taskRepository.add(titleController.text);
    }
  }

  void removeItem() {}
}
