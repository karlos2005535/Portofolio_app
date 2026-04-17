import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Pastikan nama package ini sesuai dengan nama di pubspec.yaml Anda
import 'package:portfolio_app/main.dart';

void main() {
  testWidgets('Memastikan Task Manager berjalan (Smoke Test)', (
    WidgetTester tester,
  ) async {
    // Build aplikasi Task Manager kita dan panggil frame pertama.
    await tester.pumpWidget(const TaskManagerApp());

    // Verifikasi bahwa halaman utama berhasil dimuat dengan mencari teks di AppBar.
    expect(find.text('Dashboard Tugas'), findsOneWidget);

    // Verifikasi bahwa kartu ringkasan 'To Do' juga muncul di layar.
    expect(find.text('To Do'), findsOneWidget);

    // Memastikan tidak ada teks error atau teks counter bawaan ('0').
    expect(find.text('0'), findsNothing);
  });
}
