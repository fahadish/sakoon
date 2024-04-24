// task_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model/task_model.dart';


class TaskService {
  final Uri baseUrl = Uri.parse('https://reqres.in/api/users'); // Convert String to Uri
  final String _taskKey = 'tasks';

  Future<List<Task>> fetchTasks(int page) async {
    final response = await http.get(baseUrl.replace(queryParameters: {'page': '$page'})); // Use baseUrl with query parameters
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> tasksJson = jsonData['data'];
      return tasksJson.map((taskJson) => Task.fromJson(taskJson)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> tasksJson = tasks.map((task) => json.encode(task.toJson())).toList();
    prefs.setStringList(_taskKey, tasksJson);
  }

  Future<List<Task>> getLocalTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? tasksJson = prefs.getStringList(_taskKey);
    if (tasksJson != null) {
      return tasksJson.map((taskJson) => Task.fromJson(json.decode(taskJson))).toList();
    } else {
      return [];
    }
  }
}