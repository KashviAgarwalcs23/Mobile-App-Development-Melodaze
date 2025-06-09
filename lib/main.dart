import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/pages/login_page.dart'; // Import LoginPage
import 'package:untitled/pages/main_screen.dart';
import 'package:untitled/models/playlist_provider.dart';
import 'package:untitled/themes/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled/models/supabase_playlist_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://gmjqsutzjtsdqygxjuqn.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdtanFzdXR6anRzZHF5Z3hqdXFuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg4NzA0MjksImV4cCI6MjA2NDQ0NjQyOX0.aWqsruTtGLnpeOpWboMh9ASoOHPmXJ2ktyxZGDfDCrY',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => PlaylistProvider()),
        ChangeNotifierProvider(create: (_) => SupabasePlaylistProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          final user = Supabase.instance.client.auth.currentUser;
          if (user == null) {
            return const LoginPage();
          } else {
            return const MainScreen();
          }
        },
      ),
      title: 'Melodaze',
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}