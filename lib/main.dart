import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Master',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        cardTheme: const CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      home: const TaskDashboard(),
    );
  }
}

class TaskDashboard extends StatefulWidget {
  const TaskDashboard({super.key});

  @override
  State<TaskDashboard> createState() => _TaskDashboardState();
}

class _TaskDashboardState extends State<TaskDashboard> {
  List tasks = [];
  bool isLoading = true;

  final String apiUrl = 'http://10.0.2.2/task_api/tasks.php';

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    print('--- MENGAMBIL DATA DARI DATABASE (GET) ---');
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Data Diterima: ${response.body}');
        setState(() {
          tasks = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('ERROR KONEKSI GET: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> addTask(String title, String desc) async {
    print('--- MENGIRIM DATA KE DATABASE (POST) ---');
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "title": title,
          "description": desc,
          "status": "To Do",
        }),
      );
      print('Status Code: ${response.statusCode}');
      print('Respons Server: ${response.body}');

      if (response.statusCode == 200) {
        fetchTasks();
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('ERROR KONEKSI POST: $e');
      setState(() => isLoading = false);
    }
  }

  void _showAddTaskDialog() {
    TextEditingController titleCtrl = TextEditingController();
    TextEditingController descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Tambah Tugas Baru',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                labelText: 'Judul Tugas',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                addTask(titleCtrl.text, descCtrl.text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Simpan Tugas'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Master',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
            onPressed: () {
              setState(() => isLoading = true);
              fetchTasks();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            )
          : tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada tugas.',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const Text(
                    'Pastikan server XAMPP menyala!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.assignment,
                        color: Colors.deepPurple.shade400,
                      ),
                    ),
                    title: Text(
                      task['title'] ?? 'Tanpa Judul',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task['description'] ?? '',
                            style: const TextStyle(height: 1.4),
                          ),
                          const SizedBox(height: 12),
                          Chip(
                            label: Text(
                              task['status'] ?? 'To Do',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: task['status'] == 'Done'
                                    ? Colors.green.shade800
                                    : Colors.orange.shade800,
                              ),
                            ),
                            backgroundColor: task['status'] == 'Done'
                                ? Colors.green.shade100
                                : Colors.orange.shade100,
                            side: BorderSide.none,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text(
          'Tugas Baru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
