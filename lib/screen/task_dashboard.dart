import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task_model.dart';
import '../blocs/task_bloc.dart';
import '../blocs/task_event.dart';
import '../blocs/task_state.dart';

class TaskDashboard extends StatefulWidget {
  const TaskDashboard({super.key});

  @override
  State<TaskDashboard> createState() => _TaskDashboardState();
}

class _TaskDashboardState extends State<TaskDashboard> {
  @override
  void initState() {
    super.initState();
    // Kirim event pertama kali untuk mengambil data dari server
    context.read<TaskBloc>().add(LoadTasks());
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tambah Tugas Baru'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Judul Tugas'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                final newTask = Task(
                  title: titleCtrl.text,
                  description: descCtrl.text,
                  status: "To Do",
                );

                // Memicu event tambah tugas ke BLoC menggunakan build context induk
                context.read<TaskBloc>().add(AddTaskPressed(newTask));
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Master'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(110),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: TextField(
                    onChanged: (value) {
                      context.read<TaskBloc>().add(SearchQueryChanged(value));
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari tugas...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                // Filter Chips
                BlocBuilder<TaskBloc, TaskState>(
                  buildWhen: (previous, current) =>
                      previous.selectedFilter != current.selectedFilter,
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildChip(
                          context,
                          "Semua",
                          TaskStatusFilter.all,
                          state.selectedFilter,
                        ),
                        _buildChip(
                          context,
                          "To Do",
                          TaskStatusFilter.toDo,
                          state.selectedFilter,
                        ),
                        _buildChip(
                          context,
                          "Done",
                          TaskStatusFilter.done,
                          state.selectedFilter,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.filteredTasks.isEmpty) {
              return const Center(child: Text('Tidak ada tugas ditemukan.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.filteredTasks.length,
              itemBuilder: (context, index) {
                final task = state.filteredTasks[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(task.description),
                    trailing: Text(
                      task.status,
                      style: TextStyle(
                        color: task.status == "Done"
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddTaskDialog(context),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    String label,
    TaskStatusFilter filterValue,
    TaskStatusFilter currentSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: currentSelected == filterValue,
        onSelected: (isSelected) {
          if (isSelected) {
            context.read<TaskBloc>().add(FilterChanged(filterValue));
          }
        },
      ),
    );
  }
}
