import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF232526),
              Color(0xFF414345),
              Color(0xFF485563),
              Color(0xFF29323c),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.music_note, color: Colors.pinkAccent, size: 36),
                      const SizedBox(width: 10),
                      const Text(
                        'Melodaze',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Welcome to Melodaze!\n',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const Text(
                    'Melodaze is your modern, feature-rich music streaming companion. Discover trending tracks, explore genres, and enjoy curated playlists—all in a beautiful, intuitive interface.\n\n'
                    'Key Features:\n'
                    '• Dynamic song recommendations powered by the iTunes API\n'
                    '• Create, manage, and personalize your playlists\n'
                    '• Trending and favorite artists at your fingertips\n'
                    '• 30-second song previews\n'
                    '• Dark mode for a sleek look\n'
                    '• Supabase integration for cloud playlists\n'
                    '• Responsive and modern UI\n\n'
                    'Melodaze is built with love using Flutter, and is designed to make your music journey seamless and enjoyable.\n',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Credits:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text('• Music data powered by iTunes Search API', style: TextStyle(color: Colors.white70)),
                  const Text('• Built with Flutter & Supabase', style: TextStyle(color: Colors.white70)),
                  const Text('• UI inspired by modern music apps', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 24),
                  const Text('© 2025 Melodaze Team', style: TextStyle(color: Colors.white54)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 