import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/themes/theme_provider.dart';
import 'package:untitled/pages/login_page.dart'; // Import LoginPage
import 'package:untitled/pages/about_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _logout(BuildContext context) {
    // For now, just navigate back to the login page.
    // In a real app, you would handle session clearing, etc.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('S E T T I N G S'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            // Dark Mode Setting
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dark Mode',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  CupertinoSwitch(
                    value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
                    onChanged: (value) =>
                        Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Notifications Setting
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // For now, just a placeholder switch
                  CupertinoSwitch(
                    value: false, // You can manage this state later
                    onChanged: (value) {
                      // Handle notification settings change
                      print('Notifications toggled: $value');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Advertisement Setting
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Advertisement Preferences',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Placeholder for a more complex preference UI later
                  const Icon(Icons.arrow_forward_ios, size: 18),
                  // You might want to use an InkWell or GestureDetector to make it tappable
                ],
              ),
            ),
            const SizedBox(height: 15),

            // About Setting
            ListTile(
              title: Text('About'),
              trailing: Icon(Icons.info_outline),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
            const SizedBox(height: 30),

            // Logout Button
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}