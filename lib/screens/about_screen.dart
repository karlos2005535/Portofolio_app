import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Me'),
      ),
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
                  Text('Professional Summary', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Text(
                    'I am a final-year Information Technology student with a strong focus on full-stack development, DevOps, and IoT. I have experience leading project teams, implementing CI/CD pipelines, and integrating hardware with software solutions.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            if (isDesktop) const SizedBox(width: 40) else const SizedBox(height: 32),
            Expanded(
              flex: isDesktop ? 1 : 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Technical Skills', style: Theme.of(context).textTheme.titleLarge),
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