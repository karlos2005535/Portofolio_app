import 'package:equatable/equatable.dart';
import '../models/task_model.dart';
import 'task_state.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

// Event saat aplikasi pertama kali dibuka / memuat ulang data dari API
class LoadTasks extends TaskEvent {}

// Event saat pengguna mengetikkan kata kunci di Search Bar
class SearchQueryChanged extends TaskEvent {
  final String query;
  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

// Event saat pengguna menekan ChoiceChip (Semua / To Do / Done)
class FilterChanged extends TaskEvent {
  final TaskStatusFilter filter;
  const FilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

// Event saat pengguna menambahkan tugas baru melalui dialog
class AddTaskPressed extends TaskEvent {
  final Task task;
  const AddTaskPressed(this.task);

  @override
  List<Object?> get props => [task];
}
