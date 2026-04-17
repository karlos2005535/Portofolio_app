import 'package:flutter/material.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> projects = [
      {
        'title': 'E-Posyandu Application',
        'desc': 'Platform Angular & Firebase dengan CI/CD otomatis.',
        'img':
            'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&q=80',
      },
      {
        'title': 'IoT Coffee Plant',
        'desc': 'Monitoring suhu dan tanah via ESP32 & Telegram.',
        'img':
            'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=400&q=80',
      },
      {
        'title': 'Web Supplier Alat Tulis',
        'desc': 'Sistem manajemen e-commerce dengan metode Agile Scrum.',
        'img':
            'https://images.unsplash.com/photo-1583508915901-b5f84c1dcde1?w=400&q=80',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Projects'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Image.network(
                    projects[index]['img']!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          projects[index]['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          projects[index]['desc']!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
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
    );
  }
}
