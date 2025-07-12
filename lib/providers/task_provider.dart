import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../model/task_model.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  List<Task> get importantTasks =>
      _tasks.where((task) => task.isImportant).toList();

  List<Task> get plannedTasks =>
      _tasks.where((task) => task.isPlanned).toList();

  /// Ambil semua task dari Firestore
  Future<void> fetchTasks(String uid) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('tasks')
            .get();

    _tasks.clear();
    for (var doc in snapshot.docs) {
      _tasks.add(Task.fromMap(doc.data()));
    }
    notifyListeners();
  }

  /// Tambah task baru
  Future<void> addTask(
    String uid,
    String title, {
    bool isImportant = false,
    bool isPlanned = false,
    String? subtitle,
  }) async {
    final task = Task(
      id: const Uuid().v4(),
      title: title,
      isImportant: isImportant,
      isPlanned: isPlanned,
      subtitle: subtitle,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(task.id)
        .set(task.toMap());

    _tasks.add(task);
    notifyListeners();
  }

  /// Update task
  Future<void> updateTask(String uid, Task task) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(task.id)
        .update(task.toMap());

    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  /// Hapus task
  Future<void> deleteTask(String uid, String taskId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .delete();

    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  /// ✅ Toggle status selesai
  Future<void> toggleTask(String uid, Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      isDone: !task.isDone,
      isImportant: task.isImportant,
      isPlanned: task.isPlanned,
      subtitle: task.subtitle,
    );

    await updateTask(uid, updatedTask);
  }

  /// ✅ Toggle status penting
  Future<void> toggleImportant(String uid, Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      isDone: task.isDone,
      isImportant: !task.isImportant,
      isPlanned: task.isPlanned,
      subtitle: task.subtitle,
    );

    await updateTask(uid, updatedTask);
  }

  /// ✅ Toggle status terencana
  Future<void> togglePlanned(String uid, Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      isDone: task.isDone,
      isImportant: task.isImportant,
      isPlanned: !task.isPlanned,
      subtitle: task.subtitle,
    );

    await updateTask(uid, updatedTask);
  }
}
