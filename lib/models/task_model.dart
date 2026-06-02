import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(const TaskManagerApp());

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Master',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const TaskDashboard(),
    );
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final String status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'To Do',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "status": status,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}

abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;
  const AddTask(this.task);
  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;
  const UpdateTask(this.task);
  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TaskEvent {
  final String taskId;
  const DeleteTask(this.taskId);
  @override
  List<Object?> get props => [taskId];
}

class UpdateTaskStatus extends TaskEvent {
  final String taskId;
  final String newStatus;
  const UpdateTaskStatus(this.taskId, this.newStatus);
  @override
  List<Object?> get props => [taskId, newStatus];
}

abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  const TaskLoaded(this.tasks);
  @override
  List<Object?> get props => [tasks];
}

class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);
  @override
  List<Object?> get props => [message];
}

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

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final ApiService _apiService;

  TaskBloc({required ApiService apiService})
    : _apiService = apiService,
      super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<UpdateTaskStatus>(_onUpdateTaskStatus);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await _apiService.fetchTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    final success = await _apiService.addTask(event.task);
    if (success) {
      add(LoadTasks());
    } else {
      emit(TaskError('Failed to add task'));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    final success = await _apiService.updateTask(event.task);
    if (success) {
      add(LoadTasks());
    } else {
      emit(TaskError('Failed to update task'));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    final success = await _apiService.deleteTask(event.taskId);
    if (success) {
      add(LoadTasks());
    } else {
      emit(TaskError('Failed to delete task'));
    }
  }

  Future<void> _onUpdateTaskStatus(
    UpdateTaskStatus event,
    Emitter<TaskState> emit,
  ) async {
    final success = await _apiService.updateTaskStatus(
      event.taskId,
      event.newStatus,
    );
    if (success) {
      add(LoadTasks());
    } else {
      emit(TaskError('Failed to update task status'));
    }
  }
}

class TaskDashboard extends StatelessWidget {
  const TaskDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(apiService: ApiService())..add(LoadTasks()),
      child: const TaskDashboardView(),
    );
  }
}

class TaskDashboardView extends StatelessWidget {
  const TaskDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Master'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<TaskBloc>().add(LoadTasks()),
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            if (state.tasks.isEmpty) {
              return const Center(child: Text('Belum ada tugas.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.description),
                        const SizedBox(height: 4),
                        Chip(
                          label: Text(task.status),
                          backgroundColor: _getStatusColor(task.status),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PopupMenuButton<String>(
                          onSelected: (newStatus) {
                            context.read<TaskBloc>().add(
                              UpdateTaskStatus(task.id, newStatus),
                            );
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'To Do',
                              child: Text('To Do'),
                            ),
                            const PopupMenuItem(
                              value: 'In Progress',
                              child: Text('In Progress'),
                            ),
                            const PopupMenuItem(
                              value: 'Done',
                              child: Text('Done'),
                            ),
                          ],
                          child: const Icon(Icons.more_vert),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Hapus Tugas'),
                                content: const Text(
                                  'Apakah Anda yakin ingin menghapus tugas ini?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.read<TaskBloc>().add(
                                        DeleteTask(task.id),
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Hapus',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () => _showTaskDialog(context, task: task),
                  ),
                );
              },
            );
          } else if (state is TaskError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<TaskBloc>().add(LoadTasks()),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTaskDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Tugas Baru'),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'To Do':
        return Colors.grey;
      case 'In Progress':
        return Colors.orange;
      case 'Done':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  void _showTaskDialog(BuildContext context, {Task? task}) {
    final titleCtrl = TextEditingController(text: task?.title ?? '');
    final descCtrl = TextEditingController(text: task?.description ?? '');
    String selectedStatus = task?.status ?? 'To Do';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(task == null ? 'Tambah Tugas Baru' : 'Edit Tugas'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Judul'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    items: const [
                      DropdownMenuItem(value: 'To Do', child: Text('To Do')),
                      DropdownMenuItem(
                        value: 'In Progress',
                        child: Text('In Progress'),
                      ),
                      DropdownMenuItem(value: 'Done', child: Text('Done')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Status'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleCtrl.text.isNotEmpty) {
                      final newTask = Task(
                        id:
                            task?.id ??
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleCtrl.text,
                        description: descCtrl.text,
                        status: selectedStatus,
                      );
                      if (task == null) {
                        context.read<TaskBloc>().add(AddTask(newTask));
                      } else {
                        context.read<TaskBloc>().add(UpdateTask(newTask));
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
