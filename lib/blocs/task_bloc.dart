import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';
import '../services/websocket_service.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final ApiService apiService;
  final WebSocketService webSocketService;
  late StreamSubscription _webSocketSubscription;

  TaskBloc({required this.apiService, required this.webSocketService})
    : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    // ... event lainnya

    // Mendengarkan Stream dari WebSocket
    _webSocketSubscription = webSocketService.taskUpdates.listen((data) {
      // Jika ada broadcast dari backend, otomatis reload task
      add(LoadTasks());
    });
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await apiService.fetchTasks(); // Future (REST API HTTP)
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    final success = await apiService.addTask(event.task);
    if (!success) {
      emit(const TaskError('Failed to add task'));
    }
    // Tidak perlu add(LoadTasks()) secara manual jika WebSocket backend
    // mem-broadcast perubahan ke semua client.
  }

  @override
  Future<void> close() {
    _webSocketSubscription.cancel();
    webSocketService.dispose();
    return super.close();
  }
}
