import 'package:flutter/material.dart';

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                const CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1511367461989-f85a21fda167?w=400&q=80',
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutScreen(),
                          ),
                        );
                      },
                      child: const Text('About Me'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProjectsScreen(),
                          ),
                        );
                      },
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

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('About Me')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Flex(
          direction: isDesktop ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: isDesktop ? 1 : 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Professional Summary',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'I am a final-year Information Technology student with a strong focus on full-stack development, DevOps, and IoT. I have experience leading project teams, implementing CI/CD pipelines, and integrating hardware with software solutions.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            if (isDesktop)
              const SizedBox(width: 40)
            else
              const SizedBox(height: 32),
            Expanded(
              flex: isDesktop ? 1 : 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Technical Skills',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(label: Text('Flutter & Dart')),
                      Chip(label: Text('Angular & PHP')),
                      Chip(label: Text('Python & PySpark')),
                      Chip(label: Text('IoT & MQTT')),
                      Chip(label: Text('Git & GitLab CI/CD')),
                      Chip(label: Text('Firebase')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> projects = [
      {
        'title': 'E-Posyandu Application',
        'description':
            'A comprehensive platform built with Angular and Firebase, featuring automated CI/CD deployment pipelines.',
        'image':
            'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&q=80',
      },
      {
        'title': 'Coffee Plant IoT Monitoring',
        'description':
            'An environmental monitoring system utilizing ESP32, MQTT, and Telegram bot integration for real-time soil and temperature data.',
        'image':
            'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=400&q=80',
      },
      {
        'title': 'Stationery Supplier Web App',
        'description':
            'An e-commerce and supplier management website developed using Agile Scrum methodologies.',
        'image':
            'https://images.unsplash.com/photo-1583508915901-b5f84c1dcde1?w=400&q=80',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Projects')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 800
              ? 3
              : (constraints.maxWidth > 500 ? 2 : 1);
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.network(
                        projects[index]['image']!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            projects[index]['title']!,
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(fontSize: 18),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            projects[index]['description']!,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
