import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/api_service.dart';
import 'services/websocket_service.dart';
import 'blocs/task_bloc.dart';
import 'blocs/task_event.dart';
import 'views/task_dashboard_view.dart';

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Master',
      home: BlocProvider(
        create: (context) => TaskBloc(
          apiService: ApiService(),
          webSocketService: WebSocketService(),
        )..add(LoadTasks()),
        child: const TaskDashboardView(),
      ),
    );
  }
}
