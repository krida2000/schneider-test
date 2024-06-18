import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '/domain/model/task.dart';
import '/store/task.dart';

class EditTasksController extends GetxController {
  EditTasksController(this.taskRepository, this.task);

  Task task;

  TaskRepository taskRepository;

  TextEditingController titleController = TextEditingController();

  RxBool isValid = RxBool(false);

  @override
  void onInit() {
    titleController
        .addListener(() => isValid.value = titleController.text.isNotEmpty);
    titleController.text = task.title;
    super.onInit();
  }

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }

  void editTask() {
    if (titleController.text.isNotEmpty) {
      taskRepository.update(task.id, titleController.text);
    }
  }

  void removeItem() {}
}
