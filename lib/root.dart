import 'package:neuronest/features/home/providers/child_provider.dart';
import 'package:neuronest/features/home/views/history_screen_view.dart';
import 'package:neuronest/features/home/views/home_screen_view.dart';
import 'package:neuronest/features/home/views/profile_screen_view.dart';
import 'package:neuronest/features/home/views/resource_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {

@override
void initState() {
  super.initState();

  Future.microtask(() {
    context.read<ChildProvider>().loadChild();
  });
}


  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AssessmentHistoryScreen(),
    const LearningResourcesScreen(),
    const AccountProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 6, 103, 168),
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
