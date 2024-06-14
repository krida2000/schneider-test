import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';

import '/domain/model/task.dart';

class TaskView extends StatelessWidget {
  const TaskView({
    super.key,
    required this.task,
    required this.animation,
    this.onDoneUpdate,
    this.onDelete,
    this.onEdit,
  });

  final Task task;

  final Animation<double> animation;

  final Future<void> Function(bool)? onDoneUpdate;

  final Future<void> Function()? onDelete;

  final Future<void> Function()? onEdit;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: ContextMenuRegion(
        contextMenu: GenericContextMenu(
          buttonConfigs: [
            if (task.done)
              ContextMenuButtonConfig(
                "Undone",
                onPressed: () => onDoneUpdate?.call(false),
              )
            else
              ContextMenuButtonConfig(
                "Done",
                onPressed: () => onDoneUpdate?.call(true),
              ),
            ContextMenuButtonConfig(
              "Delete",
              onPressed: () => onDelete?.call(),
            ),
            ContextMenuButtonConfig(
              "Edit",
              onPressed: () => onEdit?.call(),
            ),
          ],
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFE0E0E0),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: ListTile(title: Text(task.title)),
        ),
      ),
    );
  }
}
