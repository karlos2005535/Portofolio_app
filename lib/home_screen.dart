import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profile dengan Gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade700, Colors.teal.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1511367461989-f85a21fda167?w=400&q=80',
                    ),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Thomas Carlos Baco',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'IT Student | Full-Stack Developer',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Kartu Informasi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                elevation: 4,
                shadowColor: Colors.teal.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About Me',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Mahasiswa Teknologi Informasi tingkat akhir di Universitas Pendidikan Nasional. Berpengalaman dalam pengembangan aplikasi berbasis web, mobile (Flutter), dan integrasi IoT.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                      const Divider(height: 40),
                      Text(
                        'Technical Skills',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildSkillChip('Flutter'),
                          _buildSkillChip('Angular'),
                          _buildSkillChip('PHP / API'),
                          _buildSkillChip('Python'),
                          _buildSkillChip('IoT / ESP32'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Colors.teal.shade50,
      side: BorderSide(color: Colors.teal.shade200),
    );
  }
}
