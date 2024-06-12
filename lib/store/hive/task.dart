import 'dart:async';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '/domain/model/task.dart';

class HiveTaskProvider extends DisposableInterface {
  late Box<Task> _box;

  bool _isReady = false;

  Box<Task> get box => _box;

  bool get isEmpty => box.isEmpty;

  Stream<BoxEvent> get boxEvents => box.watch();

  bool get isReady => _isReady;

  String get boxName => 'tasks';

  Iterable<dynamic> get keysSafe {
    if (_isReady && _box.isOpen) {
      return box.keys;
    }
    return [];
  }

  Iterable<Task> get valuesSafe {
    if (_isReady && _box.isOpen) {
      return box.values;
    }
    return [];
  }

  Future<void> init() async {
    registerAdapters();

    try {
      _box = await Hive.openBox<Task>(boxName);
    } catch (e) {
      await Future.delayed(Duration.zero);
      await Hive.deleteBoxFromDisk(boxName);
      _box = await Hive.openBox<Task>(boxName);
    }
    _isReady = true;
  }

  void registerAdapters() {
    Hive.registerAdapter(TaskAdapter());
  }

  Future<void> clear() async {
    if (_isReady && _box.isOpen) {
      await box.clear();
    }
  }

  Future<void> close() async {
    if (_isReady && _box.isOpen) {
      _isReady = false;

      await _box.close();
    }
  }

  @override
  void onClose() async {
    await close();
    super.onClose();
  }

  Future<void> put(Task value) async {
    if (_isReady && _box.isOpen) {
      await _box.put(value.id, value);
    }
  }

  Task? getSafe(dynamic key, {Task? defaultValue}) {
    if (_isReady && _box.isOpen) {
      return box.get(key, defaultValue: defaultValue);
    }
    return null;
  }

  Future<void> delete(dynamic key, {Task? defaultValue}) async {
    if (_isReady && _box.isOpen) {
      await _box.delete(key);
    }
  }

  Future<void> deleteAt(int index) async {
    if (_isReady && _box.isOpen) {
      await box.deleteAt(index);
    }
  }
}
