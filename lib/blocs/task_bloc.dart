import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart'; // Import service-nya!
import 'task_event.dart';
import 'task_state.dart';

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
      emit(const TaskError('Failed to add task'));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    final success = await _apiService.updateTask(event.task);
    if (success) {
      add(LoadTasks());
    } else {
      emit(const TaskError('Failed to update task'));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    final success = await _apiService.deleteTask(event.taskId);
    if (success) {
      add(LoadTasks());
    } else {
      emit(const TaskError('Failed to delete task'));
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
      emit(const TaskError('Failed to update task status'));
    }
  }
}
