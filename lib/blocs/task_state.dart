import 'package:equatable/equatable.dart';
import '../models/task_model.dart';

// Representasi pilihan filter status tugas
enum TaskStatusFilter { all, toDo, done }

class TaskState extends Equatable {
  final List<Task> allTasks;
  final List<Task> filteredTasks;
  final bool isLoading;
  final String searchQuery;
  final TaskStatusFilter selectedFilter;
  final String? errorMessage;

  const TaskState({
    this.allTasks = const [],
    this.filteredTasks = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.selectedFilter = TaskStatusFilter.all,
    this.errorMessage,
  });

  // Fungsi untuk menduplikasi state lama dengan perubahan nilai yang baru
  TaskState copyWith({
    List<Task>? allTasks,
    List<Task>? filteredTasks,
    bool? isLoading,
    String? searchQuery,
    TaskStatusFilter? selectedFilter,
    String? errorMessage,
  }) {
    return TaskState(
      allTasks: allTasks ?? this.allTasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      errorMessage: errorMessage, // Otomatis reset atau ganti dengan pesan baru
    );
  }

  @override
  List<Object?> get props => [
    allTasks,
    filteredTasks,
    isLoading,
    searchQuery,
    selectedFilter,
    errorMessage,
  ];
}
