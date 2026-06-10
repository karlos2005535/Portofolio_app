import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;

  WebSocketService() {
    _connect();
  }

  void _connect() {
    // Pastikan backend WebSocket server (misal Ratchet) berjalan di port ini
    _channel = WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:8080'));
  }

  // Menggunakan Stream sesuai spesifikasi untuk menangkap WebSocket
  Stream<dynamic> get taskUpdates => _channel.stream;

  void dispose() {
    _channel.sink.close();
  }
}
