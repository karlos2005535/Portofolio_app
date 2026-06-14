import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/api_service.dart';
import 'services/websocket_service.dart'; // INI IMPORT YANG KURANG
import 'blocs/task_bloc.dart';
import 'blocs/task_event.dart';
// Pastikan path ini sesuai dengan folder tempat kamu menyimpan UI-nya
import 'screen/task_dashboard.dart';

void main() => runApp(const TaskManagerApp());

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Master',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: BlocProvider(
        create: (context) => TaskBloc(
          apiService: ApiService(),
          webSocketService:
              WebSocketService(), // Sekarang tidak akan error merah lagi
        )..add(LoadTasks()),
        child: const TaskDashboardView(),
      ),
    );
  }
}
