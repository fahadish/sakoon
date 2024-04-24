import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/task_model/task_model.dart';
import '../../services/task_services.dart';


class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];
  late SharedPreferences _prefs;

  TaskProvider() {
    _initPrefs();
  }

  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadTasks(); // Call _loadTasks after _prefs has been initialized
  }

  void _loadTasks() {
    final List<String>? taskJsonList = _prefs.getStringList('tasks');
    if (taskJsonList != null) {
      _tasks = taskJsonList.map((json) => Task.fromJson(jsonDecode(json))).toList();
    }
    notifyListeners(); // Notify listeners after loading tasks
  }

  Future<void> _saveTasks() async {
    final List<String> taskJsonList = _tasks.map((task) => jsonEncode(task.toJson())).toList();
    await _prefs.setStringList('tasks', taskJsonList);
  }

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks(int page) async {
    try {
      final tasks = await _taskService.fetchTasks(page);
      _tasks.addAll(tasks);
      await _saveTasks(); // Save tasks after fetching
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching tasks: $e');
      }
    }
    notifyListeners(); // Notify listeners after updating tasks
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      await _saveTasks();
      notifyListeners();
    }
  }

  Future<void> deleteTask(int taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    await _saveTasks();
    notifyListeners();
  }
}
