import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task_bloc.dart';
import '../blocs/task_event.dart';
import '../blocs/task_state.dart';
import '../models/task_model.dart'; // Tambahkan import model Task

class TaskDashboardView extends StatelessWidget {
  const TaskDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Master'),
        // Tambahan fitur refresh manual jika dibutuhkan
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
            // Tampilan jika data kosong
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
                    subtitle: Text(task.description),
                    trailing: Chip(label: Text(task.status)),
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

  // Fungsi untuk menampilkan form dialog
  void _showTaskDialog(BuildContext parentContext) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedStatus = 'To Do';

    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (stateContext, setState) {
            return AlertDialog(
              title: const Text('Tambah Tugas Baru'),
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
                    initialValue:
                        selectedStatus, // Menggunakan initialValue (bukan value)
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
                    // Validasi sederhana agar judul tidak kosong
                    if (titleCtrl.text.trim().isNotEmpty) {
                      final newTask = Task(
                        id: DateTime.now().millisecondsSinceEpoch
                            .toString(), // ID sementara
                        title: titleCtrl.text.trim(),
                        description: descCtrl.text.trim(),
                        status: selectedStatus,
                      );

                      // Mengirim event AddTask ke BLoC menggunakan parentContext
                      parentContext.read<TaskBloc>().add(AddTask(newTask));

                      // Tutup dialog
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
