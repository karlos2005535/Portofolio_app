import 'package:flutter/material.dart';

void main() {
  runApp(const MyPortfolioApp());
}

class MyPortfolioApp extends StatelessWidget {
  const MyPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tom\'s Workspace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          secondary: Colors.deepPurple,
          brightness: Brightness.light,
          surfaceTint: Colors.white, // Membuat background card lebih bersih
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: Colors.teal.withOpacity(0.2),
        ),
      ),
      home: const MainLayout(),
    );
  }
}

// ================= LAYOUT UTAMA DENGAN NAVIGASI =================
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // Daftar layar yang akan ditampilkan
  final List<Widget> _screens = const [
    HomeScreen(),
    ProjectsScreen(),
    TaskDashboard(),
  ];

  // Daftar nama layar untuk keperluan Print Log
  final List<String> _screenNames = ['Profile', 'Projects', 'Tasks'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Menambahkan Print sesuai permintaan
    print('✅ Berpindah ke menu: ${_screenNames[index]} (Index: $index)');
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: isDesktop
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onItemTapped,
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: Colors.teal.shade50,
                  selectedIconTheme: IconThemeData(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Profile'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.work_outline),
                      selectedIcon: Icon(Icons.work),
                      label: Text('Projects'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.task_alt_outlined),
                      selectedIcon: Icon(Icons.task_alt),
                      label: Text('Tasks'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: _screens[_selectedIndex]),
              ],
            )
          : _screens[_selectedIndex],
      bottomNavigationBar: isDesktop
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              backgroundColor: Colors.white,
              indicatorColor: Colors.teal.shade100,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person, color: Colors.teal),
                  label: 'Profile',
                ),
                NavigationDestination(
                  icon: Icon(Icons.work_outline),
                  selectedIcon: Icon(Icons.work, color: Colors.teal),
                  label: 'Projects',
                ),
                NavigationDestination(
                  icon: Icon(Icons.task_alt_outlined),
                  selectedIcon: Icon(Icons.task_alt, color: Colors.teal),
                  label: 'Tasks',
                ),
              ],
            ),
    );
  }
}

// ================= 1. HOME SCREEN (PROFILE) =================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.teal.shade200, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1511367461989-f85a21fda167?w=400&q=80',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Thomas Carlos Baco',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'IT Student | Full-Stack Developer',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.teal.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.school, color: Colors.teal),
                        title: Text('Universitas Pendidikan Nasional'),
                        subtitle: Text('Information Technology - Final Year'),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.location_on, color: Colors.teal),
                        title: Text('Bali, Indonesia'),
                        subtitle: Text('Available for Freelance'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _buildSkillChip('Flutter / Dart'),
                  _buildSkillChip('Angular'),
                  _buildSkillChip('PHP / MySQL'),
                  _buildSkillChip('IoT & Python'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.teal.shade200),
      avatar: const Icon(Icons.check_circle, size: 18, color: Colors.teal),
    );
  }
}

// ================= 2. PROJECTS SCREEN =================
class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> projects = [
      {
        'title': 'E-Posyandu Application',
        'desc':
            'A comprehensive platform built with Angular and Firebase with CI/CD.',
        'image':
            'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&q=80',
      },
      {
        'title': 'Coffee Plant IoT',
        'desc':
            'Environmental monitoring system using ESP32, MQTT, and Telegram.',
        'image':
            'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=400&q=80',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Portfolio Projects',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  projects[index]['image']!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        projects[index]['title']!,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        projects[index]['desc']!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: () => print(
                            'Melihat detail project: ${projects[index]['title']}',
                          ),
                          icon: const Icon(Icons.arrow_forward, size: 18),
                          label: const Text('View Details'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ================= 3. TASK DASHBOARD SCREEN =================
class TaskDashboard extends StatefulWidget {
  const TaskDashboard({super.key});

  @override
  State<TaskDashboard> createState() => _TaskDashboardState();
}

class _TaskDashboardState extends State<TaskDashboard> {
  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Draft Thesis Chapter 1',
      'status': 'In Progress',
      'color': Colors.blue,
    },
    {
      'title': 'Debug PySpark Script',
      'status': 'To Do',
      'color': Colors.orange,
    },
    {'title': 'Setup Database API', 'status': 'Done', 'color': Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Master',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade400, Colors.deepPurple.shade400],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.rocket_launch, color: Colors.white, size: 40),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ready to work, Tom?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'You have 2 pending tasks today.',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Recent Tasks', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _tasks[index]['color'].withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.assignment,
                          color: _tasks[index]['color'],
                        ),
                      ),
                      title: Text(
                        _tasks[index]['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(_tasks[index]['status']),
                      trailing: const Icon(Icons.more_vert),
                      onTap: () =>
                          print('Membuka tugas: ${_tasks[index]['title']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print('Tombol Tambah Tugas Ditekan');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Fitur tambah tugas siap diintegrasikan dengan API!',
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }
}
