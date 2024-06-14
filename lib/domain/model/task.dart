import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  Task({required this.id, required this.title, this.done = false});

  @HiveField(0)
  final TaskId id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool done;
}

@HiveType(typeId: 1)
class TaskId {
  const TaskId(this.val);

  @HiveField(0)
  final String val;

  @override
  bool operator ==(Object other) => other is TaskId && other.val == val;

  @override
  int get hashCode => val.hashCode;
}
