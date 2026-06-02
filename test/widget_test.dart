import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:portfolio_app/main.dart';
import 'package:portfolio_app/bloc/task_bloc.dart';
import 'package:portfolio_app/services/api_service.dart';
import 'package:portfolio_app/models/task_model.dart';

@GenerateMocks([ApiService])
void main() {
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
  });

  group('Task Manager App Tests', () {
    testWidgets('Memastikan Task Manager berjalan (Smoke Test)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const TaskManagerApp());

      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Menampilkan judul Task Master di AppBar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const TaskManagerApp());

      await tester.pumpAndSettle();

      expect(find.text('Task Master'), findsOneWidget);
    });

    testWidgets('Menampilkan tombol floating action button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const TaskManagerApp());

      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Tugas Baru'), findsOneWidget);
    });

    testWidgets('Menampilkan tombol refresh di AppBar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const TaskManagerApp());

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });
  });
}
