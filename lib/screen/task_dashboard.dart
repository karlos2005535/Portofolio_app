import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task_bloc.dart';
import '../blocs/task_event.dart';
import '../blocs/task_state.dart';
import '../models/task_model.dart';

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
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskLoaded && state.notification != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.notifications_active, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.notification!)),
                  ],
                ),
                backgroundColor: Colors.deepPurple,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
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
                        // ==========================================
                        // PERBAIKAN DI TOMBOL HAPUS DIMULAI DI SINI
                        // ==========================================
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Simpan context utama ke variabel agar tidak tertimpa oleh dialog
                            final parentContext = context;

                            showDialog(
                              context: parentContext,
                              // Ubah nama context menjadi dialogContext
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('Hapus Tugas'),
                                content: const Text(
                                  'Apakah Anda yakin ingin menghapus tugas ini?',
                                ),
                                actions: [
                                  TextButton(
                                    // Gunakan dialogContext untuk menutup pop-up
                                    onPressed: () =>
                                        Navigator.pop(dialogContext),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Gunakan parentContext untuk mengakses BLoC
                                      parentContext.read<TaskBloc>().add(
                                        DeleteTask(task.id),
                                      );
                                      Navigator.pop(dialogContext);
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
                        // ==========================================
                        // PERBAIKAN SELESAI
                        // ==========================================
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

  void _showTaskDialog(BuildContext parentContext, {Task? task}) {
    final titleCtrl = TextEditingController(text: task?.title ?? '');
    final descCtrl = TextEditingController(text: task?.description ?? '');
    String selectedStatus = task?.status ?? 'To Do';

    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (stateContext, setState) {
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
                  onPressed: () => Navigator.pop(dialogContext),
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
                        parentContext.read<TaskBloc>().add(AddTask(newTask));
                      } else {
                        parentContext.read<TaskBloc>().add(UpdateTask(newTask));
                      }

                      Navigator.pop(dialogContext);
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
