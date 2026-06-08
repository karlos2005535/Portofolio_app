import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';
import '../models/task_model.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final ApiService _apiService;

  TaskBloc({required ApiService apiService})
    : _apiService = apiService,
      super(const TaskState()) {
    // Registrasi setiap Event ke fungsi Handler-nya masing-masing
    on<LoadTasks>(_onLoadTasks);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<FilterChanged>(_onFilterChanged);
    on<AddTaskPressed>(_onAddTaskPressed);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final tasks = await _apiService.fetchTasks();
      final filtered = _applyFilterAndSearch(
        tasks,
        state.searchQuery,
        state.selectedFilter,
      );
      emit(
        state.copyWith(
          allTasks: tasks,
          filteredTasks: filtered,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<TaskState> emit,
  ) {
    final filtered = _applyFilterAndSearch(
      state.allTasks,
      event.query,
      state.selectedFilter,
    );
    emit(state.copyWith(searchQuery: event.query, filteredTasks: filtered));
  }

  void _onFilterChanged(FilterChanged event, Emitter<TaskState> emit) {
    final filtered = _applyFilterAndSearch(
      state.allTasks,
      state.searchQuery,
      event.filter,
    );
    emit(state.copyWith(selectedFilter: event.filter, filteredTasks: filtered));
  }

  Future<void> _onAddTaskPressed(
    AddTaskPressed event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final success = await _apiService.addTask(event.task);
      if (success) {
        // Jika API sukses merespon, langsung panggil ulang data terbaru
        add(LoadTasks());
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: "Gagal menyimpan tugas: $e"));
    }
  }

  // Fungsi murni pemisah logika filtering (diadaptasi dari kode lamamu)
  List<Task> _applyFilterAndSearch(
    List<Task> tasks,
    String query,
    TaskStatusFilter filter,
  ) {
    List<Task> results = tasks;

    if (filter == TaskStatusFilter.toDo) {
      results = results.where((task) => task.status == "To Do").toList();
    } else if (filter == TaskStatusFilter.done) {
      results = results.where((task) => task.status == "Done").toList();
    }

    if (query.isNotEmpty) {
      results = results
          .where(
            (task) =>
                task.title.toLowerCase().contains(query.toLowerCase()) ||
                task.description.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    return results;
  }
}
