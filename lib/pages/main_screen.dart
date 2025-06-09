import 'package:flutter/material.dart';
import 'package:untitled/pages/homepage.dart';
import 'package:untitled/pages/settings_page.dart';
import 'package:untitled/pages/search_page.dart';
import 'package:untitled/pages/your_library.dart'; // Import the new page

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const YourLibraryPage(), // Add the new page here
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _animationController.reset();
      _animationController.forward();
    });
  }

  Widget _buildAnimatedIcon(IconData iconData, int index) {
    final bool isActive = _selectedIndex == index;
    final Color color = isActive ? Colors.white : Colors.grey;

    return ScaleTransition(
      scale: isActive ? _scaleAnimation : const AlwaysStoppedAnimation<double>(1.0),
      child: Icon(iconData, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withOpacity(0.8),
              Theme.of(context).colorScheme.surface.withOpacity(0.0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white, // Set selected label color to white
          unselectedItemColor: Colors.grey, // Set unselected label color to grey
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.home_outlined, 0),
              activeIcon: _buildAnimatedIcon(Icons.home_filled, 0),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.search_outlined, 1),
              activeIcon: _buildAnimatedIcon(Icons.search, 1),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.library_music_outlined, 2), // Added library icon
              activeIcon: _buildAnimatedIcon(Icons.library_music, 2), // Added active library icon
              label: 'Library', // Added library label
            ),
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.settings_outlined, 3), // Settings index is now 3
              activeIcon: _buildAnimatedIcon(Icons.settings, 3), // Active settings index is now 3
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}