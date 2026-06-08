import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/api_service.dart';
import 'blocs/task_bloc.dart';
import 'screen/task_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Master',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      // Menyediakan BLoC secara global ke screen di bawahnya
      home: BlocProvider(
        create: (context) => TaskBloc(apiService: ApiService()),
        child: const TaskDashboard(),
      ),
    );
  }
}
