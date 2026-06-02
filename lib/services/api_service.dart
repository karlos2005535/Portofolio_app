import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class ApiService {
  static const String apiUrl = 'http://10.0.2.2/task_api/tasks.php';

  Future<List<Task>> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Task.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(task.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTask(Task task) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl?id=${task.id}'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(task.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteTask(String taskId) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl?id=$taskId'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTaskStatus(String taskId, String newStatus) async {
    try {
      final response = await http.patch(
        Uri.parse('$apiUrl?id=$taskId'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"status": newStatus}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
