import 'package:equatable/equatable.dart';
import '../models/task_model.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial
    extends TaskState {} //masih memproses data, belum ada data yang ditampilkan

class TaskLoading extends TaskState {} //menampilkan data

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final String? notification; // Tambahan untuk memicu SnackBar

  const TaskLoaded(this.tasks, {this.notification});

  @override
  List<Object?> get props => [tasks, notification];
}

class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
