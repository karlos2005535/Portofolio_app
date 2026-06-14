import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;

  WebSocketService() {
    // Sesuaikan IP dengan IP komputermu jika dicoba di HP fisik
    _channel = WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:8080'));
  }

  // Mendengarkan notifikasi masuk
  Stream<dynamic> get notificationStream => _channel.stream;

  // Fungsi untuk mengirim notifikasi ke server
  void sendNotification(String action, String detail) {
    final msg = jsonEncode({
      'action': action, // Contoh: 'add' atau 'update_status'
      'detail': detail, // Contoh: 'Judul Tugas' atau 'Status Selesai'
    });
    _channel.sink.add(msg);
  }

  void dispose() {
    _channel.sink.close();
  }
}
