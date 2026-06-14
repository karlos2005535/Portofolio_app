import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Tambahan untuk debugPrint
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';
import '../services/websocket_service.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final ApiService _apiService;
  final WebSocketService _webSocketService;
  late StreamSubscription _wsSubscription;

  TaskBloc({
    required ApiService apiService,
    required WebSocketService webSocketService,
  }) : _apiService = apiService,
       _webSocketService = webSocketService,
       super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<UpdateTaskStatus>(_onUpdateTaskStatus);
    on<NotificationReceived>(_onNotificationReceived);

    // MENDENGARKAN STREAM WEBSOCKET
    _wsSubscription = _webSocketService.notificationStream.listen(
      (event) {
        // Print ini akan muncul di Debug Console VS Code saat pesan memantul dari server!
        debugPrint("🟢 WEBSOCKET MENERIMA PESAN: $event");

        final data = jsonDecode(event);
        String msg = '';

        if (data['action'] == 'add') {
          msg = 'Tugas baru: ${data['detail']}';
        } else if (data['action'] == 'update_status') {
          msg = 'Status diperbarui menjadi: ${data['detail']}';
        }

        if (msg.isNotEmpty) {
          add(NotificationReceived(msg));
        }
      },
      onError: (error) {
        debugPrint("🔴 WEBSOCKET ERROR: $error");
      },
    );
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading()); //BLoC memerintahkan UI untuk Loading
    try {
      final tasks = await _apiService.fetchTasks();
      emit(TaskLoaded(tasks)); // BLoC memerintahkan UI untuk menampilkan data
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onNotificationReceived(
    NotificationReceived event,
    Emitter<TaskState> emit,
  ) async {
    // PERBAIKAN 1: Pancing dengan Loading agar Equatable mendeteksi adanya perubahan State
    emit(TaskLoading());
    try {
      // Ambil data terbaru karena ada update dari WebSocket
      final tasks = await _apiService.fetchTasks();
      emit(TaskLoaded(tasks, notification: event.message)); // Memicu SnackBar!
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    final success = await _apiService.addTask(event.task);
    if (success) {
      // PERBAIKAN 2: Hanya kirim ke WebSocket. Jangan panggil add(LoadTasks()) di sini!
      // Biarkan gema dari WebSocket yang nantinya akan memicu _onNotificationReceived
      _webSocketService.sendNotification('add', event.task.title);
    } else {
      emit(const TaskError('Gagal menambahkan tugas'));
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
      // PERBAIKAN 3: Hanya kirim ke WebSocket. Jangan panggil add(LoadTasks()) di sini!
      _webSocketService.sendNotification('update_status', event.newStatus);
    } else {
      emit(const TaskError('Gagal memperbarui status tugas'));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    final success = await _apiService.updateTask(event.task);
    if (success) add(LoadTasks());
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    final success = await _apiService.deleteTask(event.taskId);
    if (success) add(LoadTasks());
  }

  @override
  Future<void> close() {
    _wsSubscription.cancel();
    _webSocketService.dispose();
    return super.close();
  }
}
