import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

void main() {
  runApp(const TaskManagerApp());
}

// 1. PENGATURAN TEMA GLOBAL (Memenuhi kriteria Theming & Consistency)
class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Master',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

// Model Data Tugas
class Task {
  String id;
  String title;
  String description;
  String status;

  Task({required this.id, required this.title, required this.description, required this.status});
}

// SCREEN 1: DASHBOARD / HOME SCREEN (Memenuhi kriteria Navigation & Content)
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Data awal (dummy data) untuk simulasi
  List<Task> tasks = [
    Task(id: '1', title: 'Setup GitLab CI/CD', description: 'Konfigurasi pipeline otomatis untuk deployment aplikasi E-Posyandu.', status: 'In Progress'),
    Task(id: '2', title: 'Konfigurasi Sensor IoT', description: 'Integrasi ESP32 dengan sensor suhu dan pengiriman data ke bot Telegram.', status: 'To Do'),
    Task(id: '3', title: 'Selesaikan Skripsi Bab 1', description: 'Menyusun latar belakang terkait tracking distribusi waktu nyata.', status: 'Done'),
  ];

  void _addNewTask(String title, String description) {
    setState(() {
      tasks.add(Task(
        id: DateTime.now().toString(),
        title: title,
        description: description,
        status: 'To Do',
      ));
    });
  }

  void _showAddTaskDialog() {
    TextEditingController titleCtrl = TextEditingController();
    TextEditingController descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Tugas Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Judul Tugas')),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Deskripsi'), maxLines: 3),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                _addNewTask(titleCtrl.text, descCtrl.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Memenuhi kriteria Responsiveness
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Tugas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profil Saya',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ringkasan', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            // Layout Responsif: Baris di Desktop, Kolom/Grid di Mobile
            Flex(
              direction: isDesktop ? Axis.horizontal : Axis.vertical,
              children: [
                _buildSummaryCard('To Do', tasks.where((t) => t.status == 'To Do').length, Colors.orange),
                if (isDesktop) const SizedBox(width: 16) else const SizedBox(height: 16),
                _buildSummaryCard('In Progress', tasks.where((t) => t.status == 'In Progress').length, Colors.blue),
                if (isDesktop) const SizedBox(width: 16) else const SizedBox(height: 16),
                _buildSummaryCard('Done', tasks.where((t) => t.status == 'Done').length, Colors.green),
              ],
            ),
            const SizedBox(height: 24),
            Text('Daftar Tugas', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getStatusColor(task.status).withOpacity(0.2),
                        child: Icon(_getStatusIcon(task.status), color: _getStatusColor(task.status)),
                      ),
                      title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(task.status),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        // Navigasi ke Screen Detail Tugas
                        final updatedTask = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
                        );
                        if (updatedTask != null) {
                          setState(() {
                            tasks[index] = updatedTask;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(String title, int count, Color color) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Text(count.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'Done') return Colors.green;
    if (status == 'In Progress') return Colors.blue;
    return Colors.orange;
  }

  IconData _getStatusIcon(String status) {
    if (status == 'Done') return Icons.check_circle;
    if (status == 'In Progress') return Icons.autorenew;
    return Icons.assignment;
  }
}

// SCREEN 2: TASK DETAIL SCREEN
class TaskDetailScreen extends StatefulWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late String currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.task.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Judul Tugas', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(widget.task.title, style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24)),
            const Divider(height: 32),
            Text('Deskripsi', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(widget.task.description, style: Theme.of(context).textTheme.bodyLarge),
            const Divider(height: 32),
            Text('Status Saat Ini', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: currentStatus,
                  isExpanded: true,
                  items: ['To Do', 'In Progress', 'Done'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        currentStatus = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.task.status = currentStatus;
                  Navigator.pop(context, widget.task); // Mengirim data kembali ke Dashboard
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Simpan Perubahan', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SCREEN 3: PROFILE SCREEN (Dengan dukungan Image Picker)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _selectedImageBytes;
  final ImagePicker _picker = ImagePicker();
  final String _defaultAvatarUrl = 'https://images.unsplash.com/photo-1511367461989-f85a21fda167?w=400&q=80';

  Future<void> _pickAvatar() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickAvatar,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: _selectedImageBytes != null
                          ? MemoryImage(_selectedImageBytes!) as ImageProvider
                          : NetworkImage(_defaultAvatarUrl),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Thomas Carlos Baco', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 8),
              Text('IT Student / Developer', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.deepPurple)),
              const SizedBox(height: 16),
              const ListTile(
                leading: Icon(Icons.school, color: Colors.deepPurple),
                title: Text('Universitas Pendidikan Nasional'),
                subtitle: Text('Information Technology'),
              ),
              const ListTile(
                leading: Icon(Icons.email, color: Colors.deepPurple),
                title: Text('thomas.carlos@email.com'),
                subtitle: Text('Email Resmi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}