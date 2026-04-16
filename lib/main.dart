import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _defaultImageUrl =
      'https://images.unsplash.com/photo-1511367461989-f85a21fda167?w=400&q=80';
  Uint8List? _selectedImageBytes;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickPhoto() async {
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickPhoto,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: _selectedImageBytes != null
                            ? MemoryImage(_selectedImageBytes!) as ImageProvider
                            : NetworkImage(_defaultImageUrl),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.teal,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Thomas Carlos Baco',
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'IT Student | Full-Stack Developer',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.teal.shade700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Universitas Pendidikan Nasional',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      ),
                      child: const Text('About Me'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProjectsScreen(),
                        ),
                      ),
                      child: const Text('My Projects'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String name = "Thomas Carlos Baco";
  String address = "Sesetan, Bali";
  String phone = "0812-3456-7890";
  String email = "thomas.carlos@email.com";
  String bio =
      "Mahasiswa Teknologi Informasi tingkat akhir di Universitas Pendidikan Nasional yang berfokus pada Full-Stack Development, DevOps, dan IoT.";
  List<String> skills = [
    "Flutter",
    "Angular",
    "Python",
    "IoT",
    "DevOps",
    "PHP",
    "Firebase",
  ];

  void _editPersonalData() {
    TextEditingController nameCtrl = TextEditingController(text: name);
    TextEditingController addrCtrl = TextEditingController(text: address);
    TextEditingController phoneCtrl = TextEditingController(text: phone);
    TextEditingController emailCtrl = TextEditingController(text: email);
    TextEditingController bioCtrl = TextEditingController(text: bio);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Data Pribadi'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: addrCtrl,
                decoration: const InputDecoration(labelText: 'Alamat'),
              ),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'No. Telpon'),
              ),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: bioCtrl,
                decoration: const InputDecoration(labelText: 'Bio'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                name = nameCtrl.text;
                address = addrCtrl.text;
                phone = phoneCtrl.text;
                email = emailCtrl.text;
                bio = bioCtrl.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _addSkill() {
    TextEditingController skillCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Skill'),
        content: TextField(
          controller: skillCtrl,
          decoration: const InputDecoration(hintText: 'Masukkan nama skill'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (skillCtrl.text.isNotEmpty) {
                setState(() => skills.add(skillCtrl.text));
              }
              Navigator.pop(context);
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Me'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editPersonalData,
            tooltip: 'Edit Profil',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? screenWidth * 0.15 : 24.0,
          vertical: 24.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontSize: 28),
            ),
            const Divider(),
            const SizedBox(height: 16),
            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                _buildInfoRow(Icons.location_on, address),
                _buildInfoRow(Icons.phone, phone),
                _buildInfoRow(Icons.email, email),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Ringkasan Profesional',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(bio, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Keahlian Teknis',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.teal,
                    size: 28,
                  ),
                  onPressed: _addSkill,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: skills
                  .map(
                    (skill) => Chip(
                      label: Text(skill),
                      deleteIconColor: Colors.red.shade400,
                      onDeleted: () {
                        setState(() => skills.remove(skill));
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.teal),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final List<Map<String, dynamic>> _projects = [
    {
      'title': 'E-Posyandu Application',
      'desc':
          'A comprehensive platform built with Angular and Firebase, featuring automated CI/CD deployment pipelines.',
      'image':
          'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&q=80',
      'bytes': null,
    },
    {
      'title': 'Coffee Plant IoT Monitoring',
      'desc':
          'An environmental monitoring system utilizing ESP32, MQTT, and Telegram bot integration for real-time soil and temperature data.',
      'image':
          'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=400&q=80',
      'bytes': null,
    },
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> _addOrEditProject({int? index}) async {
    String title = index != null ? _projects[index]['title'] : '';
    String desc = index != null ? _projects[index]['desc'] : '';
    Uint8List? imageBytes = index != null ? _projects[index]['bytes'] : null;
    String defaultImg = index != null
        ? _projects[index]['image']
        : 'https://images.unsplash.com/photo-1583508915901-b5f84c1dcde1?w=400&q=80';

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(index == null ? 'Tambah Projek' : 'Edit Projek'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Judul Projek'),
                  onChanged: (v) => title = v,
                  controller: TextEditingController(text: title),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Singkat',
                  ),
                  onChanged: (v) => desc = v,
                  controller: TextEditingController(text: desc),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final XFile? picked = await _picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (picked != null) {
                        final b = await picked.readAsBytes();
                        setDialogState(() => imageBytes = b);
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  },
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Pilih Foto dari Galeri'),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: imageBytes != null
                          ? MemoryImage(imageBytes!) as ImageProvider
                          : NetworkImage(defaultImg),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty) {
                  setState(() {
                    final data = {
                      'title': title,
                      'desc': desc,
                      'image': defaultImg,
                      'bytes': imageBytes,
                    };
                    if (index == null) {
                      _projects.add(data);
                    } else {
                      _projects[index] = data;
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Projects')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int count = constraints.maxWidth > 900
              ? 3
              : (constraints.maxWidth > 600 ? 2 : 1);
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: count,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: _projects.length,
            itemBuilder: (context, i) => Card(
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: _projects[i]['bytes'] != null
                              ? Image.memory(
                                  _projects[i]['bytes'],
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  _projects[i]['image'],
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.white70,
                            child: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.teal),
                              onPressed: () => _addOrEditProject(index: i),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _projects[i]['title'],
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _projects[i]['desc'],
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditProject(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Projek'),
      ),
    );
  }
}
