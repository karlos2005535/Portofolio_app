import 'package:flutter/material.dart';

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
